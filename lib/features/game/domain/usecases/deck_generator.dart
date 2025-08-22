import '../entities/playing_card.dart';

class DeckGenerator {
  static List<PlayingCard> generateStandardDeck() {
    final List<PlayingCard> deck = [];
    
    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }
    
    return deck;
  }
  
  static List<PlayingCard> shuffleDeck(List<PlayingCard> deck) {
    final shuffled = List<PlayingCard>.from(deck);
    shuffled.shuffle();
    return shuffled;
  }
  
  static List<PlayingCard> createShuffledDeck() {
    final deck = generateStandardDeck();
    return shuffleDeck(deck);
  }
}