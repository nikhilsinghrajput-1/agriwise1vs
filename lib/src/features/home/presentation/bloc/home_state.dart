part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Advisory> advisories;

  HomeSuccess({required this.advisories});
}

class HomeFailure extends HomeState {
  final String error;

  HomeFailure({required this.error});
}
