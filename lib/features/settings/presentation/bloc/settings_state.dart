part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.defaultCurrencyCode = 'USD',
    this.isOnboardingComplete = false,
    this.isSecurityEnabled = false,
    this.isPrivacyModeEnabled = false,
  });

  final ThemeMode themeMode;
  final String defaultCurrencyCode;
  final bool isOnboardingComplete;
  final bool isSecurityEnabled;
  final bool isPrivacyModeEnabled;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? defaultCurrencyCode,
    bool? isOnboardingComplete,
    bool? isSecurityEnabled,
    bool? isPrivacyModeEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isSecurityEnabled: isSecurityEnabled ?? this.isSecurityEnabled,
      isPrivacyModeEnabled: isPrivacyModeEnabled ?? this.isPrivacyModeEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'defaultCurrencyCode': defaultCurrencyCode,
        'isOnboardingComplete': isOnboardingComplete,
        'isSecurityEnabled': isSecurityEnabled,
        'isPrivacyModeEnabled': isPrivacyModeEnabled,
      };

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      defaultCurrencyCode:
          json['defaultCurrencyCode'] as String? ?? 'USD',
      isOnboardingComplete:
          json['isOnboardingComplete'] as bool? ?? false,
      isSecurityEnabled: json['isSecurityEnabled'] as bool? ?? false,
      isPrivacyModeEnabled:
          json['isPrivacyModeEnabled'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        defaultCurrencyCode,
        isOnboardingComplete,
        isSecurityEnabled,
        isPrivacyModeEnabled,
      ];
}
