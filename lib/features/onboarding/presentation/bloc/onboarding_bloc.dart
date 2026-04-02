import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/account/domain/repositories/account_repository.dart';
import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required AccountRepository accountRepository,
    required SettingsBloc settingsBloc,
  })  : _accountRepo = accountRepository,
        _settingsBloc = settingsBloc,
        super(const OnboardingState()) {
    on<OnboardingNextStep>(_onNext);
    on<OnboardingPrevStep>(_onPrev);
    on<OnboardingCurrencySelected>(_onCurrency);
    on<OnboardingAccountSetup>(_onAccount);
    on<OnboardingCompleted>(_onCompleted);
  }

  final AccountRepository _accountRepo;
  final SettingsBloc _settingsBloc;

  void _onNext(OnboardingNextStep event, Emitter<OnboardingState> emit) {
    final steps = OnboardingStep.values;
    final nextIndex = state.stepIndex + 1;
    if (nextIndex < steps.length) {
      emit(state.copyWith(currentStep: steps[nextIndex]));
    }
  }

  void _onPrev(OnboardingPrevStep event, Emitter<OnboardingState> emit) {
    final steps = OnboardingStep.values;
    final prevIndex = state.stepIndex - 1;
    if (prevIndex >= 0) {
      emit(state.copyWith(currentStep: steps[prevIndex]));
    }
  }

  void _onCurrency(
    OnboardingCurrencySelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(selectedCurrency: event.currencyCode));
  }

  void _onAccount(
    OnboardingAccountSetup event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(
      accountName: event.name,
      accountType: event.type,
      accountBalance: event.balance,
    ));
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    // Create initial account if set
    if (state.accountName != null && state.accountType != null) {
      final now = DateTime.now();
      final account = AccountEntity(
        id: const Uuid().v4(),
        name: state.accountName!,
        type: state.accountType!,
        balance: state.accountBalance,
        currencyCode: state.selectedCurrency,
        createdAt: now,
        updatedAt: now,
      );
      await _accountRepo.createAccount(account);
    }

    // Update settings
    _settingsBloc
      ..add(SettingsCurrencyChanged(state.selectedCurrency))
      ..add(const SettingsOnboardingCompleted());

    emit(state.copyWith(currentStep: OnboardingStep.done));
  }
}
