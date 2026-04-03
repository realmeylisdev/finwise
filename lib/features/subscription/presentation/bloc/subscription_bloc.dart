import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/subscription/domain/entities/subscription_entity.dart';
import 'package:finwise/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:injectable/injectable.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({required SubscriptionRepository repository})
      : _repository = repository,
        super(const SubscriptionState()) {
    on<SubscriptionsLoaded>(_onLoaded, transformer: droppable());
    on<SubscriptionCreated>(_onCreated, transformer: droppable());
    on<SubscriptionUpdated>(_onUpdated, transformer: droppable());
    on<SubscriptionDeleted>(_onDeleted, transformer: droppable());
    on<SubscriptionToggled>(_onToggled, transformer: droppable());
  }

  final SubscriptionRepository _repository;

  Future<void> _onLoaded(
    SubscriptionsLoaded event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));

    final subsResult = await _repository.getSubscriptions();
    final monthlyCostResult = await _repository.getTotalMonthlyCost();

    if (subsResult.isLeft()) {
      emit(state.copyWith(
        status: SubscriptionStatus.failure,
        failureMessage: subsResult.getLeft().toNullable()?.message,
      ));
      return;
    }

    final subscriptions = subsResult.getOrElse((_) => []);
    final totalMonthlyCost = monthlyCostResult.getOrElse((_) => 0);
    final totalYearlyCost = totalMonthlyCost * 12;

    emit(state.copyWith(
      status: SubscriptionStatus.success,
      subscriptions: subscriptions,
      totalMonthlyCost: totalMonthlyCost,
      totalYearlyCost: totalYearlyCost,
    ));
  }

  Future<void> _onCreated(
    SubscriptionCreated event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _repository.createSubscription(event.subscription);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SubscriptionStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const SubscriptionsLoaded()),
    );
  }

  Future<void> _onUpdated(
    SubscriptionUpdated event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _repository.updateSubscription(event.subscription);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SubscriptionStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const SubscriptionsLoaded()),
    );
  }

  Future<void> _onDeleted(
    SubscriptionDeleted event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _repository.deleteSubscription(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SubscriptionStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const SubscriptionsLoaded()),
    );
  }

  Future<void> _onToggled(
    SubscriptionToggled event,
    Emitter<SubscriptionState> emit,
  ) async {
    final sub = state.subscriptions.firstWhere((s) => s.id == event.id);
    final toggled = sub.copyWith(
      isActive: !sub.isActive,
      updatedAt: DateTime.now(),
    );
    final result = await _repository.updateSubscription(toggled);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SubscriptionStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const SubscriptionsLoaded()),
    );
  }
}
