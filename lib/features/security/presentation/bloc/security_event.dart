part of 'security_bloc.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object?> get props => [];
}

class SecurityCheckRequested extends SecurityEvent {
  const SecurityCheckRequested();
}

class SecurityPinSet extends SecurityEvent {
  const SecurityPinSet(this.pin);
  final String pin;
  @override
  List<Object?> get props => [pin];
}

class SecurityPinVerified extends SecurityEvent {
  const SecurityPinVerified(this.pin);
  final String pin;
  @override
  List<Object?> get props => [pin];
}

class SecurityBiometricRequested extends SecurityEvent {
  const SecurityBiometricRequested();
}

class SecurityDisabled extends SecurityEvent {
  const SecurityDisabled();
}

class SecurityUnlocked extends SecurityEvent {
  const SecurityUnlocked();
}
