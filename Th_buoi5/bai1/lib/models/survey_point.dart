class SurveyPoint {
  final double latitude;
  final double longitude;
  final double lightIntensity; // lux
  final double accelerationMagnitude; // sqrt(x² + y² + z²)
  final double magneticFieldMagnitude; // magnitude of magnetic field
  final DateTime timestamp;
  final String? description; // optional description

  SurveyPoint({
    required this.latitude,
    required this.longitude,
    required this.lightIntensity,
    required this.accelerationMagnitude,
    required this.magneticFieldMagnitude,
    required this.timestamp,
    this.description,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'lightIntensity': lightIntensity,
      'accelerationMagnitude': accelerationMagnitude,
      'magneticFieldMagnitude': magneticFieldMagnitude,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  // Create from JSON
  factory SurveyPoint.fromJson(Map<String, dynamic> json) {
    return SurveyPoint(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      lightIntensity: json['lightIntensity']?.toDouble() ?? 0.0,
      accelerationMagnitude: json['accelerationMagnitude']?.toDouble() ?? 0.0,
      magneticFieldMagnitude: json['magneticFieldMagnitude']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
    );
  }

  // Helper method to get GPS coordinates as string
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  // Helper method to get formatted timestamp
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

