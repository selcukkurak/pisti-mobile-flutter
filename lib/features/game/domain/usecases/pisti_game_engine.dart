import '../entities/game.dart';
import '../entities/player.dart';
import '../entities/playing_card.dart';
import 'deck_generator.dart';

class PistiGameEngine {
  
  /// Create a new Pişti game
  static Game createGame(String gameId, GameMode mode, List<Player> players) {
    final deck = DeckGenerator.createShuffledDeck();
    final middlePile = <PlayingCard>[];
    
    // Deal initial cards to players (4 cards each)
    final updatedPlayers = <Player>[];
    int cardIndex = 0;
    
    for (int i = 0; i < players.length; i++) {
      final playerCards = <String>[];
      for (int j = 0; j < 4; j++) {
        playerCards.add('${deck[cardIndex].suit.name}_${deck[cardIndex].rank.name}');
        cardIndex++;
      }
      updatedPlayers.add(players[i].copyWith(
        cardIds: playerCards,
        isCurrentPlayer: i == 0,
      ));
    }
    
    // Remove dealt cards from deck
    final remainingDeck = deck.skip(cardIndex).toList();
    
    // Place one card in the middle
    PlayingCard? topCard;
    if (remainingDeck.isNotEmpty) {
      topCard = remainingDeck.removeAt(0);
      middlePile.add(topCard);
    }
    
    return Game(
      id: gameId,
      mode: mode,
      status: GameStatus.inProgress,
      players: updatedPlayers,
      deck: remainingDeck,
      middlePile: middlePile,
      topCard: topCard,
      currentPlayerIndex: 0,
      round: 1,
      createdAt: DateTime.now(),
    );
  }
  
  /// Play a card and update game state
  static Game playCard(Game game, String cardId, int playerIndex) {
    if (game.status != GameStatus.inProgress) {
      throw Exception('Game is not in progress');
    }
    
    if (playerIndex != game.currentPlayerIndex) {
      throw Exception('Not current player\'s turn');
    }
    
    final player = game.players[playerIndex];
    if (!player.cardIds.contains(cardId)) {
      throw Exception('Player does not have this card');
    }
    
    // Parse card from cardId
    final cardParts = cardId.split('_');
    final suit = Suit.values.firstWhere((s) => s.name == cardParts[0]);
    final rank = Rank.values.firstWhere((r) => r.name == cardParts[1]);
    final playedCard = PlayingCard(suit: suit, rank: rank);
    
    // Remove card from player's hand
    final updatedCardIds = List<String>.from(player.cardIds)..remove(cardId);
    
    // Check if card can capture middle pile
    final canCapture = game.topCard != null && 
        (playedCard.rank == game.topCard!.rank || playedCard.isJack);
    
    // Check for Pişti (Jack captures single card)
    final isPisti = playedCard.isJack && game.middlePile.length == 1;
    
    List<PlayingCard> newMiddlePile;
    PlayingCard? newTopCard;
    int additionalScore = 0;
    int additionalCardsWon = 0;
    
    if (canCapture) {
      // Player captures all cards in middle
      newMiddlePile = [];
      newTopCard = null;
      additionalCardsWon = game.middlePile.length + 1; // +1 for the played card
      
      // Calculate points
      for (final card in game.middlePile) {
        additionalScore += card.points;
      }
      additionalScore += playedCard.points;
      
      // Pişti bonus
      if (isPisti) {
        additionalScore += 10;
      }
    } else {
      // Card goes to middle pile
      newMiddlePile = List.from(game.middlePile)..add(playedCard);
      newTopCard = playedCard;
    }
    
    // Update player
    final updatedPlayer = player.copyWith(
      cardIds: updatedCardIds,
      score: player.score + additionalScore,
      cardsWon: player.cardsWon + additionalCardsWon,
      isCurrentPlayer: false,
    );
    
    // Update players list
    final updatedPlayers = List<Player>.from(game.players);
    updatedPlayers[playerIndex] = updatedPlayer;
    
    // Check if player needs new cards
    bool shouldDealNewCards = updatedPlayer.cardIds.isEmpty && game.deck.isNotEmpty;
    List<PlayingCard> remainingDeck = List.from(game.deck);
    
    if (shouldDealNewCards) {
      // Deal new cards to all players
      for (int i = 0; i < updatedPlayers.length; i++) {
        if (updatedPlayers[i].cardIds.isEmpty) {
          final newCards = <String>[];
          for (int j = 0; j < 4 && remainingDeck.isNotEmpty; j++) {
            final card = remainingDeck.removeAt(0);
            newCards.add('${card.suit.name}_${card.rank.name}');
          }
          updatedPlayers[i] = updatedPlayers[i].copyWith(cardIds: newCards);
        }
      }
    }
    
    // Determine next player
    final nextPlayerIndex = game.nextPlayerIndex;
    updatedPlayers[nextPlayerIndex] = updatedPlayers[nextPlayerIndex].copyWith(
      isCurrentPlayer: true,
    );
    
    // Check if game should end
    final shouldEnd = remainingDeck.isEmpty && 
        updatedPlayers.every((p) => p.cardIds.isEmpty);
    
    String? winnerId;
    GameStatus newStatus = game.status;
    
    if (shouldEnd) {
      // Game ends - determine winner
      int maxScore = -1;
      for (final p in updatedPlayers) {
        if (p.score > maxScore) {
          maxScore = p.score;
          winnerId = p.id;
        }
      }
      newStatus = GameStatus.finished;
    }
    
    return game.copyWith(
      players: updatedPlayers,
      deck: remainingDeck,
      middlePile: newMiddlePile,
      topCard: newTopCard,
      currentPlayerIndex: shouldEnd ? game.currentPlayerIndex : nextPlayerIndex,
      isPisti: isPisti,
      status: newStatus,
      winnerId: winnerId,
      finishedAt: shouldEnd ? DateTime.now() : null,
    );
  }
  
  /// Calculate final scores including remaining cards bonus
  static Game calculateFinalScores(Game game) {
    if (game.status != GameStatus.finished) return game;
    
    // Award remaining middle cards to last player who captured
    int lastCapturePlayer = 0;
    for (int i = game.players.length - 1; i >= 0; i--) {
      if (game.players[i].cardsWon > 0) {
        lastCapturePlayer = i;
        break;
      }
    }
    
    // Award bonus for most cards captured
    int maxCards = 0;
    int mostCardsPlayer = 0;
    for (int i = 0; i < game.players.length; i++) {
      if (game.players[i].cardsWon > maxCards) {
        maxCards = game.players[i].cardsWon;
        mostCardsPlayer = i;
      }
    }
    
    final updatedPlayers = List<Player>.from(game.players);
    updatedPlayers[mostCardsPlayer] = updatedPlayers[mostCardsPlayer].copyWith(
      score: updatedPlayers[mostCardsPlayer].score + 3, // Bonus for most cards
    );
    
    return game.copyWith(players: updatedPlayers);
  }
}