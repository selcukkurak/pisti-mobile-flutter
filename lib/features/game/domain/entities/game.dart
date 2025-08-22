import 'package:equatable/equatable.dart';
import 'playing_card.dart';
import 'player.dart';

enum GameMode { offline, online, privateRoom }
enum GameStatus { waiting, inProgress, finished, paused }

class Game extends Equatable {
  final String id;
  final GameMode mode;
  final GameStatus status;
  final List<Player> players;
  final List<PlayingCard> deck;
  final List<PlayingCard> middlePile;
  final PlayingCard? topCard;
  final int currentPlayerIndex;
  final int round;
  final bool isPisti;
  final String? winnerId;
  final DateTime createdAt;
  final DateTime? finishedAt;

  const Game({
    required this.id,
    required this.mode,
    required this.status,
    required this.players,
    required this.deck,
    required this.middlePile,
    this.topCard,
    this.currentPlayerIndex = 0,
    this.round = 1,
    this.isPisti = false,
    this.winnerId,
    required this.createdAt,
    this.finishedAt,
  });

  Game copyWith({
    String? id,
    GameMode? mode,
    GameStatus? status,
    List<Player>? players,
    List<PlayingCard>? deck,
    List<PlayingCard>? middlePile,
    PlayingCard? topCard,
    int? currentPlayerIndex,
    int? round,
    bool? isPisti,
    String? winnerId,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) {
    return Game(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      players: players ?? this.players,
      deck: deck ?? this.deck,
      middlePile: middlePile ?? this.middlePile,
      topCard: topCard ?? this.topCard,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      round: round ?? this.round,
      isPisti: isPisti ?? this.isPisti,
      winnerId: winnerId ?? this.winnerId,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  Player get currentPlayer => players[currentPlayerIndex];
  bool get isGameFinished => status == GameStatus.finished;
  bool get isWaitingForPlayers => status == GameStatus.waiting;
  bool get isInProgress => status == GameStatus.inProgress;
  bool get deckEmpty => deck.isEmpty;
  int get totalCardsInMiddle => middlePile.length;
  
  bool get canPlayCard => isInProgress && !deckEmpty;
  
  // Calculate if it's a Pişti (capturing with Jack when only one card in middle)
  bool checkPisti(PlayingCard playedCard, PlayingCard? middleCard) {
    return playedCard.isJack && 
           middleCard != null && 
           middlePile.length == 1;
  }

  // Check if played card can capture the middle pile
  bool canCapture(PlayingCard playedCard, PlayingCard? middleCard) {
    if (middleCard == null) return false;
    return playedCard.rank == middleCard.rank || playedCard.isJack;
  }

  // Get next player index
  int get nextPlayerIndex => (currentPlayerIndex + 1) % players.length;

  // Check if game should end (all cards played and deck empty)
  bool shouldEndGame() {
    return deck.isEmpty && players.every((player) => player.cardIds.isEmpty);
  }

  @override
  List<Object?> get props => [
        id,
        mode,
        status,
        players,
        deck,
        middlePile,
        topCard,
        currentPlayerIndex,
        round,
        isPisti,
        winnerId,
        createdAt,
        finishedAt,
      ];

  @override
  String toString() => 'Game($id, status: $status, round: $round)';
}