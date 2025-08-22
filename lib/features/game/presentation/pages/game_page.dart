import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/playing_card.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/game_table_widget.dart';
import '../widgets/player_hand_widget.dart';
import '../widgets/game_score_widget.dart';

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pişti'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state.isPisti) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.celebration, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Pişti! 🎉'),
                  ],
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }

          if (state.isGameOver && state.winner != null) {
            _showGameEndDialog(context, state.winner!.name);
          }
        },
        builder: (context, state) {
          if (state.players.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Opponent area
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      GameScoreWidget(
                        player: state.players[1], // AI player
                        isCurrentPlayer: state.currentPlayerIndex == 1,
                      ),
                      Expanded(
                        child: PlayerHandWidget(
                          player: state.players[1],
                          isCurrentPlayer: state.currentPlayerIndex == 1,
                          isHidden: true, // Hide AI cards
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Game table area
              Expanded(
                flex: 3,
                child: GameTableWidget(
                  tableCards: state.tableCards,
                  lastPlayedCard: state.lastPlayedCard,
                  isPisti: state.isPisti,
                ),
              ),
              
              // Player area
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: PlayerHandWidget(
                          player: state.players[0], // Human player
                          isCurrentPlayer: state.currentPlayerIndex == 0,
                          isHidden: false,
                          onCardTap: (card) => _playCard(context, card),
                        ),
                      ),
                      GameScoreWidget(
                        player: state.players[0],
                        isCurrentPlayer: state.currentPlayerIndex == 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _playCard(BuildContext context, PlayingCard card) {
    final gameBloc = context.read<GameBloc>();
    gameBloc.add(PlayCardEvent(card));
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oyunu Yeniden Başlat'),
        content: Text('Bu oyunu bitirip yeni bir oyun başlatmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GameBloc>().add(ResetGameEvent());
              Navigator.pop(context); // Go back to menu
            },
            child: Text('Yeniden Başlat'),
          ),
        ],
      ),
    );
  }

  void _showGameEndDialog(BuildContext context, String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Oyun Bitti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Colors.amber,
            ),
            SizedBox(height: 16),
            Text(
              '$winnerName kazandı!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to menu
              context.read<GameBloc>().add(ResetGameEvent());
            },
            child: Text('Ana Menü'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<GameBloc>().add(ResetGameEvent());
              // Start new game
              context.read<GameBloc>().add(StartGameEvent(
                mode: GameMode.offline,
                playerName: 'Oyuncu',
              ));
            },
            child: Text('Yeni Oyun'),
          ),
        ],
      ),
    );
  }
}