import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/shared/widgets/cards/card_widget.dart';
import '../../lib/features/game/domain/entities/playing_card.dart';

void main() {
  group('Card Widget Tests', () {
    testWidgets('should display card back when not visible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardWidget(
              isVisible: false,
            ),
          ),
        ),
      );

      expect(find.byType(CardWidget), findsOneWidget);
      // Card back should show app icon
      expect(find.byIcon(Icons.style), findsOneWidget);
    });

    testWidgets('should display card face when visible with card data', (WidgetTester tester) async {
      const testCard = PlayingCard(suit: Suit.hearts, rank: Rank.ace);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardWidget(
              card: testCard,
              isVisible: true,
            ),
          ),
        ),
      );

      expect(find.byType(CardWidget), findsOneWidget);
      // Should show card rank and suit
      expect(find.text('A'), findsWidgets); // Ace rank
      expect(find.text('♥'), findsWidgets); // Hearts suit
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool tapped = false;
      const testCard = PlayingCard(suit: Suit.spades, rank: Rank.king);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardWidget(
              card: testCard,
              isVisible: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CardWidget));
      expect(tapped, true);
    });

    testWidgets('should animate when selected', (WidgetTester tester) async {
      const testCard = PlayingCard(suit: Suit.diamonds, rank: Rank.queen);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardWidget(
              card: testCard,
              isVisible: true,
              isSelected: true,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150)); // Half animation
      await tester.pumpAndSettle(); // Complete animation

      expect(find.byType(CardWidget), findsOneWidget);
    });
  });
}