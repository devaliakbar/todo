part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class SignInLoadingState extends UserState {}

class SignInState extends UserState {
  final UserInfo userInfo;

  const SignInState({required this.userInfo});

  @override
  List<Object> get props => [userInfo];
}

class SignInFailedState extends UserState {}
