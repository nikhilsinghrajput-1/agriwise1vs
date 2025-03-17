import 'package:flutter/material.dart';
import '../../domain/models/crop_health_model.dart';

class HealthRecordCard extends StatelessWidget {
  final CropHealth record;
  final VoidCallback onDelete;

  const HealthRecordCard({
    Key? key,
    required this.record,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(record.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              'Soil Moisture',
              '${record.soilMoisture.toStringAsFixed(1)}%',
              _getSoilMoistureColor(record.soilMoisture),
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Temperature',
              '${record.temperature.toStringAsFixed(1)}°C',
              _getTemperatureColor(record.temperature),
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Humidity',
              '${record.humidity.toStringAsFixed(1)}%',
              _getHumidityColor(record.humidity),
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Disease Status',
              record.diseaseStatus,
              _getDiseaseStatusColor(record.diseaseStatus),
            ),
            if (record.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Notes:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(record.notes),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getSoilMoistureColor(double moisture) {
    if (moisture < 30) return Colors.red;
    if (moisture < 60) return Colors.orange;
    return Colors.green;
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 15) return Colors.blue;
    if (temperature < 25) return Colors.green;
    if (temperature < 35) return Colors.orange;
    return Colors.red;
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.red;
    if (humidity < 60) return Colors.orange;
    return Colors.green;
  }

  Color _getDiseaseStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'mild':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 