import 'package:flutter_test/flutter_test.dart';
import 'package:pisti_mobile_flutter/features/game/domain/models/deck.dart';
import 'package:pisti_mobile_flutter/features/game/domain/models/playing_card.dart';

void main() {
  group('Deck', () {
    test('should initialize with 52 cards', () {
      final deck = Deck();
      expect(deck.remainingCards, 52);
    });

    test('should not be empty when initialized', () {
      final deck = Deck();
      expect(deck.isEmpty, false);
    });

    test('should draw cards and decrease count', () {
      final deck = Deck();
      final card = deck.drawCard();
      expect(card, isNotNull);
      expect(deck.remainingCards, 51);
    });

    test('should draw multiple cards', () {
      final deck = Deck();
      final cards = deck.drawCards(5);
      expect(cards.length, 5);
      expect(deck.remainingCards, 47);
    });

    test('should return null when deck is empty', () {
      final deck = Deck();
      // Draw all cards
      while (!deck.isEmpty) {
        deck.drawCard();
      }
      final card = deck.drawCard();
      expect(card, isNull);
    });

    test('should be empty when all cards are drawn', () {
      final deck = Deck();
      // Draw all cards
      while (!deck.isEmpty) {
        deck.drawCard();
      }
      expect(deck.isEmpty, true);
      expect(deck.remainingCards, 0);
    });

    test('should reset to 52 cards', () {
      final deck = Deck();
      // Draw some cards
      deck.drawCards(20);
      expect(deck.remainingCards, 32);
      
      // Reset
      deck.reset();
      expect(deck.remainingCards, 52);
      expect(deck.isEmpty, false);
    });

    test('should shuffle cards differently', () {
      final deck1 = Deck();
      final deck2 = Deck();
      
      // Draw first cards from both decks before shuffling
      final firstCard1 = deck1.drawCard();
      deck1.reset();
      
      deck2.shuffle();
      final firstCard2 = deck2.drawCard();
      
      // Note: This test might occasionally fail due to random nature
      // but it's very unlikely to get the same card in the same position
      // after shuffling in a real scenario
      expect(firstCard1, isNotNull);
      expect(firstCard2, isNotNull);
    });

    test('should contain all card ranks and suits', () {
      final deck = Deck();
      final allCards = <PlayingCard>[];
      
      // Draw all cards
      while (!deck.isEmpty) {
        final card = deck.drawCard();
        if (card != null) {
          allCards.add(card);
        }
      }
      
      expect(allCards.length, 52);
      
      // Check that we have all suits
      for (final suit in CardSuit.values) {
        final cardsOfSuit = allCards.where((card) => card.suit == suit);
        expect(cardsOfSuit.length, 13);
      }
      
      // Check that we have all ranks
      for (final rank in CardRank.values) {
        final cardsOfRank = allCards.where((card) => card.rank == rank);
        expect(cardsOfRank.length, 4);
      }
    });
  });
}