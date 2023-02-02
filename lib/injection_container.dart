import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/utils/bloc_event_restartable.dart';
import 'package:todo/features/user/data/datasource/user_local_data_source.dart';
import 'package:todo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:todo/features/user/data/repository/auth_repository.dart';
import 'package:todo/features/user/data/repository/user_repository.dart';
import 'package:todo/features/user/domain/irepository/iauth_repository.dart';
import 'package:todo/features/user/domain/irepository/iuser_repository.dart';
import 'package:todo/features/user/domain/usecases/check_sign_in.dart';
import 'package:todo/features/user/domain/usecases/get_users.dart';
import 'package:todo/features/user/domain/usecases/sign_in.dart';
import 'package:todo/features/user/domain/usecases/sign_out.dart';
import 'package:todo/features/user/presentation/bloc/get_users/get_users_bloc.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Core
  sl.registerLazySingleton<Logger>(() => Logger());
  // Utils
  sl.registerLazySingleton<BlocEventRestartable>(() => BlocEventRestartable());

  ///*********************************************************************************************///

  // Auth
  // Bloc
  sl.registerFactory(() => UserBloc(
      signIn: sl(),
      checkSignIn: sl(),
      blocEventRestartable: sl(),
      signOut: sl()));
  sl.registerFactory(() => GetUsersBloc(getUsers: sl()));
  // Usecase
  sl.registerLazySingleton(() => SignIn(authRepository: sl()));
  sl.registerLazySingleton(() => SignOut(authRepository: sl()));
  sl.registerLazySingleton(() => CheckSignIn(authRepository: sl()));
  sl.registerLazySingleton(() => GetUsers(userRepository: sl()));
  // Repository
  sl.registerLazySingleton<IAuthRepository>(() =>
      AuthRepository(userRemoteDataSource: sl(), userLocalDataSource: sl()));
  sl.registerLazySingleton<IUserRepository>(
      () => UserRepository(userRemoteDataSource: sl()));
  // Data source
  sl.registerLazySingleton<IUserRemoteDataSource>(
      () => UserRemoteDataSource(logger: sl()));
  sl.registerLazySingleton<IUserLocalDataSource>(() => UserLocalDataSource());

  ///*********************************************************************************************///
}
