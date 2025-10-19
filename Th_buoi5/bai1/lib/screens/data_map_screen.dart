import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/survey_point.dart';

class DataMapScreen extends StatefulWidget {
  const DataMapScreen({super.key});

  @override
  State<DataMapScreen> createState() => _DataMapScreenState();
}

class _DataMapScreenState extends State<DataMapScreen> {
  final StorageService _storageService = StorageService();
  List<SurveyPoint> _surveyPoints = [];
  bool _isLoading = true;
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final points = await _storageService.loadSurveyPoints();
      final stats = await _storageService.getDataStatistics();
      
      setState(() {
        _surveyPoints = points;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Lỗi khi tải dữ liệu: $e', isError: true);
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

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả dữ liệu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _storageService.clearAllData();
      if (success) {
        _loadData();
        _showSnackBar('Đã xóa tất cả dữ liệu');
      } else {
        _showSnackBar('Lỗi khi xóa dữ liệu', isError: true);
      }
    }
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
        title: const Text('Bản đồ Dữ liệu'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAllData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _surveyPoints.isEmpty
              ? _buildEmptyState()
              : _buildDataContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có dữ liệu khảo sát',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy quay lại màn hình Trạm Khảo sát để thu thập dữ liệu',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataContent() {
    return Column(
      children: [
        // Statistics Card
        if (_statistics.isNotEmpty) _buildStatisticsCard(),
        
        // Data List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _surveyPoints.length,
            itemBuilder: (context, index) {
              final point = _surveyPoints[index];
              return _buildDataCard(point, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Thống kê Dữ liệu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Tổng điểm',
                    '${_statistics['totalPoints'] ?? 0}',
                    Icons.location_on,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Ánh sáng TB',
                    '${(_statistics['averageLight'] ?? 0).toStringAsFixed(1)} lux',
                    Icons.wb_sunny,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Năng động TB',
                    '${(_statistics['averageAcceleration'] ?? 0).toStringAsFixed(2)} m/s²',
                    Icons.directions_walk,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Từ trường TB',
                    '${(_statistics['averageMagnetic'] ?? 0).toStringAsFixed(1)} μT',
                    Icons.explore,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard(SurveyPoint point, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with index and timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Điểm #$index',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  point.formattedTimestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // GPS Coordinates
            Text(
              'Tọa độ: ${point.coordinatesString}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontFamily: 'monospace',
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Sensor Data
            Row(
              children: [
                // Light Intensity
                Expanded(
                  child: _buildSensorIndicator(
                    icon: Icons.wb_sunny,
                    value: '${point.lightIntensity.toStringAsFixed(1)} lux',
                    color: _getLightColor(point.lightIntensity),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Acceleration
                Expanded(
                  child: _buildSensorIndicator(
                    icon: Icons.directions_walk,
                    value: '${point.accelerationMagnitude.toStringAsFixed(2)} m/s²',
                    color: _getAccelerationColor(point.accelerationMagnitude),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Magnetic Field
                Expanded(
                  child: _buildSensorIndicator(
                    icon: Icons.explore,
                    value: '${point.magneticFieldMagnitude.toStringAsFixed(1)} μT',
                    color: _getMagneticColor(point.magneticFieldMagnitude),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorIndicator({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
