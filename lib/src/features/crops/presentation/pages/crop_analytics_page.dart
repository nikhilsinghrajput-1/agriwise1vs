import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/crop_model.dart';
import '../../domain/entities/crop.dart';
import '../../domain/models/crop_health_model.dart';
import '../bloc/crop_health_bloc.dart';
import '../bloc/crop_health_event.dart';
import '../bloc/crop_health_state.dart';
import 'package:fl_chart/fl_chart.dart';

class CropAnalyticsPage extends StatelessWidget {
  final Crop crop;

  const CropAnalyticsPage({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CropHealthBloc(
        context.read(),
        crop.id,
      )..add(LoadCropHealthHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${crop.name} Analytics'),
        ),
        body: BlocBuilder<CropHealthBloc, CropHealthState>(
          builder: (context, state) {
            if (state is CropHealthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CropHealthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CropHealthBloc>().add(LoadCropHealthHistory());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CropHealthLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGrowthProgressCard(context, crop),
                    const SizedBox(height: 16),
                    _buildHealthMetricsCard(context, state.records),
                    const SizedBox(height: 16),
                    _buildDiseaseTrendCard(context, state.records),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildGrowthProgressCard(BuildContext context, Crop crop) {
    final daysSincePlanting = DateTime.now().difference(crop.plantingDate).inDays;
    final totalDays = crop.expectedHarvestDate.difference(crop.plantingDate).inDays;
    final progress = daysSincePlanting / totalDays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Growth Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.5 ? Colors.green : Colors.orange,
              ),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Days Since Planting: $daysSincePlanting'),
                Text('Total Days: $totalDays'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetricsCard(BuildContext context, List<CropHealth> records) {
    if (records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No health records available'),
        ),
      );
    }

    final latestRecord = records.first;
    final averageSoilMoisture = records
        .map((r) => r.soilMoisture)
        .reduce((a, b) => a + b) /
        records.length;
    final averageTemperature = records
        .map((r) => r.temperature)
        .reduce((a, b) => a + b) /
        records.length;
    final averageHumidity = records
        .map((r) => r.humidity)
        .reduce((a, b) => a + b) /
        records.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Metrics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'Soil Moisture',
'${latestRecord.soilMoisture!.toStringAsFixed(1)}%',
'${averageSoilMoisture!.toStringAsFixed(1)}%',
              _getSoilMoistureColor(latestRecord.soilMoisture),
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Temperature',
'${latestRecord.temperature!.toStringAsFixed(1)}°C',
'${averageTemperature!.toStringAsFixed(1)}°C',
              _getTemperatureColor(latestRecord.temperature),
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Humidity',
'${latestRecord.humidity!.toStringAsFixed(1)}%',
'${averageHumidity!.toStringAsFixed(1)}%',
_getHumidityColor(latestRecord.humidity!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseTrendCard(BuildContext context, List<CropHealth> records) {
    if (records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No disease records available'),
        ),
      );
    }

final healthyCount = records.where((r) => r.diseaseStatus! == 'Healthy').length;
final mildCount = records.where((r) => r.diseaseStatus! == 'Mild').length;
final severeCount = records.where((r) => r.diseaseStatus! == 'Severe').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disease Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: healthyCount.toDouble(),
                      title: 'Healthy',
                      color: Colors.green,
                    ),
                    PieChartSectionData(
                      value: mildCount.toDouble(),
                      title: 'Mild',
                      color: Colors.orange,
                    ),
                    PieChartSectionData(
                      value: severeCount.toDouble(),
                      title: 'Severe',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Healthy', Colors.green, healthyCount),
                _buildLegendItem('Mild', Colors.orange, mildCount),
                _buildLegendItem('Severe', Colors.red, severeCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String current,
    String average,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Text(
              current,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(Avg: $average)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text('$label ($count)'),
      ],
    );
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
}
