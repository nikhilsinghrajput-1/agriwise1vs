import '../../domain/entities/crop.dart';

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
      plantingDate: DateTime.parse(json['plantingDate'] as String),
      expectedHarvestDate: DateTime.parse(json['expectedHarvestDate'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Crop toEntity() {
    return Crop(
      id: id,
      userId: userId,
      name: name,
      variety: variety,
      plantingDate: plantingDate,
      expectedHarvestDate: expectedHarvestDate,
      status: status,
      createdAt: createdAt,
    );
  }

  factory CropModel.fromEntity(Crop entity) {
    return CropModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      variety: entity.variety,
      plantingDate: entity.plantingDate,
      expectedHarvestDate: entity.expectedHarvestDate,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
