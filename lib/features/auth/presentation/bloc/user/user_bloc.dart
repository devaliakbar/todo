import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/core/utils/bloc_event_restartable.dart';
import 'package:todo/features/auth/domain/enity/user_info.dart';
import 'package:todo/features/auth/domain/usecases/check_sign_in.dart';
import 'package:todo/features/auth/domain/usecases/sign_in.dart';
import 'package:todo/features/auth/domain/usecases/sign_out.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignIn _signIn;
  final SignOut _signOut;
  final CheckSignIn _checkSignIn;
  final BlocEventRestartable _blocEventRestartable;

  UserBloc(
      {required SignIn signIn,
      required SignOut signOut,
      required CheckSignIn checkSignIn,
      required BlocEventRestartable blocEventRestartable})
      : _signIn = signIn,
        _signOut = signOut,
        _checkSignIn = checkSignIn,
        _blocEventRestartable = blocEventRestartable,
        super(UserInitialState()) {
    on<SignInEvent>(_mapSignInEvent,
        transformer: _blocEventRestartable.restartable());

    on<CheckSignInEvent>(_mapCheckSignInEvent,
        transformer: _blocEventRestartable.restartable());

    on<SignOutEvent>(_mapSignOutEvent,
        transformer: _blocEventRestartable.restartable());
  }

  Future<void> _mapSignInEvent(
      SignInEvent event, Emitter<UserState> emit) async {
    emit(SignInLoadingState());

    final Either<Failure, UserInfo> result = await _signIn(NoParams());
    result.fold((Failure failure) => emit(SignInFailedState()),
        (UserInfo userInfo) => emit(SignInState(userInfo: userInfo)));
  }

  Future<void> _mapCheckSignInEvent(
      CheckSignInEvent event, Emitter<UserState> emit) async {
    emit(SignInLoadingState());

    final Either<Failure, UserInfo> result = await _checkSignIn(NoParams());
    result.fold((Failure failure) => emit(UserInitialState()),
        (UserInfo userInfo) => emit(SignInState(userInfo: userInfo)));
  }

  Future<void> _mapSignOutEvent(
      SignOutEvent event, Emitter<UserState> emit) async {
    emit(SignInLoadingState());

    final Either<Failure, void> result = await _signOut(NoParams());
    result.fold((Failure failure) => emit(UserInitialState()),
        (_) => emit(UserInitialState()));
  }
}
