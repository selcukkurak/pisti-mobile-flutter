import 'playing_card.dart';

class Deck {
  List<PlayingCard> _cards = [];

  Deck() {
    _initializeDeck();
  }

  void _initializeDeck() {
    _cards.clear();
    for (final suit in CardSuit.values) {
      for (final rank in CardRank.values) {
        _cards.add(PlayingCard(suit: suit, rank: rank));
      }
    }
  }

  void shuffle() {
    _cards.shuffle();
  }

  PlayingCard? drawCard() {
    if (_cards.isEmpty) return null;
    return _cards.removeLast();
  }

  List<PlayingCard> drawCards(int count) {
    final drawnCards = <PlayingCard>[];
    for (int i = 0; i < count && _cards.isNotEmpty; i++) {
      final card = drawCard();
      if (card != null) {
        drawnCards.add(card);
      }
    }
    return drawnCards;
  }

  bool get isEmpty => _cards.isEmpty;
  
  int get remainingCards => _cards.length;
  
  void reset() {
    _initializeDeck();
  }
}