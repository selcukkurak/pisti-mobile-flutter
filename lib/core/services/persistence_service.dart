import 'package:shared_preferences/shared_preferences.dart';
import '../constants/game_constants.dart';

class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();
  factory PersistenceService() => _instance;
  PersistenceService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Settings
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(GameConstants.settingsSoundEnabled, enabled);
  }

  bool getSoundEnabled() {
    return _prefs?.getBool(GameConstants.settingsSoundEnabled) ?? true;
  }

  Future<void> setDarkMode(bool enabled) async {
    await _prefs?.setBool(GameConstants.settingsDarkMode, enabled);
  }

  bool getDarkMode() {
    return _prefs?.getBool(GameConstants.settingsDarkMode) ?? false;
  }

  Future<void> setLocale(String locale) async {
    await _prefs?.setString(GameConstants.settingsLocale, locale);
  }

  String getLocale() {
    return _prefs?.getString(GameConstants.settingsLocale) ?? 'tr_TR';
  }

  // Statistics
  Future<void> incrementGamesPlayed() async {
    final current = getGamesPlayed();
    await _prefs?.setInt(GameConstants.statsGamesPlayed, current + 1);
  }

  int getGamesPlayed() {
    return _prefs?.getInt(GameConstants.statsGamesPlayed) ?? 0;
  }

  Future<void> incrementGamesWon() async {
    final current = getGamesWon();
    await _prefs?.setInt(GameConstants.statsGamesWon, current + 1);
  }

  int getGamesWon() {
    return _prefs?.getInt(GameConstants.statsGamesWon) ?? 0;
  }

  Future<void> updateHighScore(int score) async {
    final current = getHighScore();
    if (score > current) {
      await _prefs?.setInt(GameConstants.statsHighScore, score);
    }
  }

  int getHighScore() {
    return _prefs?.getInt(GameConstants.statsHighScore) ?? 0;
  }

  Future<void> addPistiCount(int count) async {
    final current = getTotalPisti();
    await _prefs?.setInt(GameConstants.statsTotalPisti, current + count);
  }

  int getTotalPisti() {
    return _prefs?.getInt(GameConstants.statsTotalPisti) ?? 0;
  }

  Future<void> updateMaxPistiInGame(int count) async {
    final current = getMaxPistiInGame();
    if (count > current) {
      await _prefs?.setInt(GameConstants.statsMaxPistiInGame, count);
    }
  }

  int getMaxPistiInGame() {
    return _prefs?.getInt(GameConstants.statsMaxPistiInGame) ?? 0;
  }

  // Calculate win rate
  double getWinRate() {
    final played = getGamesPlayed();
    final won = getGamesWon();
    if (played == 0) return 0.0;
    return (won / played) * 100;
  }

  // Calculate average Pişti per game
  double getAveragePistiPerGame() {
    final played = getGamesPlayed();
    final totalPisti = getTotalPisti();
    if (played == 0) return 0.0;
    return totalPisti / played;
  }

  // Reset all statistics
  Future<void> resetStatistics() async {
    await _prefs?.remove(GameConstants.statsGamesPlayed);
    await _prefs?.remove(GameConstants.statsGamesWon);
    await _prefs?.remove(GameConstants.statsHighScore);
    await _prefs?.remove(GameConstants.statsTotalPisti);
    await _prefs?.remove(GameConstants.statsMaxPistiInGame);
  }
}