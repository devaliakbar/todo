import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/features/user/domain/usecases/get_users.dart';

part 'get_users_event.dart';
part 'get_users_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  final GetUsers _getUsers;

  GetUsersBloc({required GetUsers getUsers})
      : _getUsers = getUsers,
        super(GetUsersInitial()) {
    on<GetAllUsersEvent>(_mapGetAllUsersEvent);
  }
  Future<void> _mapGetAllUsersEvent(
      GetAllUsersEvent event, Emitter<GetUsersState> emit) async {
    emit(GetUsersLoading());

    final result = await _getUsers(NoParams());

    result.fold((failure) => emit(GetUsersFailed()),
        (result) => emit(GetUsersLoaded(users: result)));
  }
}
