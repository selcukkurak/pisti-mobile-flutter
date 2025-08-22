import 'playing_card.dart';

class Player {
  final String id;
  final String name;
  final bool isHuman;
  List<PlayingCard> hand = [];
  List<PlayingCard> capturedCards = [];
  int score = 0;
  int pistiCount = 0;

  Player({
    required this.id,
    required this.name,
    this.isHuman = true,
  });

  void addCard(PlayingCard card) {
    hand.add(card);
  }

  void addCards(List<PlayingCard> cards) {
    hand.addAll(cards);
  }

  PlayingCard? removeCard(PlayingCard card) {
    if (hand.contains(card)) {
      hand.remove(card);
      return card;
    }
    return null;
  }

  void captureCards(List<PlayingCard> cards, {bool isPisti = false}) {
    capturedCards.addAll(cards);
    if (isPisti) {
      pistiCount++;
      score += 10; // Pişti bonus
    }
    _calculateScore();
  }

  void _calculateScore() {
    score = pistiCount * 10; // Pişti bonuses
    
    // Add card points
    for (final card in capturedCards) {
      score += card.points;
    }

    // Majority bonus for having most cards
    // This will be calculated at game end by comparing with opponent
  }

  void reset() {
    hand.clear();
    capturedCards.clear();
    score = 0;
    pistiCount = 0;
  }

  bool get hasCards => hand.isNotEmpty;
  int get cardCount => hand.length;
  int get capturedCardCount => capturedCards.length;

  @override
  String toString() => '$name (Score: $score, Pişti: $pistiCount)';
}