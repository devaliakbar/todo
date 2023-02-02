import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:todo/features/user/data/datasource/user_remote_data_source.dart';
import 'package:todo/features/user/data/repository/auth_repository.dart';
import 'package:todo/features/user/domain/irepository/iauth_repository.dart';
import 'package:todo/features/user/domain/usecases/check_sign_in.dart';
import 'package:todo/features/user/domain/usecases/sign_in.dart';
import 'package:todo/features/user/domain/usecases/sign_out.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';

import 'core/utils/bloc_event_restartable.dart';
import 'features/user/data/datasource/user_local_data_source.dart';

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
  // Usecase
  sl.registerLazySingleton(() => SignIn(authRepository: sl()));
  sl.registerLazySingleton(() => SignOut(authRepository: sl()));
  sl.registerLazySingleton(() => CheckSignIn(authRepository: sl()));
  // Repository
  sl.registerLazySingleton<IAuthRepository>(() =>
      AuthRepository(userRemoteDataSource: sl(), userLocalDataSource: sl()));
  // Data source
  sl.registerLazySingleton<IUserRemoteDataSource>(
      () => UserRemoteDataSource(logger: sl()));
  sl.registerLazySingleton<IUserLocalDataSource>(() => UserLocalDataSource());

  ///*********************************************************************************************///
}
