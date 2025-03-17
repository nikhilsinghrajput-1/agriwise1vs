import 'package:flutter/material.dart';

class AdvisoryModel {
  final String type;
  final String description;
  final IconData icon;
  final Color color;
  final String priority;

  AdvisoryModel({
    required this.type,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
  });

  factory AdvisoryModel.fromJson(Map<String, dynamic> json) {
    IconData getIconFromString(String iconType) {
      switch (iconType) {
        case 'warning':
          return Icons.warning_amber_rounded;
        case 'info':
          return Icons.info_outline;
        case 'success':
          return Icons.check_circle_outline;
        default:
          return Icons.notifications_none;
      }
    }

    Color getColorFromString(String colorType) {
      switch (colorType) {
        case 'orange':
          return Colors.orange;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'red':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return AdvisoryModel(
      type: json['type'] ?? 'info',
      description: json['description'] ?? 'No description available',
      icon: json['icon'] != null 
          ? getIconFromString(json['icon']) 
          : Icons.notifications_none,
      color: json['color'] != null 
          ? getColorFromString(json['color']) 
          : Colors.grey,
      priority: json['priority'] ?? 'Medium',
    );
  }
}
