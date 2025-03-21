import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/crop_model.dart';
import '../../domain/entities/crop.dart';
import '../bloc/crop_bloc.dart';
import '../bloc/crop_event.dart';
import '../bloc/crop_state.dart';
import 'crop_health_page.dart';
import 'crop_analytics_page.dart';
import 'crop_disease_detection_page.dart';
import 'weather_page.dart';
import 'crop_recommendations_page.dart';
import 'crop_prices_page.dart';
import 'add_crop_page.dart';

class CropDetailsPage extends StatelessWidget {
  final Crop crop;

  const CropDetailsPage({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCropPage(crop: crop),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Crop'),
                  content: const Text('Are you sure you want to delete this crop?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CropBloc>().add(DeleteCrop(crop.id));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<CropBloc, CropState>(
        listener: (context, state) {
          if (state is CropError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                context,
                'Basic Information',
                [
                  _buildInfoRow('Name', crop.name),
                  _buildInfoRow('Variety', crop.variety),
                  _buildInfoRow('Status', crop.status),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Dates',
                [
                  _buildInfoRow('Planting Date', _formatDate(crop.plantingDate)),
                  _buildInfoRow(
                    'Expected Harvest',
                    _formatDate(crop.expectedHarvestDate),
                  ),
                  _buildInfoRow('Created At', _formatDate(crop.createdAt)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Growth Progress',
                [
                  _buildProgressIndicator(
                    'Days Since Planting',
                    _calculateDaysSincePlanting(crop.plantingDate),
                  ),
                  _buildProgressIndicator(
                    'Days Until Harvest',
                    _calculateDaysUntilHarvest(crop.expectedHarvestDate),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropHealthPage(crop: crop),
                          ),
                        );
                      },
                      icon: const Icon(Icons.health_and_safety),
                      label: const Text('Health Records'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropAnalyticsPage(crop: crop),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text('Analytics'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropDiseaseDetectionPage(crop: crop),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Detect Disease'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherPage(crop: crop),
                          ),
                        );
                      },
                      icon: const Icon(Icons.wb_sunny),
                      label: const Text('Weather'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropPricesPage(crop: crop),
                          ),
                        );
                      },
                      icon: const Icon(Icons.attach_money),
                      label: const Text('Prices'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CropRecommendationsPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.eco),
                      label: const Text('Get Recommendations'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String label, int days) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: days / 100, // Assuming 100 days as maximum
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              days < 30 ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          Text('$days days'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateDaysSincePlanting(DateTime plantingDate) {
    return DateTime.now().difference(plantingDate).inDays;
  }

  int _calculateDaysUntilHarvest(DateTime harvestDate) {
    return harvestDate.difference(DateTime.now()).inDays;
  }
}
