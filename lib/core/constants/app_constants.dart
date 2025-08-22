class AppConstants {
  // App Info
  static const String appName = 'Pişti';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Traditional Turkish Card Game';

  // Game Constants
  static const int totalCards = 52;
  static const int cardsPerPlayer = 4;
  static const int maxPlayers = 2;
  static const int pistiBonus = 10;
  static const int jackBonus = 1;
  static const int twoOfClubsBonus = 2;
  static const int tenOfDiamondsBonus = 3;
  static const int aceBonus = 1;

  // Animation Durations
  static const int cardDealAnimationDuration = 300;
  static const int cardPlayAnimationDuration = 500;
  static const int pistiAnimationDuration = 2000;
  static const int uiTransitionDuration = 250;

  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keyPlayerName = 'player_name';
  static const String keyGamesPlayed = 'games_played';
  static const String keyGamesWon = 'games_won';
  static const String keyBestScore = 'best_score';
  static const String keyPistiCount = 'pisti_count';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String gamesCollection = 'games';
  static const String leaderboardCollection = 'leaderboard';
  static const String roomsCollection = 'rooms';

  // Game Modes
  static const String offlineMode = 'offline';
  static const String onlineMode = 'online';
  static const String privateRoomMode = 'private_room';

  // Card Suits
  static const List<String> suits = ['hearts', 'diamonds', 'clubs', 'spades'];
  static const List<String> ranks = [
    'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'
  ];

  // Audio Files
  static const String cardDealSound = 'assets/sounds/effects/card_deal.mp3';
  static const String cardPlaySound = 'assets/sounds/effects/card_play.mp3';
  static const String pistiSound = 'assets/sounds/effects/pisti.mp3';
  static const String winSound = 'assets/sounds/effects/win.mp3';
  static const String loseSound = 'assets/sounds/effects/lose.mp3';
  static const String backgroundMusic = 'assets/sounds/music/background.mp3';

  // Image Assets
  static const String cardBack = 'assets/images/cards/card_back.png';
  static const String appIcon = 'assets/images/icons/app_icon.png';
  static const String backgroundImage = 'assets/images/backgrounds/game_bg.png';
}