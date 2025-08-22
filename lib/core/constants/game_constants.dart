class GameConstants {
  // Game Rules
  static const int cardsPerHand = 4;
  static const int cardsOnTableAtStart = 4;
  static const int winningScore = 151;
  static const int pistiBonus = 10;
  static const int majorityBonus = 3;
  
  // Card Values (points)
  static const int acePoints = 1;
  static const int jackPoints = 1;
  static const int twoOfClubsPoints = 2;
  static const int tenOfDiamondsPoints = 3;
  
  // Animation Durations (milliseconds)
  static const int cardAnimationDuration = 300;
  static const int cardFlipDuration = 200;
  static const int pistiEffectDuration = 1000;
  static const int aiThinkingTime = 1500;
  
  // UI Constants
  static const double cardWidth = 80;
  static const double cardHeight = 120;
  static const double gameTableCardWidth = 100;
  static const double gameTableCardHeight = 140;
  
  // Sound file names
  static const String cardFlipSound = 'card_flip.mp3';
  static const String cardPlaceSound = 'card_place.mp3';
  static const String pistiSound = 'pisti_sound.mp3';
  static const String gameStartSound = 'game_start.mp3';
  static const String gameEndSound = 'game_end.mp3';
  static const String captureSound = 'capture.mp3';
  
  // Game text
  static const String appName = 'Pişti';
  static const String appDescription = 'Geleneksel Türk Kart Oyunu';
  
  // Player names
  static const String defaultPlayerName = 'Oyuncu';
  static const String aiPlayerName = 'Bilgisayar';
  
  // Settings keys for SharedPreferences
  static const String settingsSoundEnabled = 'soundEnabled';
  static const String settingsDarkMode = 'darkMode';
  static const String settingsLocale = 'locale';
  
  // Statistics keys
  static const String statsGamesPlayed = 'gamesPlayed';
  static const String statsGamesWon = 'gamesWon';
  static const String statsHighScore = 'highScore';
  static const String statsTotalPisti = 'totalPisti';
  static const String statsMaxPistiInGame = 'maxPistiInGame';
}

class GameMessages {
  // Turkish messages
  static const String pistiMessage = 'Pişti! 🎉';
  static const String gameOverMessage = 'Oyun Bitti';
  static const String youWin = 'Kazandınız!';
  static const String youLose = 'Kaybettiniz!';
  static const String newGame = 'Yeni Oyun';
  static const String mainMenu = 'Ana Menü';
  static const String resetGame = 'Oyunu Yeniden Başlat';
  static const String confirmReset = 'Bu oyunu bitirip yeni bir oyun başlatmak istediğinize emin misiniz?';
  static const String cancel = 'İptal';
  static const String confirm = 'Onayla';
  static const String emptyTable = 'Masa Boş';
  static const String yourTurn = 'Sıra Sizde';
  static const String opponentTurn = 'Rakip Oynuyor';
}