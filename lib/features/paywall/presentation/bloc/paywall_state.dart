part of 'paywall_bloc.dart';

enum PaywallStatus { initial, loading, success, failure, purchased }

class PaywallState extends Equatable {
  const PaywallState({
    this.status = PaywallStatus.initial,
    this.currentTier = SubscriptionTier.free,
    this.selectedTier = SubscriptionTier.premium,
    this.isAnnual = true,
    this.failureMessage,
  });

  final PaywallStatus status;
  final SubscriptionTier currentTier;
  final SubscriptionTier selectedTier;
  final bool isAnnual;
  final String? failureMessage;

  PaywallState copyWith({
    PaywallStatus? status,
    SubscriptionTier? currentTier,
    SubscriptionTier? selectedTier,
    bool? isAnnual,
    String? failureMessage,
  }) {
    return PaywallState(
      status: status ?? this.status,
      currentTier: currentTier ?? this.currentTier,
      selectedTier: selectedTier ?? this.selectedTier,
      isAnnual: isAnnual ?? this.isAnnual,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentTier,
        selectedTier,
        isAnnual,
        failureMessage,
      ];
}
