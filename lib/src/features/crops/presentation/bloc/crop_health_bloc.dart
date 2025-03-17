import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/crop_health_model.dart';
import '../../domain/repositories/crop_health_repository.dart';
import 'crop_health_event.dart';
import 'crop_health_state.dart';

class CropHealthBloc extends Bloc<CropHealthEvent, CropHealthState> {
  final CropHealthRepository _repository;
  final String cropId;

  CropHealthBloc(this._repository, this.cropId) : super(CropHealthInitial()) {
    on<LoadCropHealthHistory>(_onLoadCropHealthHistory);
    on<AddCropHealthRecord>(_onAddCropHealthRecord);
    on<DeleteCropHealthRecord>(_onDeleteCropHealthRecord);
    on<WatchCropHealthHistory>(_onWatchCropHealthHistory);
  }

  Future<void> _onLoadCropHealthHistory(
    LoadCropHealthHistory event,
    Emitter<CropHealthState> emit,
  ) async {
    try {
      emit(CropHealthLoading());
      final records = await _repository.getCropHealthHistory(cropId);
      emit(CropHealthLoaded(records));
    } catch (e) {
      emit(CropHealthError(e.toString()));
    }
  }

  Future<void> _onAddCropHealthRecord(
    AddCropHealthRecord event,
    Emitter<CropHealthState> emit,
  ) async {
    try {
      emit(CropHealthLoading());
      final record = await _repository.addCropHealthRecord(event.record);
      emit(CropHealthRecordAdded(record));
    } catch (e) {
      emit(CropHealthError(e.toString()));
    }
  }

  Future<void> _onDeleteCropHealthRecord(
    DeleteCropHealthRecord event,
    Emitter<CropHealthState> emit,
  ) async {
    try {
      emit(CropHealthLoading());
      await _repository.deleteCropHealthRecord(event.recordId);
      emit(CropHealthRecordDeleted(event.recordId));
    } catch (e) {
      emit(CropHealthError(e.toString()));
    }
  }

  Future<void> _onWatchCropHealthHistory(
    WatchCropHealthHistory event,
    Emitter<CropHealthState> emit,
  ) async {
    await emit.forEach(
      _repository.watchCropHealthHistory(cropId),
      onData: (List<CropHealth> records) => CropHealthLoaded(records),
    );
  }
} 