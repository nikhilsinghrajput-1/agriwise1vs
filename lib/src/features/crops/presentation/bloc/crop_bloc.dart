import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/crop_repository.dart';
import 'crop_event.dart';
import 'crop_state.dart';

class CropBloc extends Bloc<CropEvent, CropState> {
  final CropRepository _cropRepository;

  CropBloc(this._cropRepository) : super(CropInitial()) {
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
        onData: (List<crop> crops) => CropLoaded(crops),
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
      final crop = await _cropRepository.addCrop(event.crop);
      emit(CropAdded(crop));
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