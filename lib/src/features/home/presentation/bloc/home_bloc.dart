import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';
import 'package:myapp/src/features/home/domain/usecases/get_advisories.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAdvisories getAdvisories;
  HomeBloc({required this.getAdvisories}) : super(HomeInitial()) {
    on<LoadAdvisories>((event, emit) async {
      emit(HomeLoading());
      try {
        final advisories = await getAdvisories.execute();
        emit(HomeSuccess(advisories: advisories));
      } catch (e) {
        emit(HomeFailure(error: e.toString()));
      }
    });
  }
}
