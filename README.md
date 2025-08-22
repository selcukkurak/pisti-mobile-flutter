# Pişti - Turkish Card Game

A modern Flutter implementation of the traditional Turkish card game "Pişti" with both offline and online gameplay modes.

## Features

### Game Modes
- **Offline Mode**: Play against an intelligent AI opponent
- **Online Mode**: Multiplayer with real-time gameplay (coming soon)

### Game Features
- Traditional Pişti rules with authentic gameplay
- Smart AI opponent with strategic decision making
- Smooth card animations and visual effects
- Sound effects for immersive gaming experience
- Real-time score tracking and statistics
- Turkish language support with English option

### Technical Features
- Clean architecture with BLoC pattern for state management
- Cross-platform support (Android & iOS)
- Dark/Light theme support
- Responsive design for different screen sizes
- Local data persistence
- Performance optimized animations

## Game Rules

Pişti is played with a standard 52-card deck between two players. The objective is to capture cards and score points.

### Scoring
- **Ace**: 1 point
- **Jack**: 1 point  
- **Two of Clubs**: 2 points
- **Ten of Diamonds**: 3 points
- **Pişti**: 10 points (capturing with same rank when only one card on table)
- **Majority**: 3 points (player with most captured cards)

### How to Play
1. Each player receives 4 cards, with 4 cards placed on the table
2. Players take turns playing cards from their hand
3. A card captures table cards if it matches the top card's rank or if it's a Jack
4. Pişti occurs when you capture a single card with the same rank (except Jack)
5. First player to reach 151 points wins

## Project Structure

```
lib/
├── core/
│   ├── constants/          # Game constants and messages
│   ├── services/           # Sound service and other utilities
│   └── theme/              # App themes and styling
├── features/
│   ├── game/
│   │   ├── domain/
│   │   │   └── models/     # Game entities (Card, Deck, Player, GameState)
│   │   └── presentation/
│   │       ├── bloc/       # Game state management
│   │       ├── pages/      # Game UI screens
│   │       └── widgets/    # Reusable game components
│   ├── menu/               # Main menu and navigation
│   ├── settings/           # App settings and preferences
│   └── statistics/         # Game statistics and history
└── main.dart               # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.0.0)
- Dart SDK (^2.17.0)
- Android Studio / VS Code
- Android/iOS development environment

### Installation
1. Clone the repository:
```bash
git clone https://github.com/selcukkurak/pisti-mobile-flutter.git
cd pisti-mobile-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `firebase_core`: Firebase integration
- `cloud_firestore`: Online data storage
- `firebase_auth`: User authentication
- `shared_preferences`: Local data storage
- `audioplayers`: Sound effects
- `flutter_localizations`: Internationalization

### Dev Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code analysis

## Testing

Run tests with:
```bash
flutter test
```

The project includes:
- Unit tests for game logic
- Widget tests for UI components
- Integration tests for complete workflows

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap

- [x] Core game implementation
- [x] Offline AI opponent
- [x] Settings and themes
- [x] Statistics tracking
- [ ] Online multiplayer
- [ ] User accounts and profiles
- [ ] Leaderboards
- [ ] Tournament mode
- [ ] Advanced AI difficulty levels
- [ ] Card customization themes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Traditional Turkish card game Pişti
- Flutter community for excellent documentation
- Contributors and testers

---

Made with ❤️ in Flutter