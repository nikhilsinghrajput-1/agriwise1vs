class CropHealth {
  final String id;
  final String cropId;
  final DateTime date;
  final double soilMoisture;
  final double temperature;
  final double humidity;
  final String diseaseStatus;
  final String notes;

  CropHealth({
    required this.id,
    required this.cropId,
    required this.date,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.diseaseStatus,
    required this.notes,
  });

  factory CropHealth.fromJson(Map<String, dynamic> json) {
    return CropHealth(
      id: json['id'] as String,
      cropId: json['cropId'] as String,
      date: DateTime.parse(json['date'] as String),
      soilMoisture: (json['soilMoisture'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      diseaseStatus: json['diseaseStatus'] as String,
      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropId': cropId,
      'date': date.toIso8601String(),
      'soilMoisture': soilMoisture,
      'temperature': temperature,
      'humidity': humidity,
      'diseaseStatus': diseaseStatus,
      'notes': notes,
    };
  }

  CropHealth copyWith({
    String? id,
    String? cropId,
    DateTime? date,
    double? soilMoisture,
    double? temperature,
    double? humidity,
    String? diseaseStatus,
    String? notes,
  }) {
    return CropHealth(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      date: date ?? this.date,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      diseaseStatus: diseaseStatus ?? this.diseaseStatus,
      notes: notes ?? this.notes,
    );
  }
} 