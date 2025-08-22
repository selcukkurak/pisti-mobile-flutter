import 'package:flutter/material.dart';

import '../../features/game/domain/entities/playing_card.dart';

class CardWidget extends StatefulWidget {
  final PlayingCard? card;
  final double width;
  final double height;
  final bool isVisible;
  final bool isSelected;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const CardWidget({
    super.key,
    this.card,
    this.width = 80.0,
    this.height = 120.0,
    this.isVisible = true,
    this.isSelected = false,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.isVisible && widget.card != null
                  ? _buildCardFace()
                  : _buildCardBack(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardFace() {
    final card = widget.card!;
    final isRed = card.suit == Suit.hearts || card.suit == Suit.diamonds;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isSelected ? Colors.blue : Colors.grey.shade400,
          width: widget.isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top rank and suit
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getRankDisplay(card.rank),
                    style: TextStyle(
                      fontSize: widget.width * 0.15,
                      fontWeight: FontWeight.bold,
                      color: isRed ? Colors.red : Colors.black,
                    ),
                  ),
                  Text(
                    _getSuitDisplay(card.suit),
                    style: TextStyle(
                      fontSize: widget.width * 0.12,
                      color: isRed ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Center suit symbol
          Center(
            child: Text(
              _getSuitDisplay(card.suit),
              style: TextStyle(
                fontSize: widget.width * 0.4,
                color: isRed ? Colors.red : Colors.black,
              ),
            ),
          ),
          
          // Bottom rank and suit (rotated)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.rotate(
                angle: 3.14159, // 180 degrees
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getRankDisplay(card.rank),
                      style: TextStyle(
                        fontSize: widget.width * 0.15,
                        fontWeight: FontWeight.bold,
                        color: isRed ? Colors.red : Colors.black,
                      ),
                    ),
                    Text(
                      _getSuitDisplay(card.suit),
                      style: TextStyle(
                        fontSize: widget.width * 0.12,
                        color: isRed ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2),
            Color(0xFF1565C0),
          ],
        ),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Icon(
          Icons.style,
          size: widget.width * 0.4,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getRankDisplay(Rank rank) {
    switch (rank) {
      case Rank.ace:
        return 'A';
      case Rank.two:
        return '2';
      case Rank.three:
        return '3';
      case Rank.four:
        return '4';
      case Rank.five:
        return '5';
      case Rank.six:
        return '6';
      case Rank.seven:
        return '7';
      case Rank.eight:
        return '8';
      case Rank.nine:
        return '9';
      case Rank.ten:
        return '10';
      case Rank.jack:
        return 'J';
      case Rank.queen:
        return 'Q';
      case Rank.king:
        return 'K';
    }
  }

  String _getSuitDisplay(Suit suit) {
    switch (suit) {
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.spades:
        return '♠';
    }
  }
}