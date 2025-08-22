import 'package:equatable/equatable.dart';

enum PlayerType { human, ai, online }

class Player extends Equatable {
  final String id;
  final String name;
  final PlayerType type;
  final List<String> cardIds; // References to PlayingCard objects
  final int score;
  final int cardsWon;
  final bool isCurrentPlayer;

  const Player({
    required this.id,
    required this.name,
    required this.type,
    this.cardIds = const [],
    this.score = 0,
    this.cardsWon = 0,
    this.isCurrentPlayer = false,
  });

  Player copyWith({
    String? id,
    String? name,
    PlayerType? type,
    List<String>? cardIds,
    int? score,
    int? cardsWon,
    bool? isCurrentPlayer,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      cardIds: cardIds ?? this.cardIds,
      score: score ?? this.score,
      cardsWon: cardsWon ?? this.cardsWon,
      isCurrentPlayer: isCurrentPlayer ?? this.isCurrentPlayer,
    );
  }

  bool get isHuman => type == PlayerType.human;
  bool get isAI => type == PlayerType.ai;
  bool get isOnline => type == PlayerType.online;
  bool get hasCards => cardIds.isNotEmpty;
  int get cardCount => cardIds.length;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        cardIds,
        score,
        cardsWon,
        isCurrentPlayer,
      ];

  @override
  String toString() => 'Player($name, score: $score, cards: $cardCount)';
}