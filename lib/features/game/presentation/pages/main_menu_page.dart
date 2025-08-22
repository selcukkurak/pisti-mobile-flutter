import 'package:flutter/material.dart';

import '../../../core/app/app_router.dart';
import '../../../core/constants/app_constants.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 60),
              
              // Menu Buttons
              _buildMenuButton(
                context,
                icon: Icons.computer,
                title: 'Offline Mode',
                subtitle: 'Play against AI',
                onTap: () => _startGame(context, AppConstants.offlineMode),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                icon: Icons.public,
                title: 'Online Mode',
                subtitle: 'Play with other players',
                onTap: () => _startGame(context, AppConstants.onlineMode),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                icon: Icons.group,
                title: 'Private Room',
                subtitle: 'Play with friends',
                onTap: () => _startGame(context, AppConstants.privateRoomMode),
              ),
              const SizedBox(height: 60),
              
              // Bottom Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(
                    context,
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                  ),
                  _buildBottomButton(
                    context,
                    icon: Icons.leaderboard,
                    label: 'Leaderboard',
                    onTap: () => Navigator.pushNamed(context, AppRouter.leaderboard),
                  ),
                  _buildBottomButton(
                    context,
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () => Navigator.pushNamed(context, AppRouter.settings),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String gameMode) {
    Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {'gameMode': gameMode},
    );
  }
}