import 'package:flutter_test/flutter_test.dart';
import 'package:pisti_mobile_flutter/features/game/domain/models/playing_card.dart';
import 'package:pisti_mobile_flutter/core/constants/game_constants.dart';

void main() {
  group('PlayingCard', () {
    test('should have correct points for ace', () {
      const aceOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      expect(aceOfHearts.points, GameConstants.acePoints);
    });

    test('should have correct points for jack', () {
      const jackOfSpades = PlayingCard(suit: CardSuit.spades, rank: CardRank.jack);
      expect(jackOfSpades.points, GameConstants.jackPoints);
    });

    test('should have correct points for two of clubs', () {
      const twoOfClubs = PlayingCard(suit: CardSuit.clubs, rank: CardRank.two);
      expect(twoOfClubs.points, GameConstants.twoOfClubsPoints);
    });

    test('should have correct points for ten of diamonds', () {
      const tenOfDiamonds = PlayingCard(suit: CardSuit.diamonds, rank: CardRank.ten);
      expect(tenOfDiamonds.points, GameConstants.tenOfDiamondsPoints);
    });

    test('should have zero points for regular cards', () {
      const fiveOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.five);
      expect(fiveOfHearts.points, 0);
    });

    test('should be able to capture same rank', () {
      const aceOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      const aceOfSpades = PlayingCard(suit: CardSuit.spades, rank: CardRank.ace);
      expect(aceOfHearts.canCapture(aceOfSpades), true);
    });

    test('should be able to capture with jack', () {
      const jackOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.jack);
      const kingOfSpades = PlayingCard(suit: CardSuit.spades, rank: CardRank.king);
      expect(jackOfHearts.canCapture(kingOfSpades), true);
    });

    test('should not be able to capture different ranks', () {
      const aceOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      const kingOfSpades = PlayingCard(suit: CardSuit.spades, rank: CardRank.king);
      expect(aceOfHearts.canCapture(kingOfSpades), false);
    });

    test('should generate correct display names', () {
      const aceOfHearts = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      expect(aceOfHearts.displayName, 'As Kupa');
    });

    test('should be equal when same suit and rank', () {
      const card1 = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      const card2 = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      expect(card1, equals(card2));
    });

    test('should not be equal when different suit or rank', () {
      const card1 = PlayingCard(suit: CardSuit.hearts, rank: CardRank.ace);
      const card2 = PlayingCard(suit: CardSuit.spades, rank: CardRank.ace);
      expect(card1, isNot(equals(card2)));
    });
  });
}