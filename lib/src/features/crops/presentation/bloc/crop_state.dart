import 'package:equatable/equatable.dart';
import '../../domain/entities/crop.dart';

abstract class CropState extends Equatable {
  const CropState();

  @override
  List<Object?> get props => [];
}

class CropInitial extends CropState {}

class CropLoading extends CropState {}

class CropLoaded extends CropState {
  final List<Crop> crops;

  const CropLoaded(this.crops);

  @override
  List<Object?> get props => [crops];
}

class CropError extends CropState {
  final String message;

  const CropError(this.message);

  @override
  List<Object?> get props => [message];
}

class CropAdded extends CropState {
  final Crop crop;

  const CropAdded(this.crop);

  @override
  List<Object?> get props => [crop];
}

class CropUpdated extends CropState {
  final Crop crop;

  const CropUpdated(this.crop);

  @override
  List<Object?> get props => [crop];
}

class CropDeleted extends CropState {
  final String cropId;

  const CropDeleted(this.cropId);

  @override
  List<Object?> get props => [cropId];
} 