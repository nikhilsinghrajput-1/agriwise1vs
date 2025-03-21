class Crop {
  final String id;
  final String userId;
  final String name;
  final String variety;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final String status;
  final DateTime createdAt;

  Crop({
    required this.id,
    required this.userId,
    required this.name,
    required this.variety,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.status,
    required this.createdAt,
  });
}
