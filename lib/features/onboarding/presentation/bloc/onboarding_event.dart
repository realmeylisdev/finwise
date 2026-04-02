part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class OnboardingNextStep extends OnboardingEvent {
  const OnboardingNextStep();
}

class OnboardingPrevStep extends OnboardingEvent {
  const OnboardingPrevStep();
}

class OnboardingCurrencySelected extends OnboardingEvent {
  const OnboardingCurrencySelected(this.currencyCode);
  final String currencyCode;
  @override
  List<Object?> get props => [currencyCode];
}

class OnboardingAccountSetup extends OnboardingEvent {
  const OnboardingAccountSetup({
    required this.name,
    required this.type,
    this.balance = 0,
  });
  final String name;
  final AccountType type;
  final double balance;
  @override
  List<Object?> get props => [name, type, balance];
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}
