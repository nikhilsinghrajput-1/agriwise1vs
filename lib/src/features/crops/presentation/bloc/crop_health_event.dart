import '../../domain/models/crop_health_model.dart';

abstract class CropHealthEvent {}

class LoadCropHealthHistory extends CropHealthEvent {}

class AddCropHealthRecord extends CropHealthEvent {
  final CropHealth record;

  AddCropHealthRecord(this.record);
}

class DeleteCropHealthRecord extends CropHealthEvent {
  final String recordId;

  DeleteCropHealthRecord(this.recordId);
}

class WatchCropHealthHistory extends CropHealthEvent {} 