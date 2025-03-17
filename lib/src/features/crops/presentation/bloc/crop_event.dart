import 'package:equatable/equatable.dart';
import '../../domain/entities/crop.dart';

abstract class CropEvent extends Equatable {
  const CropEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserCrops extends CropEvent {
  final String userId;

  const LoadUserCrops(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddCrop extends CropEvent {
  final Crop crop;

  const AddCrop(this.crop);

  @override
  List<Object?> get props => [crop];
}

class UpdateCrop extends CropEvent {
  final Crop crop;

  const UpdateCrop(this.crop);

  @override
  List<Object?> get props => [crop];
}

class DeleteCrop extends CropEvent {
  final String cropId;

  const DeleteCrop(this.cropId);

  @override
  List<Object?> get props => [cropId];
}

class ClearCropError extends CropEvent {} 