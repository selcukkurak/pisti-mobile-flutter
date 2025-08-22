import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/menu/presentation/pages/main_menu_page.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

void main() {
  runApp(PistiApp());
}

class PistiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'Pişti',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: settingsState.locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('tr', 'TR'),
              Locale('en', 'US'),
            ],
            home: MainMenuPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}