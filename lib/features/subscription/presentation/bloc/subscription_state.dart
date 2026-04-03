part of 'subscription_bloc.dart';

enum SubscriptionStatus { initial, loading, success, failure }

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptions = const [],
    this.totalMonthlyCost = 0,
    this.totalYearlyCost = 0,
    this.failureMessage,
  });

  final SubscriptionStatus status;
  final List<SubscriptionEntity> subscriptions;
  final double totalMonthlyCost;
  final double totalYearlyCost;
  final String? failureMessage;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionEntity>? subscriptions,
    double? totalMonthlyCost,
    double? totalYearlyCost,
    String? failureMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      totalMonthlyCost: totalMonthlyCost ?? this.totalMonthlyCost,
      totalYearlyCost: totalYearlyCost ?? this.totalYearlyCost,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, subscriptions, totalMonthlyCost,
        totalYearlyCost, failureMessage,
      ];
}
