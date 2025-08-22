import 'package:flutter/material.dart';
import '../../domain/models/playing_card.dart';
import 'playing_card_widget.dart';
import '../../../core/constants/game_constants.dart';

class GameTableWidget extends StatelessWidget {
  final List<PlayingCard> tableCards;
  final PlayingCard? lastPlayedCard;
  final bool isPisti;

  const GameTableWidget({
    Key? key,
    required this.tableCards,
    this.lastPlayedCard,
    this.isPisti = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Table background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),

          // Cards on table
          if (tableCards.isNotEmpty) ...[
            _buildCardStack(),
          ] else ...[
            _buildEmptyTable(),
          ],

          // Pişti effect
          if (isPisti) _buildPistiEffect(),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Show stacked cards with slight offsets
        for (int i = 0; i < tableCards.length; i++)
          Transform.translate(
            offset: Offset(i * 2.0, i * -1.0),
            child: Transform.rotate(
              angle: (i * 0.1) - 0.05,
              child: PlayingCardWidget(
                card: tableCards[i],
                width: GameConstants.gameTableCardWidth,
                height: GameConstants.gameTableCardHeight,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyTable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.table_restaurant,
          size: 48,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        SizedBox(height: 16),
        Text(
          GameMessages.emptyTable,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPistiEffect() {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: Duration(milliseconds: GameConstants.pistiEffectDuration),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              GameMessages.pistiMessage,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}