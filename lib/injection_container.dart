import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/service/app_notification_service.dart';
import 'package:todo/core/utils/bloc_event_restartable.dart';
import 'package:todo/features/task/data/datasource/task_local_data_source.dart';
import 'package:todo/features/task/data/datasource/task_remote_data_source.dart';
import 'package:todo/features/task/data/repository/task_repository.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/delete_task.dart';
import 'package:todo/features/task/domain/usecases/export_tasks_csv.dart';
import 'package:todo/features/task/domain/usecases/get_tasks.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/timesheet/data/datasource/timesheet_remore_data_source.dart';
import 'package:todo/features/timesheet/data/repository/timesheet_repository.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
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
  // Core
  sl.registerLazySingleton<AppNotificationService>(
      () => AppNotificationService(logger: sl()));
  // Bloc
  sl.registerFactory(() => AppLoaderBloc());
  // AppTheme
  sl.registerFactory(() => AppTheme(logger: sl()));

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
      () => UserRemoteDataSource(appNotificationService: sl(), logger: sl()));
  sl.registerLazySingleton<IUserLocalDataSource>(
      () => UserLocalDataSource(appNotificationService: sl()));

  ///*********************************************************************************************///

  // Task
  // Bloc
  sl.registerFactory(() => TasksBloc(getTasks: sl()));
  // View Controller
  sl.registerFactory(() => TaskEditController(
      createTask: sl(),
      updateTask: sl(),
      exportTasksCsv: sl(),
      deleteTask: sl()));
  // Usecase
  sl.registerLazySingleton(() => CreateTask(taskRepository: sl()));
  sl.registerLazySingleton(() => UpdateTask(taskRepository: sl()));
  sl.registerLazySingleton(() => GetTasks(taskRepository: sl()));
  sl.registerLazySingleton(() => DeleteTask(taskRepository: sl()));
  sl.registerLazySingleton(() => ExportTasksCsv(taskRepository: sl()));
  // Repository
  sl.registerLazySingleton<ItaskRepository>(() =>
      TaskRepository(taskRemoteDataSource: sl(), taskLocalDataSource: sl()));
  // Data source
  sl.registerLazySingleton<ITaskRemoteDataSource>(
      () => TaskRemoteDataSource(logger: sl(), appNotificationService: sl()));
  sl.registerLazySingleton<ITaskLocalDataSource>(
      () => TaskLocalDataSource(logger: sl()));

  ///*********************************************************************************************///

  // Timesheet
  // Bloc
  sl.registerFactory(() => TasksTimesheetBloc(getTasksTimesheet: sl()));
  // View Controller
  sl.registerFactory(
      () => TimesheetEditController(updateTimesheetStatus: sl()));
  // Usecase
  sl.registerLazySingleton(() => GetTasksTimesheet(timesheetRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateTimesheetStatus(timesheetRepository: sl()));
  // Repository
  sl.registerLazySingleton<ITimesheetRepository>(
      () => TimesheetRepository(timesheetRemoreDataSource: sl()));
  // Data source
  sl.registerLazySingleton<ITimesheetRemoreDataSource>(
      () => TimesheetRemoreDataSource(logger: sl()));
}
