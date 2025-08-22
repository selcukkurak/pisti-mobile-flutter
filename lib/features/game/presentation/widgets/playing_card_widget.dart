import 'package:flutter/material.dart';
import '../../domain/models/playing_card.dart';
import '../../../core/constants/game_constants.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool isHidden;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const PlayingCardWidget({
    Key? key,
    required this.card,
    this.isHidden = false,
    this.isSelected = false,
    this.onTap,
    this.width = GameConstants.cardWidth,
    this.height = GameConstants.cardHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: GameConstants.cardAnimationDuration),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.1 : 1.0)
          ..translate(0.0, isSelected ? -10.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.black26,
                blurRadius: isSelected ? 8 : 4,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isHidden ? _buildCardBack() : _buildCardFront(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1565C0),
            Color(0xFF0D47A1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.casino,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final isRed = card.suit == CardSuit.hearts || card.suit == CardSuit.diamonds;
    final color = isRed ? Colors.red : Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top left corner
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getRankSymbol(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _getSuitIcon(),
                color: color,
                size: 10,
              ),
            ],
          ),
        ),
        
        // Center suit symbol
        Icon(
          _getSuitIcon(),
          color: color,
          size: 24,
        ),
        
        // Bottom right corner (rotated)
        Transform.rotate(
          angle: 3.14159, // 180 degrees
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getRankSymbol(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _getSuitIcon(),
                color: color,
                size: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRankSymbol() {
    switch (card.rank) {
      case CardRank.ace:
        return 'A';
      case CardRank.jack:
        return 'J';
      case CardRank.queen:
        return 'Q';
      case CardRank.king:
        return 'K';
      case CardRank.two:
        return '2';
      case CardRank.three:
        return '3';
      case CardRank.four:
        return '4';
      case CardRank.five:
        return '5';
      case CardRank.six:
        return '6';
      case CardRank.seven:
        return '7';
      case CardRank.eight:
        return '8';
      case CardRank.nine:
        return '9';
      case CardRank.ten:
        return '10';
    }
  }

  IconData _getSuitIcon() {
    switch (card.suit) {
      case CardSuit.hearts:
        return Icons.favorite;
      case CardSuit.diamonds:
        return Icons.change_history;
      case CardSuit.clubs:
        return Icons.local_florist;
      case CardSuit.spades:
        return Icons.spa;
    }
  }
}