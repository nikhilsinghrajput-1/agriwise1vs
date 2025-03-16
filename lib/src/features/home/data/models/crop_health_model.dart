class CropHealthModel {
  final String health;
  final String optimal;

  CropHealthModel({required this.health, required this.optimal});

  factory CropHealthModel.fromJson(Map<String, dynamic> json) {
    return CropHealthModel(
      health: json['health'],
      optimal: json['optimal'],
    );
  }
}
