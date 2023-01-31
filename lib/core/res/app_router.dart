part of 'app_resources.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );

      case SignInScreen.routeName:
        return PageTransition(
          child: const SignInScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );

      case HomeScreen.routeName:
        return PageTransition(
          child: const HomeScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );

      case TaskEditScreen.routeName:
        return PageTransition(
          child: const TaskEditScreen(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );

      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}
