import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../services/storage_service.dart';
import '../models/survey_point.dart';

class SurveyStationScreen extends StatefulWidget {
  const SurveyStationScreen({super.key});

  @override
  State<SurveyStationScreen> createState() => _SurveyStationScreenState();
}

class _SurveyStationScreenState extends State<SurveyStationScreen> {
  final SensorService _sensorService = SensorService();
  final StorageService _storageService = StorageService();
  
  double _lightIntensity = 0.0;
  double _accelerationMagnitude = 0.0;
  double _magneticFieldMagnitude = 0.0;
  String _locationInfo = 'Đang lấy vị trí...';
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _screenCoverDetectionEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeSensors();
  }

  Future<void> _initializeSensors() async {
    final success = await _sensorService.initializeSensors();
    if (success) {
      setState(() {
        _isInitialized = true;
      });
      
      // Start light simulation
      _sensorService.startLightSimulation();
      
      // Listen to sensor streams
      _sensorService.lightStream.listen((value) {
        setState(() {
          _lightIntensity = value;
        });
      });
      
      _sensorService.accelerationStream.listen((value) {
        setState(() {
          _accelerationMagnitude = value;
        });
      });
      
      _sensorService.magneticStream.listen((value) {
        setState(() {
          _magneticFieldMagnitude = value;
        });
      });
      
      _sensorService.locationStream.listen((location) {
        if (location != null) {
          setState(() {
            _locationInfo = 'Lat: ${location.latitude?.toStringAsFixed(6) ?? 'N/A'}, '
                         'Lng: ${location.longitude?.toStringAsFixed(6) ?? 'N/A'}';
          });
        }
      });
    }
  }

  Future<void> _recordDataPoint() async {
    if (_isRecording) return;
    
    setState(() {
      _isRecording = true;
    });

    try {
      // Get current location
      final location = await _sensorService.getCurrentLocation();
      if (location?.latitude == null || location?.longitude == null) {
        _showSnackBar('Không thể lấy vị trí GPS. Vui lòng kiểm tra quyền truy cập vị trí.', isError: true);
        return;
      }

      // Create survey point
      final surveyPoint = SurveyPoint(
        latitude: location!.latitude!,
        longitude: location.longitude!,
        lightIntensity: _lightIntensity,
        accelerationMagnitude: _accelerationMagnitude,
        magneticFieldMagnitude: _magneticFieldMagnitude,
        timestamp: DateTime.now(),
      );

      // Save to storage
      final success = await _storageService.saveSurveyPoint(surveyPoint);
      if (success) {
        _showSnackBar('Đã ghi dữ liệu thành công!');
        setState(() {
          _locationInfo = 'Lat: ${location.latitude!.toStringAsFixed(6)}, '
                         'Lng: ${location.longitude!.toStringAsFixed(6)}';
        });
      } else {
        _showSnackBar('Lỗi khi lưu dữ liệu!', isError: true);
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e', isError: true);
    } finally {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getLightColor(double value) {
    if (value < 100) return Colors.grey[600]!;
    if (value < 500) return Colors.yellow[600]!;
    if (value < 1000) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  Color _getAccelerationColor(double value) {
    if (value < 10) return Colors.green[600]!;
    if (value < 15) return Colors.yellow[600]!;
    if (value < 20) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  Color _getMagneticColor(double value) {
    if (value < 20) return Colors.blue[300]!;
    if (value < 40) return Colors.blue[600]!;
    if (value < 60) return Colors.blue[800]!;
    return Colors.purple[600]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạm Khảo sát'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: _isInitialized
          ? _buildMainContent()
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang khởi tạo cảm biến...'),
                ],
              ),
            ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.science, size: 48, color: Colors.blue[700]),
                  const SizedBox(height: 8),
                  const Text(
                    'Dữ liệu Trực tiếp',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _locationInfo,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Sensor Data Cards
          Expanded(
            child: Column(
              children: [
                // Light Intensity Card
                _buildSensorCard(
                  icon: Icons.wb_sunny,
                  title: 'Cường độ Ánh sáng',
                  value: '${_lightIntensity.toStringAsFixed(1)} lux',
                  color: _getLightColor(_lightIntensity),
                  description: 'Giá trị càng cao = càng sáng',
                ),
                
                const SizedBox(height: 16),
                
                // Acceleration Card
                _buildSensorCard(
                  icon: Icons.directions_walk,
                  title: 'Độ "Năng động"',
                  value: '${_accelerationMagnitude.toStringAsFixed(2)} m/s²',
                  color: _getAccelerationColor(_accelerationMagnitude),
                  description: 'Giá trị càng cao = càng rung động',
                ),
                
                const SizedBox(height: 16),
                
                // Magnetic Field Card
                _buildSensorCard(
                  icon: Icons.explore,
                  title: 'Cường độ Từ trường',
                  value: '${_magneticFieldMagnitude.toStringAsFixed(1)} μT',
                  color: _getMagneticColor(_magneticFieldMagnitude),
                  description: 'Giá trị càng cao = từ trường càng mạnh',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Light Simulation Controls
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.light_mode, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Mô phỏng Ánh sáng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _screenCoverDetectionEnabled,
                        onChanged: (value) {
                          setState(() {
                            _screenCoverDetectionEnabled = value;
                          });
                          _sensorService.setScreenCoverDetection(value);
                          _showSnackBar(value ? 'Đã bật phát hiện che màn hình' : 'Đã tắt phát hiện che màn hình');
                        },
                        activeThumbColor: Colors.orange[700],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phát hiện che màn hình: ${_screenCoverDetectionEnabled ? "Bật" : "Tắt"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildLightButton('Nắng', LightScenario.brightSunny, Colors.yellow),
                      _buildLightButton('Mây', LightScenario.partlyCloudy, Colors.grey),
                      _buildLightButton('Dưới cây', LightScenario.underTree, Colors.green),
                      _buildLightButton('Bóng tòa nhà', LightScenario.buildingShadow, Colors.blue),
                      _buildLightButton('Trong nhà', LightScenario.indoor, Colors.brown),
                      _buildLightButton('Đêm', LightScenario.night, Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Record Button
          ElevatedButton.icon(
            onPressed: _isRecording ? null : _recordDataPoint,
            icon: _isRecording 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_isRecording ? 'Đang ghi dữ liệu...' : 'Ghi Dữ liệu tại Điểm này'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightButton(String label, LightScenario scenario, Color color) {
    return ElevatedButton(
      onPressed: () {
        _sensorService.setLightScenario(scenario);
        _showSnackBar('Đã chuyển sang mô phỏng: $label');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }
}
