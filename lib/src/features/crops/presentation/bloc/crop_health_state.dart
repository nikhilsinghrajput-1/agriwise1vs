import '../../domain/models/crop_health_model.dart';

abstract class CropHealthState {}

class CropHealthInitial extends CropHealthState {}

class CropHealthLoading extends CropHealthState {}

class CropHealthLoaded extends CropHealthState {
  final List<CropHealth> records;

  CropHealthLoaded(this.records);
}

class CropHealthRecordAdded extends CropHealthState {
  final CropHealth record;

  CropHealthRecordAdded(this.record);
}

class CropHealthRecordDeleted extends CropHealthState {
  final String recordId;

  CropHealthRecordDeleted(this.recordId);
}

class CropHealthError extends CropHealthState {
  final String message;

  CropHealthError(this.message);
} 