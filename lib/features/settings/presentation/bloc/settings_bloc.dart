import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/persistence_service.dart';

// Events
abstract class SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {}

class ChangeLocaleEvent extends SettingsEvent {
  final Locale locale;
  
  ChangeLocaleEvent(this.locale);
}

class ChangeSoundEvent extends SettingsEvent {
  final bool soundEnabled;
  
  ChangeSoundEvent(this.soundEnabled);
}

// State
class SettingsState {
  final bool isDarkMode;
  final Locale locale;
  final bool soundEnabled;

  const SettingsState({
    this.isDarkMode = false,
    this.locale = const Locale('tr', 'TR'),
    this.soundEnabled = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    Locale? locale,
    bool? soundEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final PersistenceService _persistenceService = PersistenceService();

  SettingsBloc() : super(SettingsState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<ChangeSoundEvent>(_onChangeSound);
    
    // Load initial settings
    _loadSettings();
  }

  void _loadSettings() {
    final isDarkMode = _persistenceService.getDarkMode();
    final soundEnabled = _persistenceService.getSoundEnabled();
    final localeString = _persistenceService.getLocale();
    
    final localeParts = localeString.split('_');
    final locale = Locale(localeParts[0], localeParts.length > 1 ? localeParts[1] : '');
    
    emit(state.copyWith(
      isDarkMode: isDarkMode,
      soundEnabled: soundEnabled,
      locale: locale,
    ));
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<SettingsState> emit) async {
    final newDarkMode = !state.isDarkMode;
    await _persistenceService.setDarkMode(newDarkMode);
    emit(state.copyWith(isDarkMode: newDarkMode));
  }

  void _onChangeLocale(ChangeLocaleEvent event, Emitter<SettingsState> emit) async {
    await _persistenceService.setLocale('${event.locale.languageCode}_${event.locale.countryCode}');
    emit(state.copyWith(locale: event.locale));
  }

  void _onChangeSound(ChangeSoundEvent event, Emitter<SettingsState> emit) async {
    await _persistenceService.setSoundEnabled(event.soundEnabled);
    SoundService().setSoundEnabled(event.soundEnabled);
    emit(state.copyWith(soundEnabled: event.soundEnabled));
  }
}