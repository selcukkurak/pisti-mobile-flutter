import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/game/presentation/pages/main_menu_page.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String mainMenu = '/main-menu';
  static const String game = '/game';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String leaderboard = '/leaderboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case mainMenu:
        return MaterialPageRoute(builder: (_) => const MainMenuPage());
      case game:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => GamePage(gameMode: args?['gameMode']),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case leaderboard:
        return MaterialPageRoute(builder: (_) => const LeaderboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}