part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsThemeChanged extends SettingsEvent {
  const SettingsThemeChanged(this.themeMode);
  final ThemeMode themeMode;
  @override
  List<Object?> get props => [themeMode];
}

class SettingsCurrencyChanged extends SettingsEvent {
  const SettingsCurrencyChanged(this.currencyCode);
  final String currencyCode;
  @override
  List<Object?> get props => [currencyCode];
}

class SettingsOnboardingCompleted extends SettingsEvent {
  const SettingsOnboardingCompleted();
}

class SettingsSecurityToggled extends SettingsEvent {
  const SettingsSecurityToggled({required this.enabled});
  final bool enabled;
  @override
  List<Object?> get props => [enabled];
}

class SettingsPrivacyToggled extends SettingsEvent {
  const SettingsPrivacyToggled();
}

class SettingsChecklistDismissed extends SettingsEvent {
  const SettingsChecklistDismissed();
}
