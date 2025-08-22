// Placeholder - Game repository interface
abstract class GameRepository {
  Future<void> createGame(Map<String, dynamic> gameData);
  Future<void> joinGame(String gameId, String playerId);
  Future<void> playCard(String gameId, String cardId);
}