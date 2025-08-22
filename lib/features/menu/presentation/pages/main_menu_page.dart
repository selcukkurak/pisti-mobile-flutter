import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../game/presentation/pages/game_page.dart';
import '../../../game/presentation/bloc/game_bloc.dart';
import '../../../game/domain/models/game_state.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';
import '../../../../core/constants/game_constants.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.casino,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        GameConstants.appName,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        GameConstants.appDescription,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MenuButton(
                        icon: Icons.person,
                        title: 'Tek Oyuncu',
                        subtitle: 'Bilgisayara karşı oyna',
                        onTap: () => _startSinglePlayerGame(context),
                      ),
                      SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.people,
                        title: 'Çok Oyunculu',
                        subtitle: 'Online oyuncularla oyna',
                        onTap: () => _startMultiplayerGame(context),
                        enabled: false, // Will be enabled in future updates
                      ),
                      SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.bar_chart,
                        title: 'İstatistikler',
                        subtitle: 'Oyun performansın',
                        onTap: () => _openStatistics(context),
                      ),
                      SizedBox(height: 16),
                      _MenuButton(
                        icon: Icons.settings,
                        title: 'Ayarlar',
                        subtitle: 'Ses, tema ve dil ayarları',
                        onTap: () => _openSettings(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startSinglePlayerGame(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    gameBloc.add(StartGameEvent(
      mode: GameMode.offline,
      playerName: GameConstants.defaultPlayerName,
    ));
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage()),
    );
  }

  void _startMultiplayerGame(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Çok oyunculu mod yakında gelecek!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _openStatistics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsPage()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: enabled 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).disabledColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: enabled 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: enabled ? null : Theme.of(context).disabledColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: enabled 
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: enabled 
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                  : Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}