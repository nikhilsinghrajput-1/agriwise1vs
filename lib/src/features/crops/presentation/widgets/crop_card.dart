import 'package:flutter/material.dart';
import '../../domain/entities/crop.dart';
import '../../../core/theme/colors.dart';

class CropCard extends StatelessWidget {
  final Crop crop;
  final VoidCallback onTap;

  const CropCard({
    Key? key,
    required this.crop,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    crop.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(crop.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      crop.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Variety: ${crop.variety}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Planting Date: ${_formatDate(crop.plantingDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Expected Harvest: ${_formatDate(crop.expectedHarvestDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planted':
        return AppColors.primary;
      case 'growing':
        return AppColors.success;
      case 'harvested':
        return AppColors.warning;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }
} 