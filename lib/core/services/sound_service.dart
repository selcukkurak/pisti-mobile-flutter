import 'package:audioplayers/audioplayers.dart';

enum SoundType {
  cardFlip,
  cardPlace,
  pisti,
  gameStart,
  gameEnd,
  capture,
}

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playSound(SoundType soundType) async {
    if (!_soundEnabled) return;

    try {
      String soundPath = _getSoundPath(soundType);
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      // Handle sound playback error silently
      print('Sound playback error: $e');
    }
  }

  String _getSoundPath(SoundType soundType) {
    switch (soundType) {
      case SoundType.cardFlip:
        return 'sounds/card_flip.mp3';
      case SoundType.cardPlace:
        return 'sounds/card_place.mp3';
      case SoundType.pisti:
        return 'sounds/pisti_sound.mp3';
      case SoundType.gameStart:
        return 'sounds/game_start.mp3';
      case SoundType.gameEnd:
        return 'sounds/game_end.mp3';
      case SoundType.capture:
        return 'sounds/capture.mp3';
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

// Extension for easy access
extension SoundServiceExtension on SoundType {
  void play() => SoundService().playSound(this);
}