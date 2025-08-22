import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/player.dart';
import '../../domain/models/playing_card.dart';
import '../../domain/models/deck.dart';

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
      Player(id: '2', name: 'Bilgisayar', isHuman: false),
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

    emit(newState.copyWith(phase: GamePhase.playing));
  }

  void _dealCards(GameState gameState) {
    // Deal 4 cards to each player
    for (int i = 0; i < 4; i++) {
      for (final player in gameState.players) {
        final card = _deck.drawCard();
        if (card != null) {
          player.addCard(card);
        }
      }
    }

    // Place 4 cards on table
    final tableCards = _deck.drawCards(4);
    gameState.tableCards.addAll(tableCards);
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
        }

        // Capture all cards
        final capturedCards = [...newTableCards, playedCard];
        currentPlayer.captureCards(capturedCards, isPisti: isPisti);
        newTableCards.clear();
      }
    }

    if (!captured) {
      newTableCards.add(playedCard);
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
    return gameState.players.every((player) => !player.hasCards) &&
           _deck.isEmpty;
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
    playerWithMostCards.score += 3;

    // Check if game is over (first to reach 151 points)
    final winner = gameState.players
        .where((p) => p.score >= 151)
        .isEmpty ? null : gameState.players
        .reduce((a, b) => a.score > b.score ? a : b);

    if (winner != null) {
      gameState.winnerId = winner.id;
      gameState.phase = GamePhase.gameEnd;
    }
  }

  void _playAITurn(GameState gameState, Emitter<GameState> emit) {
    Future.delayed(Duration(milliseconds: 1000), () {
      final aiPlayer = gameState.currentPlayer;
      if (aiPlayer.hasCards && !aiPlayer.isHuman) {
        // Simple AI: play first card that can capture, otherwise play first card
        PlayingCard cardToPlay = aiPlayer.hand.first;
        
        if (gameState.tableCards.isNotEmpty) {
          final topCard = gameState.tableCards.last;
          final capturingCard = aiPlayer.hand
              .where((card) => card.canCapture(topCard))
              .firstOrNull;
          if (capturingCard != null) {
            cardToPlay = capturingCard;
          }
        }

        add(PlayCardEvent(cardToPlay));
      }
    });
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