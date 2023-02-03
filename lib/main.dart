import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/main_widget.dart';
import 'package:todo/core/utils/track_context.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'core/res/app_resources.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await di.init();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<AppLoaderBloc>(
          create: (context) => di.sl<AppLoaderBloc>(),
        )
      ],
      child: MultiRepositoryProvider(providers: [
        RepositoryProvider(
          create: (context) => di.sl<TaskEditController>(),
        )
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Todo',
        key: TrackContext.key,
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        builder: MainWidget.widget,
      ),
    );
  }
}
