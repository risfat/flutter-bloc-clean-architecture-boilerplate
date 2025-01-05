/// Defines the route names and paths for the application.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// Splash routes
  static const String splashRouteName = 'splash';
  static const String splashRoutePath = '/';

  /// Authentication routes
  static const String onboardingRouteName = 'onboarding';
  static const String onboardingRoutePath = '/onboarding';

  static const String loginRouteName = 'login';
  static const String loginRoutePath = '/login';

  static const String signupRouteName = 'signup';
  static const String signupRoutePath = '/signup';

  /// Dashboard route
  static const String dashboardRouteName = 'dashboard';
  static const String dashboardRoutePath = '/dashboard';

  /// Users route
  static const String usersRouteName = 'users';
  static const String usersRoutePath = '/users';

  /// Error route
  static const String errorRouteName = 'error';
  static const String errorRoutePath = '/error';
}
