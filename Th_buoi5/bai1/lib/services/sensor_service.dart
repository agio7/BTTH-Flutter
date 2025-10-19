import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

enum LightScenario {
  brightSunny,
  partlyCloudy,
  underTree,
  buildingShadow,
  indoor,
  night,
}

class SensorService {
  SensorService();

  // Stream controllers for sensor data
  final StreamController<double> _lightController = StreamController<double>.broadcast();
  final StreamController<double> _accelerationController = StreamController<double>.broadcast();
  final StreamController<double> _magneticController = StreamController<double>.broadcast();
  final StreamController<LocationData?> _locationController = StreamController<LocationData?>.broadcast();

  // Streams
  Stream<double> get lightStream => _lightController.stream;
  Stream<double> get accelerationStream => _accelerationController.stream;
  Stream<double> get magneticStream => _magneticController.stream;
  Stream<LocationData?> get locationStream => _locationController.stream;

  // Current values
  double _currentLight = 0.0;
  double _currentAcceleration = 0.0;
  double _currentMagnetic = 0.0;
  LocationData? _currentLocation;
  
  // Light simulation variables
  double _locationModifier = 0.0; // Modifier based on location
  double _screenCoverModifier = 0.0; // Modifier when screen is covered
  bool _isScreenCovered = false;
  bool _enableScreenCoverDetection = true; // Enable/disable screen cover detection

  // Subscriptions
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _lightSimulationTimer;

  // Location service
  final Location _location = Location();

  // Initialize sensors
  Future<bool> initializeSensors() async {
    try {
      // Request permissions
      bool hasPermission = await _requestPermissions();
      if (!hasPermission) return false;

      // Start accelerometer
      _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
        // Calculate magnitude: sqrt(x² + y² + z²)
        double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        _currentAcceleration = magnitude;
        _accelerationController.add(magnitude);
        
        // Detect if screen is covered (device face down)
        _detectScreenCoverage(event);
      });

      // Start magnetometer
      _magnetometerSubscription = magnetometerEventStream().listen((MagnetometerEvent event) {
        // Calculate magnitude: sqrt(x² + y² + z²)
        double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        _currentMagnetic = magnitude;
        _magneticController.add(magnitude);
      });

      // Start location service
      await _startLocationService();

      return true;
    } catch (e) {
      debugPrint('Error initializing sensors: $e');
      return false;
    }
  }

  // Request necessary permissions
  Future<bool> _requestPermissions() async {
    // Request location permission
    permission_handler.PermissionStatus locationStatus = await permission_handler.Permission.location.request();
    if (locationStatus != permission_handler.PermissionStatus.granted) {
      return false;
    }

    // Request storage permission for Android
    if (await permission_handler.Permission.storage.isDenied) {
      permission_handler.PermissionStatus storageStatus = await permission_handler.Permission.storage.request();
      if (storageStatus != permission_handler.PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  // Start location service
  Future<void> _startLocationService() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      // Check permission
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      // Start location updates
      _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) {
        _currentLocation = locationData;
        _locationController.add(locationData);
      });
    } catch (e) {
      debugPrint('Error starting location service: $e');
    }
  }

  // Get current location (one-time)
  Future<LocationData?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return null;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return null;
      }

      return await _location.getLocation();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  // Simulate light sensor (since most devices don't have direct light sensor access)
  void updateLightIntensity(double lightValue) {
    if (!_lightController.isClosed) {
      _currentLight = lightValue;
      _lightController.add(lightValue);
    }
  }

  // Start light simulation based on time of day and location
  void startLightSimulation() {
    _lightSimulationTimer?.cancel();
    _lightSimulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final hour = now.hour;
      
      // Base light intensity based on time of day
      double timeBasedLight;
      if (hour >= 6 && hour <= 18) {
        // Daytime simulation with smooth curve
        if (hour >= 6 && hour <= 10) {
          // Morning: gradually increasing (200-600 lux)
          timeBasedLight = 200 + (hour - 6) * 100;
        } else if (hour >= 10 && hour <= 14) {
          // Midday: peak brightness (600-800 lux)
          timeBasedLight = 600 + (hour - 10) * 50;
        } else {
          // Afternoon: gradually decreasing (800-200 lux)
          timeBasedLight = 800 - (hour - 14) * 100;
        }
      } else {
        // Nighttime: very low light (5-20 lux)
        timeBasedLight = 5 + (hour % 6) * 3;
      }
      
      // Calculate location modifier based on GPS coordinates
      _updateLocationModifier();
      
      // Combine time-based, location-based, and screen coverage factors
      double lightValue = timeBasedLight + _locationModifier + _screenCoverModifier;
      
      // Add realistic variations (clouds, shadows, etc.)
      double variation = (DateTime.now().millisecondsSinceEpoch % 200) - 100;
      lightValue += variation;
      
      // Ensure realistic range
      lightValue = lightValue.clamp(5, 2000);
      
      updateLightIntensity(lightValue);
    });
  }
  
  // Detect if screen is covered based on accelerometer data
  void _detectScreenCoverage(AccelerometerEvent event) {
    if (!_enableScreenCoverDetection) return;
    
    // When device is face down, Z-axis should be close to -9.8 (gravity)
    // and X, Y should be close to 0
    bool isFaceDown = event.z < -8.0 && event.x.abs() < 2.0 && event.y.abs() < 2.0;
    
    if (isFaceDown && !_isScreenCovered) {
      // Screen just got covered
      _isScreenCovered = true;
      _screenCoverModifier = -800.0; // Dramatically reduce light
      debugPrint('Screen covered detected - reducing light intensity');
    } else if (!isFaceDown && _isScreenCovered) {
      // Screen uncovered
      _isScreenCovered = false;
      _screenCoverModifier = 0.0; // Restore normal light
      debugPrint('Screen uncovered - restoring light intensity');
    }
  }

  // Enable/disable screen cover detection
  void setScreenCoverDetection(bool enabled) {
    _enableScreenCoverDetection = enabled;
    if (!enabled) {
      _isScreenCovered = false;
      _screenCoverModifier = 0.0;
    }
  }

  // Update location modifier based on GPS coordinates
  void _updateLocationModifier() {
    if (_currentLocation?.latitude == null || _currentLocation?.longitude == null) {
      _locationModifier = 0.0;
      return;
    }
    
    final lat = _currentLocation!.latitude!;
    final lng = _currentLocation!.longitude!;
    
    // Simulate different light conditions based on location
    // This is a simplified simulation - in reality, you'd need more complex algorithms
    
    // Simulate being under trees (darker)
    if ((lat * 1000).round() % 3 == 0) {
      _locationModifier = -200.0; // Much darker under trees
    }
    // Simulate being in open areas (brighter)
    else if ((lng * 1000).round() % 4 == 0) {
      _locationModifier = 300.0; // Brighter in open areas
    }
    // Simulate being near buildings (shadows)
    else if ((lat * lng * 1000).round() % 5 == 0) {
      _locationModifier = -100.0; // Somewhat darker near buildings
    }
    // Default outdoor conditions
    else {
      _locationModifier = 50.0; // Slightly brighter than base
    }
  }

  // Manual light adjustment for testing different scenarios
  void setLightScenario(LightScenario scenario) {
    switch (scenario) {
      case LightScenario.brightSunny:
        _locationModifier = 400.0;
        break;
      case LightScenario.partlyCloudy:
        _locationModifier = 200.0;
        break;
      case LightScenario.underTree:
        _locationModifier = -300.0;
        break;
      case LightScenario.buildingShadow:
        _locationModifier = -150.0;
        break;
      case LightScenario.indoor:
        _locationModifier = -400.0;
        break;
      case LightScenario.night:
        _locationModifier = -500.0;
        break;
    }
  }

  // Get current sensor values
  double get currentLight => _currentLight;
  double get currentAcceleration => _currentAcceleration;
  double get currentMagnetic => _currentMagnetic;
  LocationData? get currentLocation => _currentLocation;

  // Dispose resources
  void dispose() {
    _accelerometerSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    _locationSubscription?.cancel();
    _lightSimulationTimer?.cancel();
    
    if (!_lightController.isClosed) _lightController.close();
    if (!_accelerationController.isClosed) _accelerationController.close();
    if (!_magneticController.isClosed) _magneticController.close();
    if (!_locationController.isClosed) _locationController.close();
  }
}
