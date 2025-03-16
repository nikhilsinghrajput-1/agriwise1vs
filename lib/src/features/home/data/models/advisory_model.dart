class AdvisoryModel {
  final String description;

  AdvisoryModel({required this.description});

  factory AdvisoryModel.fromJson(Map<String, dynamic> json) {
    return AdvisoryModel(
      description: json['description'],
    );
  }
}
