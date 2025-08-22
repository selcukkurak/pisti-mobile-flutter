import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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
  SettingsBloc() : super(SettingsState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<ChangeSoundEvent>(_onChangeSound);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void _onChangeLocale(ChangeLocaleEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(locale: event.locale));
  }

  void _onChangeSound(ChangeSoundEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(soundEnabled: event.soundEnabled));
  }
}