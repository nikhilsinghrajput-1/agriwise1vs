import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  final String id;
  final String userId;
  final String name;
  final String variety;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final String status;
  final DateTime createdAt;

  CropModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.variety,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.status,
    required this.createdAt,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      variety: json['variety'] as String,
      plantingDate: (json['plantingDate'] as Timestamp).toDate(),
      expectedHarvestDate: (json['expectedHarvestDate'] as Timestamp).toDate(),
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'variety': variety,
      'plantingDate': Timestamp.fromDate(plantingDate),
      'expectedHarvestDate': Timestamp.fromDate(expectedHarvestDate),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CropModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? variety,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    String? status,
    DateTime? createdAt,
  }) {
    return CropModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 