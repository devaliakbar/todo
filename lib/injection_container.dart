import 'package:get_it/get_it.dart';
import 'package:todo/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:todo/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:todo/features/auth/data/repository/auth_repository.dart';
import 'package:todo/features/auth/domain/irepository/iauth_repository.dart';
import 'package:todo/features/auth/domain/usecases/check_sign_in.dart';
import 'package:todo/features/auth/domain/usecases/sign_in.dart';
import 'package:todo/features/auth/domain/usecases/sign_out.dart';
import 'package:todo/features/auth/presentation/bloc/user/user_bloc.dart';

import 'core/utils/bloc_event_restartable.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Core
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
      AuthRepository(authRemoteDataSource: sl(), authLocalDataSource: sl()));
  // Data source
  sl.registerLazySingleton<IAuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<IAuthLocalDataSource>(() => AuthLocalDataSource());

  ///*********************************************************************************************///
}
