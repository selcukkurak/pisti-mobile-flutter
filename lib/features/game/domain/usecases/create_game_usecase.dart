// Placeholder - Game use cases
import '../repositories/game_repository.dart';

class CreateGameUsecase {
  final GameRepository repository;
  CreateGameUsecase(this.repository);

  Future<void> call(Map<String, dynamic> gameData) async {
    return await repository.createGame(gameData);
  }
}

class JoinGameUsecase {
  final GameRepository repository;
  JoinGameUsecase(this.repository);

  Future<void> call(String gameId, String playerId) async {
    return await repository.joinGame(gameId, playerId);
  }
}

class PlayCardUsecase {
  final GameRepository repository;
  PlayCardUsecase(this.repository);

  Future<void> call(String gameId, String cardId) async {
    return await repository.playCard(gameId, cardId);
  }
}