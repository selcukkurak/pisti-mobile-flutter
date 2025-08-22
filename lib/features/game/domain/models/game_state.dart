import 'playing_card.dart';
import 'player.dart';

enum GamePhase {
  notStarted,
  dealing,
  playing,
  roundEnd,
  gameEnd,
}

enum GameMode {
  offline,
  online,
}

class GameState {
  final GameMode mode;
  final List<Player> players;
  final List<PlayingCard> tableCards;
  GamePhase phase;
  int currentPlayerIndex;
  int round;
  String? winnerId;
  PlayingCard? lastPlayedCard;
  bool isPisti;

  GameState({
    required this.mode,
    required this.players,
    this.tableCards = const [],
    this.phase = GamePhase.notStarted,
    this.currentPlayerIndex = 0,
    this.round = 1,
    this.winnerId,
    this.lastPlayedCard,
    this.isPisti = false,
  });

  Player get currentPlayer => players[currentPlayerIndex];
  
  PlayingCard? get topTableCard => 
      tableCards.isNotEmpty ? tableCards.last : null;

  bool get isGameOver => phase == GamePhase.gameEnd;
  
  bool get canPlayCard => phase == GamePhase.playing;

  Player? get winner => winnerId != null 
      ? players.firstWhere((p) => p.id == winnerId)
      : null;

  GameState copyWith({
    GameMode? mode,
    List<Player>? players,
    List<PlayingCard>? tableCards,
    GamePhase? phase,
    int? currentPlayerIndex,
    int? round,
    String? winnerId,
    PlayingCard? lastPlayedCard,
    bool? isPisti,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      players: players ?? this.players,
      tableCards: tableCards ?? this.tableCards,
      phase: phase ?? this.phase,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      round: round ?? this.round,
      winnerId: winnerId ?? this.winnerId,
      lastPlayedCard: lastPlayedCard ?? this.lastPlayedCard,
      isPisti: isPisti ?? this.isPisti,
    );
  }

  void nextPlayer() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
  }

  void resetRound() {
    for (final player in players) {
      player.hand.clear();
    }
    tableCards.clear();
    phase = GamePhase.dealing;
    lastPlayedCard = null;
    isPisti = false;
  }

  void reset() {
    for (final player in players) {
      player.reset();
    }
    tableCards.clear();
    phase = GamePhase.notStarted;
    currentPlayerIndex = 0;
    round = 1;
    winnerId = null;
    lastPlayedCard = null;
    isPisti = false;
  }
}