part of 'get_users_bloc.dart';

abstract class GetUsersState extends Equatable {
  const GetUsersState();

  @override
  List<Object> get props => [];
}

class GetUsersInitial extends GetUsersState {}

class GetUsersLoading extends GetUsersState {}

class GetUsersFailed extends GetUsersState {}

class GetUsersLoaded extends GetUsersState {
  final List<UserInfo> users;

  const GetUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}
