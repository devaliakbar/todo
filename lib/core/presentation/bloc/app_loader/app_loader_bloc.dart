import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_loader_event.dart';
part 'app_loader_state.dart';

class AppLoaderBloc extends Bloc<AppLoaderEvent, AppLoaderState> {
  AppLoaderBloc() : super(LoaderHide()) {
    on<ShowLoader>((event, emit) {
      emit(LoaderVisible());
    });

    on<HideLoader>((event, emit) {
      emit(LoaderHide());
    });
  }
}
