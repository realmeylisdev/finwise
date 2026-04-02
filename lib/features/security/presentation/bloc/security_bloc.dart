import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

part 'security_event.dart';
part 'security_state.dart';

const _pinKey = 'finwise_pin';

@injectable
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc()
      : _storage = const FlutterSecureStorage(),
        _localAuth = LocalAuthentication(),
        super(const SecurityState()) {
    on<SecurityCheckRequested>(_onCheck);
    on<SecurityPinSet>(_onPinSet);
    on<SecurityPinVerified>(_onPinVerified);
    on<SecurityBiometricRequested>(_onBiometric);
    on<SecurityDisabled>(_onDisabled);
    on<SecurityUnlocked>(_onUnlocked);
  }

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  Future<void> _onCheck(
    SecurityCheckRequested event,
    Emitter<SecurityState> emit,
  ) async {
    final pin = await _storage.read(key: _pinKey);
    final hasBiometric = await _localAuth.canCheckBiometrics;

    if (pin != null && pin.isNotEmpty) {
      emit(state.copyWith(
        status: SecurityStatus.locked,
        hasPinSet: true,
        biometricAvailable: hasBiometric,
      ));
    } else {
      emit(state.copyWith(
        status: SecurityStatus.unlocked,
        hasPinSet: false,
        biometricAvailable: hasBiometric,
      ));
    }
  }

  Future<void> _onPinSet(
    SecurityPinSet event,
    Emitter<SecurityState> emit,
  ) async {
    await _storage.write(key: _pinKey, value: event.pin);
    emit(state.copyWith(
      status: SecurityStatus.pinSet,
      hasPinSet: true,
    ));
  }

  Future<void> _onPinVerified(
    SecurityPinVerified event,
    Emitter<SecurityState> emit,
  ) async {
    final storedPin = await _storage.read(key: _pinKey);
    if (storedPin == event.pin) {
      emit(state.copyWith(status: SecurityStatus.unlocked));
    } else {
      emit(state.copyWith(
        status: SecurityStatus.error,
        errorMessage: 'Incorrect PIN',
      ));
      // Reset back to locked
      emit(state.copyWith(status: SecurityStatus.locked));
    }
  }

  Future<void> _onBiometric(
    SecurityBiometricRequested event,
    Emitter<SecurityState> emit,
  ) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock FinWise',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (authenticated) {
        emit(state.copyWith(status: SecurityStatus.unlocked));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SecurityStatus.error,
        errorMessage: 'Biometric authentication failed',
      ));
      emit(state.copyWith(status: SecurityStatus.locked));
    }
  }

  Future<void> _onDisabled(
    SecurityDisabled event,
    Emitter<SecurityState> emit,
  ) async {
    await _storage.delete(key: _pinKey);
    emit(state.copyWith(
      status: SecurityStatus.unlocked,
      hasPinSet: false,
    ));
  }

  void _onUnlocked(
    SecurityUnlocked event,
    Emitter<SecurityState> emit,
  ) {
    emit(state.copyWith(status: SecurityStatus.unlocked));
  }
}
