part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.defaultCurrencyCode = 'USD',
    this.isOnboardingComplete = false,
    this.isSecurityEnabled = false,
  });

  final ThemeMode themeMode;
  final String defaultCurrencyCode;
  final bool isOnboardingComplete;
  final bool isSecurityEnabled;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? defaultCurrencyCode,
    bool? isOnboardingComplete,
    bool? isSecurityEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      defaultCurrencyCode: defaultCurrencyCode ?? this.defaultCurrencyCode,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isSecurityEnabled: isSecurityEnabled ?? this.isSecurityEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'defaultCurrencyCode': defaultCurrencyCode,
        'isOnboardingComplete': isOnboardingComplete,
        'isSecurityEnabled': isSecurityEnabled,
      };

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      defaultCurrencyCode:
          json['defaultCurrencyCode'] as String? ?? 'USD',
      isOnboardingComplete:
          json['isOnboardingComplete'] as bool? ?? false,
      isSecurityEnabled: json['isSecurityEnabled'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        defaultCurrencyCode,
        isOnboardingComplete,
        isSecurityEnabled,
      ];
}
