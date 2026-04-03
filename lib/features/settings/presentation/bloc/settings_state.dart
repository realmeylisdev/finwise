part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.defaultCurrencyCode = 'USD',
    this.isOnboardingComplete = false,
    this.isSecurityEnabled = false,
    this.isPrivacyModeEnabled = false,
    this.isChecklistDismissed = false,
  });

  final ThemeMode themeMode;
  final String defaultCurrencyCode;
  final bool isOnboardingComplete;
  final bool isSecurityEnabled;
  final bool isPrivacyModeEnabled;
  final bool isChecklistDismissed;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? defaultCurrencyCode,
    bool? isOnboardingComplete,
    bool? isSecurityEnabled,
    bool? isPrivacyModeEnabled,
    bool? isChecklistDismissed,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isSecurityEnabled: isSecurityEnabled ?? this.isSecurityEnabled,
      isPrivacyModeEnabled: isPrivacyModeEnabled ?? this.isPrivacyModeEnabled,
      isChecklistDismissed: isChecklistDismissed ?? this.isChecklistDismissed,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'defaultCurrencyCode': defaultCurrencyCode,
        'isOnboardingComplete': isOnboardingComplete,
        'isSecurityEnabled': isSecurityEnabled,
        'isPrivacyModeEnabled': isPrivacyModeEnabled,
        'isChecklistDismissed': isChecklistDismissed,
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
      isChecklistDismissed:
          json['isChecklistDismissed'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        defaultCurrencyCode,
        isOnboardingComplete,
        isSecurityEnabled,
        isPrivacyModeEnabled,
        isChecklistDismissed,
      ];
}
