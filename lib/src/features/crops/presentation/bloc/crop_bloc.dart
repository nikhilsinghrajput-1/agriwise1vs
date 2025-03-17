import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/crop_repository.dart';
import 'crop_event.dart';
import 'crop_state.dart';

class CropBloc extends Bloc<CropEvent, CropState> {
  final CropRepository _cropRepository;
  final String userId;

  CropBloc(this._cropRepository, this.userId) : super(CropInitial()) {
    on<LoadUserCrops>(_onLoadUserCrops);
    on<AddCrop>(_onAddCrop);
    on<UpdateCrop>(_onUpdateCrop);
    on<DeleteCrop>(_onDeleteCrop);
    on<ClearCropError>(_onClearError);
  }

  Future<void> _onLoadUserCrops(
    LoadUserCrops event,
    Emitter<CropState> emit,
  ) async {
    try {
      emit(CropLoading());
      await emit.forEach(
        _cropRepository.getUserCrops(event.userId),
        onData: (List<Crop> crops) => CropLoaded(crops),
      );
    } catch (e) {
      emit(CropError(e.toString()));
    }
  }

  Future<void> _onAddCrop(
    AddCrop event,
    Emitter<CropState> emit,
  ) async {
    try {
      emit(CropLoading());
      final crop = Crop(
        id: event.crop.id,
        userId: userId,
        name: event.crop.name,
        variety: event.crop.variety,
        plantingDate: event.crop.plantingDate,
        expectedHarvestDate: event.crop.expectedHarvestDate,
        status: event.crop.status,
        createdAt: event.crop.createdAt,
      );
      final addedCrop = await _cropRepository.addCrop(crop);
      emit(CropAdded(addedCrop));
    } catch (e) {
      emit(CropError(e.toString()));
    }
  }

  Future<void> _onUpdateCrop(
    UpdateCrop event,
    Emitter<CropState> emit,
  ) async {
    try {
      emit(CropLoading());
      await _cropRepository.updateCrop(event.crop);
      emit(CropUpdated(event.crop));
    } catch (e) {
      emit(CropError(e.toString()));
    }
  }

  Future<void> _onDeleteCrop(
    DeleteCrop event,
    Emitter<CropState> emit,
  ) async {
    try {
      emit(CropLoading());
      await _cropRepository.deleteCrop(event.cropId);
      emit(CropDeleted(event.cropId));
    } catch (e) {
      emit(CropError(e.toString()));
    }
  }

  void _onClearError(
    ClearCropError event,
    Emitter<CropState> emit,
  ) {
    emit(CropInitial());
  }
} 