part of 'security_bloc.dart';

enum SecurityStatus {
  initial,
  locked,
  unlocked,
  settingPin,
  pinSet,
  error,
}

class SecurityState extends Equatable {
  const SecurityState({
    this.status = SecurityStatus.initial,
    this.hasPinSet = false,
    this.biometricAvailable = false,
    this.errorMessage,
  });

  final SecurityStatus status;
  final bool hasPinSet;
  final bool biometricAvailable;
  final String? errorMessage;

  SecurityState copyWith({
    SecurityStatus? status,
    bool? hasPinSet,
    bool? biometricAvailable,
    String? errorMessage,
  }) {
    return SecurityState(
      status: status ?? this.status,
      hasPinSet: hasPinSet ?? this.hasPinSet,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, hasPinSet, biometricAvailable, errorMessage,
      ];
}
