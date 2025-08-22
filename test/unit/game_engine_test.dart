import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/game/domain/entities/playing_card.dart';
import '../../lib/features/game/domain/entities/player.dart';
import '../../lib/features/game/domain/entities/game.dart';
import '../../lib/features/game/domain/usecases/deck_generator.dart';
import '../../lib/features/game/domain/usecases/pisti_game_engine.dart';

void main() {
  group('Pişti Game Engine Tests', () {
    test('should generate standard 52-card deck', () {
      final deck = DeckGenerator.generateStandardDeck();
      
      expect(deck.length, 52);
      expect(deck.where((card) => card.suit == Suit.hearts).length, 13);
      expect(deck.where((card) => card.suit == Suit.diamonds).length, 13);
      expect(deck.where((card) => card.suit == Suit.clubs).length, 13);
      expect(deck.where((card) => card.suit == Suit.spades).length, 13);
    });

    test('should create new game with proper initial state', () {
      final players = [
        const Player(id: 'p1', name: 'Player 1', type: PlayerType.human),
        const Player(id: 'p2', name: 'Player 2', type: PlayerType.ai),
      ];
      
      final game = PistiGameEngine.createGame('test_game', GameMode.offline, players);
      
      expect(game.id, 'test_game');
      expect(game.mode, GameMode.offline);
      expect(game.status, GameStatus.inProgress);
      expect(game.players.length, 2);
      expect(game.players[0].cardIds.length, 4); // Each player gets 4 cards
      expect(game.players[1].cardIds.length, 4);
      expect(game.middlePile.length, 1); // One card in middle
      expect(game.deck.length, 43); // 52 - 8 (player cards) - 1 (middle) = 43
      expect(game.currentPlayerIndex, 0);
      expect(game.players[0].isCurrentPlayer, true);
      expect(game.players[1].isCurrentPlayer, false);
    });

    test('should handle card play correctly', () {
      final players = [
        const Player(id: 'p1', name: 'Player 1', type: PlayerType.human),
        const Player(id: 'p2', name: 'Player 2', type: PlayerType.ai),
      ];
      
      final initialGame = PistiGameEngine.createGame('test_game', GameMode.offline, players);
      final cardToPlay = initialGame.players[0].cardIds.first;
      
      final updatedGame = PistiGameEngine.playCard(initialGame, cardToPlay, 0);
      
      expect(updatedGame.players[0].cardIds.length, 3); // One less card
      expect(updatedGame.currentPlayerIndex, 1); // Next player's turn
      expect(updatedGame.players[0].isCurrentPlayer, false);
      expect(updatedGame.players[1].isCurrentPlayer, true);
    });

    test('should detect Pişti correctly', () {
      // Create a specific scenario for testing Pişti
      final players = [
        const Player(
          id: 'p1', 
          name: 'Player 1', 
          type: PlayerType.human,
          cardIds: ['spades_jack'], // Jack to play
          isCurrentPlayer: true,
        ),
        const Player(id: 'p2', name: 'Player 2', type: PlayerType.ai),
      ];
      
      final game = Game(
        id: 'test_game',
        mode: GameMode.offline,
        status: GameStatus.inProgress,
        players: players,
        deck: const [],
        middlePile: const [PlayingCard(suit: Suit.hearts, rank: Rank.king)], // Single card
        topCard: const PlayingCard(suit: Suit.hearts, rank: Rank.king),
        currentPlayerIndex: 0,
        createdAt: DateTime.now(),
      );
      
      final updatedGame = PistiGameEngine.playCard(game, 'spades_jack', 0);
      
      expect(updatedGame.isPisti, true);
      expect(updatedGame.players[0].score, greaterThan(10)); // Should get Pişti bonus
    });

    test('should calculate card points correctly', () {
      const jackCard = PlayingCard(suit: Suit.spades, rank: Rank.jack);
      const aceCard = PlayingCard(suit: Suit.hearts, rank: Rank.ace);
      const twoOfClubs = PlayingCard(suit: Suit.clubs, rank: Rank.two);
      const tenOfDiamonds = PlayingCard(suit: Suit.diamonds, rank: Rank.ten);
      const normalCard = PlayingCard(suit: Suit.hearts, rank: Rank.five);
      
      expect(jackCard.points, 1);
      expect(aceCard.points, 1);
      expect(twoOfClubs.points, 2);
      expect(tenOfDiamonds.points, 3);
      expect(normalCard.points, 0);
    });

    test('should handle game end correctly', () {
      final players = [
        const Player(
          id: 'p1', 
          name: 'Player 1', 
          type: PlayerType.human,
          cardIds: ['hearts_ace'], // Last card
          score: 15,
          isCurrentPlayer: true,
        ),
        const Player(
          id: 'p2', 
          name: 'Player 2', 
          type: PlayerType.ai,
          cardIds: [], // No cards left
          score: 10,
        ),
      ];
      
      final game = Game(
        id: 'test_game',
        mode: GameMode.offline,
        status: GameStatus.inProgress,
        players: players,
        deck: const [], // Empty deck
        middlePile: const [],
        currentPlayerIndex: 0,
        createdAt: DateTime.now(),
      );
      
      final updatedGame = PistiGameEngine.playCard(game, 'hearts_ace', 0);
      
      expect(updatedGame.status, GameStatus.finished);
      expect(updatedGame.winnerId, 'p1'); // Player 1 has higher score
      expect(updatedGame.finishedAt, isNotNull);
    });
  });

  group('Playing Card Tests', () {
    test('should create card with correct properties', () {
      const card = PlayingCard(suit: Suit.hearts, rank: Rank.king);
      
      expect(card.suit, Suit.hearts);
      expect(card.rank, Rank.king);
      expect(card.isVisible, true);
      expect(card.displayName, 'K♥');
    });

    test('should identify special cards correctly', () {
      const jack = PlayingCard(suit: Suit.spades, rank: Rank.jack);
      const ace = PlayingCard(suit: Suit.hearts, rank: Rank.ace);
      const twoOfClubs = PlayingCard(suit: Suit.clubs, rank: Rank.two);
      const tenOfDiamonds = PlayingCard(suit: Suit.diamonds, rank: Rank.ten);
      
      expect(jack.isJack, true);
      expect(ace.isAce, true);
      expect(twoOfClubs.isTwoOfClubs, true);
      expect(tenOfDiamonds.isTenOfDiamonds, true);
    });
  });

  group('Player Tests', () {
    test('should create player with correct properties', () {
      const player = Player(
        id: 'p1',
        name: 'Test Player',
        type: PlayerType.human,
        cardIds: ['hearts_ace', 'spades_king'],
        score: 10,
        cardsWon: 5,
        isCurrentPlayer: true,
      );
      
      expect(player.id, 'p1');
      expect(player.name, 'Test Player');
      expect(player.type, PlayerType.human);
      expect(player.cardIds.length, 2);
      expect(player.score, 10);
      expect(player.cardsWon, 5);
      expect(player.isCurrentPlayer, true);
      expect(player.isHuman, true);
      expect(player.hasCards, true);
      expect(player.cardCount, 2);
    });
  });
}