import 'package:audioplayers/audioplayers.dart';

abstract class AudioService {
  Future<void> playSound(String soundPath);
  Future<void> playMusic(String musicPath);
  Future<void> stopMusic();
  Future<void> pauseMusic();
  Future<void> resumeMusic();
  void setSoundEnabled(bool enabled);
  void setMusicEnabled(bool enabled);
  bool get isSoundEnabled;
  bool get isMusicEnabled;
}

class AudioServiceImpl implements AudioService {
  final AudioPlayer _soundPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  @override
  bool get isSoundEnabled => _soundEnabled;

  @override
  bool get isMusicEnabled => _musicEnabled;

  @override
  Future<void> playSound(String soundPath) async {
    if (_soundEnabled) {
      await _soundPlayer.play(AssetSource(soundPath));
    }
  }

  @override
  Future<void> playMusic(String musicPath) async {
    if (_musicEnabled) {
      await _musicPlayer.play(AssetSource(musicPath));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    }
  }

  @override
  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  @override
  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  @override
  Future<void> resumeMusic() async {
    await _musicPlayer.resume();
  }

  @override
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  @override
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopMusic();
    }
  }
}