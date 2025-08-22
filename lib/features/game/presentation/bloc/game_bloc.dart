import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/player.dart';
import '../../domain/models/playing_card.dart';
import '../../domain/models/deck.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/constants/game_constants.dart';

// Events
abstract class GameEvent {}

class StartGameEvent extends GameEvent {
  final GameMode mode;
  final String playerName;
  
  StartGameEvent({required this.mode, required this.playerName});
}

class PlayCardEvent extends GameEvent {
  final PlayingCard card;
  
  PlayCardEvent(this.card);
}

class NextRoundEvent extends GameEvent {}

class ResetGameEvent extends GameEvent {}

// States
class GameBloc extends Bloc<GameEvent, GameState> {
  late Deck _deck;

  GameBloc() : super(GameState(
    mode: GameMode.offline,
    players: [],
  )) {
    on<StartGameEvent>(_onStartGame);
    on<PlayCardEvent>(_onPlayCard);
    on<NextRoundEvent>(_onNextRound);
    on<ResetGameEvent>(_onResetGame);
  }

  void _onStartGame(StartGameEvent event, Emitter<GameState> emit) {
    final players = [
      Player(id: '1', name: event.playerName, isHuman: true),
      Player(id: '2', name: GameConstants.aiPlayerName, isHuman: false),
    ];

    _deck = Deck();
    _deck.shuffle();

    final newState = GameState(
      mode: event.mode,
      players: players,
      tableCards: [],
      phase: GamePhase.dealing,
      currentPlayerIndex: 0,
      round: 1,
    );

    // Deal initial cards
    _dealCards(newState);

    // Play game start sound
    SoundType.gameStart.play();

    emit(newState.copyWith(phase: GamePhase.playing));
  }

  void _dealCards(GameState gameState) {
    // Deal 4 cards to each player
    for (int i = 0; i < GameConstants.cardsPerHand; i++) {
      for (final player in gameState.players) {
        final card = _deck.drawCard();
        if (card != null) {
          player.addCard(card);
        }
      }
    }

    // Place 4 cards on table
    final tableCards = _deck.drawCards(GameConstants.cardsOnTableAtStart);
    gameState.tableCards.clear();
    gameState.tableCards.addAll(tableCards);
    
    // If there are any Jacks on the table, put them at the bottom and draw new cards
    while (gameState.tableCards.any((card) => card.rank == CardRank.jack)) {
      final jackIndex = gameState.tableCards.indexWhere((card) => card.rank == CardRank.jack);
      final jack = gameState.tableCards.removeAt(jackIndex);
      // Put jack back in deck (at bottom)
      final newCard = _deck.drawCard();
      if (newCard != null) {
        gameState.tableCards.add(newCard);
      }
    }
  }

  void _onPlayCard(PlayCardEvent event, Emitter<GameState> emit) {
    if (!state.canPlayCard) return;

    final currentPlayer = state.currentPlayer;
    final playedCard = currentPlayer.removeCard(event.card);
    
    if (playedCard == null) return;

    final newTableCards = List<PlayingCard>.from(state.tableCards);
    bool isPisti = false;
    bool captured = false;

    // Check if card can capture
    if (newTableCards.isNotEmpty) {
      final topCard = newTableCards.last;
      
      if (playedCard.canCapture(topCard)) {
        captured = true;
        
        // Check for Pişti (capturing with same rank when only one card on table)
        if (newTableCards.length == 1 && 
            playedCard.rank == topCard.rank && 
            playedCard.rank != CardRank.jack) {
          isPisti = true;
          SoundType.pisti.play();
        } else {
          SoundType.capture.play();
        }

        // Capture all cards
        final capturedCards = [...newTableCards, playedCard];
        currentPlayer.captureCards(capturedCards, isPisti: isPisti);
        newTableCards.clear();
      }
    }

    if (!captured) {
      newTableCards.add(playedCard);
      SoundType.cardPlace.play();
    }

    final newState = state.copyWith(
      tableCards: newTableCards,
      lastPlayedCard: playedCard,
      isPisti: isPisti,
    );

    newState.nextPlayer();

    // Check if round is over
    if (_isRoundOver(newState)) {
      _endRound(newState);
      emit(newState.copyWith(phase: GamePhase.roundEnd));
    } else {
      emit(newState);
      
      // AI turn if current player is not human
      if (!newState.currentPlayer.isHuman) {
        _playAITurn(newState, emit);
      }
    }
  }

  bool _isRoundOver(GameState gameState) {
    // Round is over when all players have no cards and no more cards to deal
    bool allPlayersEmpty = gameState.players.every((player) => !player.hasCards);
    
    // If players are empty but deck has cards, deal more cards
    if (allPlayersEmpty && !_deck.isEmpty) {
      _dealCards(gameState);
      return false;
    }
    
    return allPlayersEmpty && _deck.isEmpty;
  }

  void _endRound(GameState gameState) {
    // Award remaining table cards to last capturer
    if (gameState.tableCards.isNotEmpty) {
      // Find player with most recent capture or first player
      final lastCapturer = gameState.players.first;
      lastCapturer.capturedCards.addAll(gameState.tableCards);
    }

    // Calculate majority bonus (player with most cards gets 3 points)
    final cardCounts = gameState.players.map((p) => p.capturedCardCount).toList();
    final maxCards = cardCounts.reduce((a, b) => a > b ? a : b);
    final playerWithMostCards = gameState.players
        .where((p) => p.capturedCardCount == maxCards)
        .first;
    playerWithMostCards.score += GameConstants.majorityBonus;

    // Check if game is over (first to reach winning score)
    final winner = gameState.players
        .where((p) => p.score >= GameConstants.winningScore)
        .isEmpty ? null : gameState.players
        .reduce((a, b) => a.score > b.score ? a : b);

    if (winner != null) {
      gameState.winnerId = winner.id;
      gameState.phase = GamePhase.gameEnd;
      SoundType.gameEnd.play();
    }
  }

  void _playAITurn(GameState gameState, Emitter<GameState> emit) {
    Future.delayed(Duration(milliseconds: GameConstants.aiThinkingTime), () {
      final aiPlayer = gameState.currentPlayer;
      if (aiPlayer.hasCards && !aiPlayer.isHuman && gameState.canPlayCard) {
        PlayingCard cardToPlay = _selectBestAICard(aiPlayer, gameState);
        add(PlayCardEvent(cardToPlay));
      }
    });
  }

  PlayingCard _selectBestAICard(Player aiPlayer, GameState gameState) {
    // AI strategy:
    // 1. If can capture cards, prioritize high-value cards
    // 2. If can make Pişti, do it
    // 3. If table has one card and AI has same rank (not Jack), avoid playing it unless no choice
    // 4. Play low-value cards when can't capture
    
    if (gameState.tableCards.isNotEmpty) {
      final topCard = gameState.tableCards.last;
      
      // Find cards that can capture
      final capturingCards = aiPlayer.hand
          .where((card) => card.canCapture(topCard))
          .toList();
      
      if (capturingCards.isNotEmpty) {
        // If can make Pişti (table has exactly one card, and we have matching rank, not Jack)
        if (gameState.tableCards.length == 1) {
          final pistiCard = capturingCards
              .where((card) => card.rank == topCard.rank && card.rank != CardRank.jack)
              .firstOrNull;
          if (pistiCard != null) {
            return pistiCard; // Make Pişti!
          }
        }
        
        // Otherwise, play Jack if available (always good)
        final jackCard = capturingCards
            .where((card) => card.rank == CardRank.jack)
            .firstOrNull;
        if (jackCard != null) {
          return jackCard;
        }
        
        // Or play any capturing card
        return capturingCards.first;
      }
    }
    
    // Can't capture, play lowest value card
    aiPlayer.hand.sort((a, b) => a.points.compareTo(b.points));
    return aiPlayer.hand.first;
  }

  void _onNextRound(NextRoundEvent event, Emitter<GameState> emit) {
    if (state.phase != GamePhase.roundEnd) return;

    state.resetRound();
    state.round++;
    
    _deck.reset();
    _deck.shuffle();
    _dealCards(state);

    emit(state.copyWith(phase: GamePhase.playing));
  }

  void _onResetGame(ResetGameEvent event, Emitter<GameState> emit) {
    emit(GameState(
      mode: GameMode.offline,
      players: [],
    ));
  }
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}