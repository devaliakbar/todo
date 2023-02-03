part of 'app_loader_bloc.dart';

abstract class AppLoaderState extends Equatable {
  const AppLoaderState();

  @override
  List<Object> get props => [];
}

class LoaderHide extends AppLoaderState {}

class LoaderVisible extends AppLoaderState {}
