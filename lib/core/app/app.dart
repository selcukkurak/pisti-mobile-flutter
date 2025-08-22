import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_constants.dart';
import '../../shared/themes/app_theme.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import 'app_router.dart';

class PistiApp extends StatelessWidget {
  const PistiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}