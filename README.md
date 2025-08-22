# Pişti Mobile Flutter

A traditional Turkish card game implemented in Flutter with both offline and online multiplayer support.

## Features

### ✅ Implemented Features

- **Core Game Architecture**: Clean Architecture with BLoC pattern
- **Game Logic**: Complete Pişti game rules and scoring system
- **Card System**: 52-card deck with proper Turkish Pişti rules
- **UI Components**: Custom card widgets with animations
- **Game Modes**: 
  - Offline mode (vs AI)
  - Online mode (multiplayer) - framework ready
  - Private rooms - framework ready
- **Responsive Design**: Works on different screen sizes
- **Dark/Light Theme**: Automatic theme switching
- **Sound System**: Framework for sound effects and music
- **Settings**: User preferences storage
- **Navigation**: Complete app navigation system

### 🏗️ Architecture

```
lib/
├── core/                   # Core application components
│   ├── app/               # App setup and routing
│   ├── constants/         # App constants
│   ├── services/          # Dependency injection and services
│   └── utils/             # Utilities
├── features/              # Feature-based modules
│   ├── auth/              # Authentication
│   ├── game/              # Game logic and UI
│   ├── profile/           # User profiles
│   ├── settings/          # App settings
│   └── leaderboard/       # Leaderboard and statistics
└── shared/                # Shared UI components and themes
    ├── widgets/           # Reusable widgets
    └── themes/            # App theming
```

### 🎮 Game Rules (Traditional Pişti)

1. **Setup**: 2 players, 52-card deck
2. **Dealing**: Each player gets 4 cards, 1 card placed in middle
3. **Playing**: Players take turns playing one card
4. **Capturing**: 
   - Same rank captures all middle cards
   - Jack captures any card/pile
5. **Pişti**: Jack captures a single card (10 point bonus)
6. **Scoring**:
   - Jack: 1 point
   - Ace: 1 point  
   - Two of Clubs: 2 points
   - Ten of Diamonds: 3 points
   - Most cards: 3 points
   - Pişti: 10 points

### 📱 UI/UX Features

- **Splash Screen**: Animated app launch
- **Main Menu**: Clean navigation to all game modes
- **Game Board**: Realistic card game layout
- **Card Animations**: Smooth play and deal animations
- **Pişti Animation**: Special celebration for Pişti
- **Responsive Layout**: Adapts to different screen sizes
- **Accessibility**: Screen reader support

### 🛠️ Technical Stack

- **Flutter**: Cross-platform development
- **BLoC**: State management
- **GetIt**: Dependency injection
- **Firebase**: Backend services (auth, database)
- **SharedPreferences**: Local storage
- **AudioPlayers**: Sound effects and music

### 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.0.0          # State management
  firebase_core: ^2.0.0         # Firebase core
  cloud_firestore: ^3.0.0       # Cloud database
  firebase_auth: ^4.0.0         # Authentication
  shared_preferences: ^3.0.0    # Local storage
  audioplayers: ^1.0.0          # Audio playback
  get_it: ^7.6.0                # Dependency injection
  equatable: ^2.0.5             # Value equality
  dartz: ^0.10.1                # Functional programming
```

### 🚀 Getting Started

1. **Prerequisites**:
   - Flutter SDK 3.16+ 
   - Dart 3.0+
   - Firebase project setup

2. **Installation**:
   ```bash
   git clone https://github.com/selcukkurak/pisti-mobile-flutter.git
   cd pisti-mobile-flutter
   flutter pub get
   ```

3. **Firebase Setup**:
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)
   - Configure Firebase console

4. **Run**:
   ```bash
   flutter run
   ```

### 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

### 📂 Project Structure Details

#### Core Modules

- **App**: Main application setup with theming and routing
- **Constants**: Game rules, asset paths, configuration
- **Services**: Audio, settings, dependency injection
- **Utils**: Helper functions and extensions

#### Game Feature

- **Domain**: Game entities (Card, Player, Game), use cases, repositories
- **Data**: Local/remote data sources, repository implementations  
- **Presentation**: UI pages, widgets, BLoC state management

#### Shared Components

- **CardWidget**: Animated playing card component
- **Themes**: Light/dark theme configurations
- **Extensions**: Useful Dart extensions

### 🎯 Game Implementation Highlights

#### Pişti Game Engine

```dart
class PistiGameEngine {
  static Game createGame(String gameId, GameMode mode, List<Player> players);
  static Game playCard(Game game, String cardId, int playerIndex);
  static Game calculateFinalScores(Game game);
}
```

#### Card System

```dart
class PlayingCard {
  final Suit suit;         // hearts, diamonds, clubs, spades
  final Rank rank;         // ace through king
  int get points;          // Pişti point values
  bool get isJack;         // Special capture card
  String get displayName;  // UI display format
}
```

#### Game State Management

```dart
abstract class GameState extends Equatable {
  const GameState();
}

class GameInProgress extends GameState {
  final Game game;
  final String? selectedCardId;
  final bool showPistiAnimation;
}
```

### 🔮 Future Enhancements

- **Online Multiplayer**: Real-time Firebase integration
- **AI Improvements**: Advanced AI strategies
- **Tournaments**: Competitive play modes
- **Statistics**: Detailed player analytics
- **Achievements**: Badge and reward system
- **Social Features**: Friend systems, chat
- **Customization**: Card backs, themes, avatars
- **Localization**: Multi-language support

### 📱 Store Deployment

The app is structured for easy deployment to:
- **Google Play Store** (Android)
- **Apple App Store** (iOS)

Required assets and configurations are included for both platforms.

### 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### 📄 License

This project is licensed under the MIT License.

### 📧 Contact

- Developer: Selçuk Kurak
- Email: [Your Email]
- GitHub: [@selcukkurak](https://github.com/selcukkurak)

---

*A traditional card game brought to modern mobile platforms with love for Turkish gaming culture.* 🎴