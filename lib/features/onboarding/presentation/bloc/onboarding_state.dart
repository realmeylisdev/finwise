part of 'onboarding_bloc.dart';

enum OnboardingStep { welcome, currency, account, done }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentStep = OnboardingStep.welcome,
    this.selectedCurrency = 'USD',
    this.accountName,
    this.accountType,
    this.accountBalance = 0,
  });

  final OnboardingStep currentStep;
  final String selectedCurrency;
  final String? accountName;
  final AccountType? accountType;
  final double accountBalance;

  int get stepIndex => OnboardingStep.values.indexOf(currentStep);

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    String? selectedCurrency,
    String? accountName,
    AccountType? accountType,
    double? accountBalance,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      accountBalance: accountBalance ?? this.accountBalance,
    );
  }

  @override
  List<Object?> get props => [
        currentStep, selectedCurrency, accountName,
        accountType, accountBalance,
      ];
}
