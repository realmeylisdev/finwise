import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/core/services/subscription_service.dart';
import 'package:injectable/injectable.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

@injectable
class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  PaywallBloc({
    required SubscriptionService subscriptionService,
  })  : _subscriptionService = subscriptionService,
        super(const PaywallState()) {
    on<PaywallLoaded>(_onLoaded, transformer: droppable());
    on<PaywallTierSelected>(_onTierSelected);
    on<PaywallPurchaseRequested>(_onPurchaseRequested, transformer: droppable());
    on<PaywallRestoreRequested>(_onRestoreRequested, transformer: droppable());
    on<PaywallBillingCycleToggled>(_onBillingCycleToggled);
  }

  final SubscriptionService _subscriptionService;

  void _onLoaded(
    PaywallLoaded event,
    Emitter<PaywallState> emit,
  ) {
    emit(state.copyWith(
      status: PaywallStatus.success,
      currentTier: _subscriptionService.currentTier,
      selectedTier: _subscriptionService.isPro
          ? SubscriptionTier.pro
          : SubscriptionTier.premium,
    ));
  }

  void _onTierSelected(
    PaywallTierSelected event,
    Emitter<PaywallState> emit,
  ) {
    emit(state.copyWith(selectedTier: event.tier));
  }

  Future<void> _onPurchaseRequested(
    PaywallPurchaseRequested event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(status: PaywallStatus.loading));

    // Mock purchase -- will be replaced with real store logic
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _subscriptionService.upgradeTo(state.selectedTier);

    emit(state.copyWith(
      status: PaywallStatus.purchased,
      currentTier: state.selectedTier,
    ));
  }

  Future<void> _onRestoreRequested(
    PaywallRestoreRequested event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(status: PaywallStatus.loading));

    // Mock restore -- will be replaced with real store logic
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _subscriptionService.restorePurchases();

    emit(state.copyWith(
      status: PaywallStatus.success,
      currentTier: _subscriptionService.currentTier,
    ));
  }

  void _onBillingCycleToggled(
    PaywallBillingCycleToggled event,
    Emitter<PaywallState> emit,
  ) {
    emit(state.copyWith(isAnnual: !state.isAnnual));
  }
}
