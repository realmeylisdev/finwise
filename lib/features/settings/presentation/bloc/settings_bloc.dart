import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@singleton
class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsCurrencyChanged>(_onCurrencyChanged);
    on<SettingsOnboardingCompleted>(_onOnboardingCompleted);
    on<SettingsSecurityToggled>(_onSecurityToggled);
  }

  void _onThemeChanged(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onCurrencyChanged(
    SettingsCurrencyChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(defaultCurrencyCode: event.currencyCode));
  }

  void _onOnboardingCompleted(
    SettingsOnboardingCompleted event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isOnboardingComplete: true));
  }

  void _onSecurityToggled(
    SettingsSecurityToggled event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isSecurityEnabled: event.enabled));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
