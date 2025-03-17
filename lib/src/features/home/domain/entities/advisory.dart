import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/models/advisory_model.dart';

class Advisory {
  final String type;
  final String description;
  final IconData icon;
  final Color color;
  final String priority;

  Advisory({
    required this.type,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
  });

  factory Advisory.fromModel(AdvisoryModel model) {
    return Advisory(
      type: model.type,
      description: model.description,
      icon: model.icon,
      color: model.color,
      priority: model.priority,
    );
  }
}
