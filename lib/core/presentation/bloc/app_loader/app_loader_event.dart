part of 'app_loader_bloc.dart';

abstract class AppLoaderEvent extends Equatable {
  const AppLoaderEvent();

  @override
  List<Object> get props => [];
}

class ShowLoader extends AppLoaderEvent {}

class HideLoader extends AppLoaderEvent {}
