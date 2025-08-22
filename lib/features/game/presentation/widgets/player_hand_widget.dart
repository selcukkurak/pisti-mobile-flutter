import 'package:flutter/material.dart';
import '../../domain/models/player.dart';
import '../../domain/models/playing_card.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatefulWidget {
  final Player player;
  final bool isCurrentPlayer;
  final bool isHidden;
  final Function(PlayingCard)? onCardTap;

  const PlayerHandWidget({
    Key? key,
    required this.player,
    required this.isCurrentPlayer,
    this.isHidden = false,
    this.onCardTap,
  }) : super(key: key);

  @override
  _PlayerHandWidgetState createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  PlayingCard? selectedCard;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerHandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPlayer != oldWidget.isCurrentPlayer) {
      if (widget.isCurrentPlayer) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        selectedCard = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Player indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.isCurrentPlayer
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isCurrentPlayer
                          ? Icons.play_arrow
                          : Icons.person,
                      size: 16,
                      color: widget.isCurrentPlayer
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 4),
                    Text(
                      widget.player.name,
                      style: TextStyle(
                        color: widget.isCurrentPlayer
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 12),
              
              // Player hand
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildHandCards(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildHandCards() {
    if (widget.player.hand.isEmpty) {
      return [
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Text(
              'Boş',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ),
      ];
    }

    return widget.player.hand.asMap().entries.map((entry) {
      final index = entry.key;
      final card = entry.value;
      final isSelected = selectedCard == card && widget.isCurrentPlayer;
      
      return Container(
        margin: EdgeInsets.only(
          left: index > 0 ? 8 : 0,
        ),
        child: PlayingCardWidget(
          card: card,
          isHidden: widget.isHidden,
          isSelected: isSelected,
          onTap: widget.isHidden || !widget.isCurrentPlayer
              ? null
              : () => _onCardTap(card),
        ),
      );
    }).toList();
  }

  void _onCardTap(PlayingCard card) {
    if (!widget.isCurrentPlayer) return;

    setState(() {
      selectedCard = selectedCard == card ? null : card;
    });

    if (widget.onCardTap != null) {
      widget.onCardTap!(card);
    }
  }
}