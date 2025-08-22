import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

abstract class SettingsService {
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<ThemeMode> getThemeMode();
  Future<void> setSoundEnabled(bool enabled);
  Future<bool> isSoundEnabled();
  Future<void> setMusicEnabled(bool enabled);
  Future<bool> isMusicEnabled();
  Future<void> setPlayerName(String name);
  Future<String> getPlayerName();
}

class SettingsServiceImpl implements SettingsService {
  final SharedPreferences _prefs;

  SettingsServiceImpl(this._prefs);

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(AppConstants.keyThemeMode, themeMode.index);
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final index = _prefs.getInt(AppConstants.keyThemeMode) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  @override
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.keySoundEnabled, enabled);
  }

  @override
  Future<bool> isSoundEnabled() async {
    return _prefs.getBool(AppConstants.keySoundEnabled) ?? true;
  }

  @override
  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.keyMusicEnabled, enabled);
  }

  @override
  Future<bool> isMusicEnabled() async {
    return _prefs.getBool(AppConstants.keyMusicEnabled) ?? true;
  }

  @override
  Future<void> setPlayerName(String name) async {
    await _prefs.setString(AppConstants.keyPlayerName, name);
  }

  @override
  Future<String> getPlayerName() async {
    return _prefs.getString(AppConstants.keyPlayerName) ?? 'Player';
  }
}