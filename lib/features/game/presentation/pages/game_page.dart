import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  final String? gameMode;

  const GamePage({super.key, this.gameMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game - ${gameMode ?? 'Unknown'}'),
        backgroundColor: const Color(0xFF0D7377), // Game table green
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0D7377), // Game table background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Game Mode: ${gameMode ?? 'Unknown'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Game implementation coming soon...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Main Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}