import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/main_widget.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/utils/track_context.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'core/res/app_resources.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  runApp(
    /// Defining global Blocs
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<AppLoaderBloc>(
          create: (context) => di.sl<AppLoaderBloc>(),
        )
      ],

      /// Defining global RepositoryProviders
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => di.sl<TaskEditController>(),
          ),
          RepositoryProvider(
            create: (context) => di.sl<TimesheetEditController>(),
          )
        ],

        /// Defining global Provider
        child: ChangeNotifierProvider(
          create: (context) => di.sl<AppTheme>(),
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: ScreenUtilInit(
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          title: 'Todo',
          key: TrackContext.key,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
              useMaterial3: true, fontFamily: AppFont.plusJakartaSansRegular),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          builder: MainWidget.widget,
        ),
      ),
    );
  }
}
