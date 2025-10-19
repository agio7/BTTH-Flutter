import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/survey_point.dart';

class StorageService {
  StorageService();

  static const String _fileName = 'schoolyard_map_data.json';

  // Get the file path for storing data
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  // Save survey point to file
  Future<bool> saveSurveyPoint(SurveyPoint point) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      
      List<SurveyPoint> existingPoints = await loadSurveyPoints();
      existingPoints.add(point);
      
      final jsonData = existingPoints.map((point) => point.toJson()).toList();
      final jsonString = jsonEncode(jsonData);
      
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      debugPrint('Error saving survey point: $e');
      return false;
    }
  }

  // Load all survey points from file
  Future<List<SurveyPoint>> loadSurveyPoints() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      
      if (!await file.exists()) {
        return [];
      }
      
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      return jsonList.map((json) => SurveyPoint.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading survey points: $e');
      return [];
    }
  }

  // Clear all data
  Future<bool> clearAllData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error clearing data: $e');
      return false;
    }
  }

  // Get data statistics
  Future<Map<String, dynamic>> getDataStatistics() async {
    try {
      final points = await loadSurveyPoints();
      
      if (points.isEmpty) {
        return {
          'totalPoints': 0,
          'averageLight': 0.0,
          'averageAcceleration': 0.0,
          'averageMagnetic': 0.0,
          'maxLight': 0.0,
          'minLight': 0.0,
          'maxAcceleration': 0.0,
          'minAcceleration': 0.0,
          'maxMagnetic': 0.0,
          'minMagnetic': 0.0,
        };
      }

      double totalLight = 0.0;
      double totalAcceleration = 0.0;
      double totalMagnetic = 0.0;
      double maxLight = points.first.lightIntensity;
      double minLight = points.first.lightIntensity;
      double maxAcceleration = points.first.accelerationMagnitude;
      double minAcceleration = points.first.accelerationMagnitude;
      double maxMagnetic = points.first.magneticFieldMagnitude;
      double minMagnetic = points.first.magneticFieldMagnitude;

      for (final point in points) {
        totalLight += point.lightIntensity;
        totalAcceleration += point.accelerationMagnitude;
        totalMagnetic += point.magneticFieldMagnitude;

        if (point.lightIntensity > maxLight) maxLight = point.lightIntensity;
        if (point.lightIntensity < minLight) minLight = point.lightIntensity;
        if (point.accelerationMagnitude > maxAcceleration) maxAcceleration = point.accelerationMagnitude;
        if (point.accelerationMagnitude < minAcceleration) minAcceleration = point.accelerationMagnitude;
        if (point.magneticFieldMagnitude > maxMagnetic) maxMagnetic = point.magneticFieldMagnitude;
        if (point.magneticFieldMagnitude < minMagnetic) minMagnetic = point.magneticFieldMagnitude;
      }

      return {
        'totalPoints': points.length,
        'averageLight': totalLight / points.length,
        'averageAcceleration': totalAcceleration / points.length,
        'averageMagnetic': totalMagnetic / points.length,
        'maxLight': maxLight,
        'minLight': minLight,
        'maxAcceleration': maxAcceleration,
        'minAcceleration': minAcceleration,
        'maxMagnetic': maxMagnetic,
        'minMagnetic': minMagnetic,
      };
    } catch (e) {
      debugPrint('Error getting data statistics: $e');
      return {};
    }
  }
}
