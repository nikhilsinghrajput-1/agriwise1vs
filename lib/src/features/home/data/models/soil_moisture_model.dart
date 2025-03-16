class SoilMoistureModel {
  final String moisture;

  SoilMoistureModel({required this.moisture});

  factory SoilMoistureModel.fromJson(Map<String, dynamic> json) {
    return SoilMoistureModel(
      moisture: json['moisture'],
    );
  }
}
