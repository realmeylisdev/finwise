import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:finwise/features/category_rule/domain/entities/category_rule_entity.dart';
import 'package:finwise/features/category_rule/domain/repositories/category_rule_repository.dart';
import 'package:injectable/injectable.dart';

part 'category_rule_event.dart';
part 'category_rule_state.dart';

@injectable
class CategoryRuleBloc extends Bloc<CategoryRuleEvent, CategoryRuleState> {
  CategoryRuleBloc({
    required CategoryRuleRepository repository,
  })  : _repository = repository,
        super(const CategoryRuleState()) {
    on<RulesLoaded>(_onLoaded, transformer: droppable());
    on<RuleCreated>(_onCreated, transformer: droppable());
    on<RuleDeleted>(_onDeleted, transformer: droppable());
  }

  final CategoryRuleRepository _repository;

  Future<void> _onLoaded(
    RulesLoaded event,
    Emitter<CategoryRuleState> emit,
  ) async {
    emit(state.copyWith(status: CategoryRuleStatus.loading));
    final result = await _repository.getRules();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryRuleStatus.failure,
        failureMessage: failure.message,
      )),
      (rules) => emit(state.copyWith(
        status: CategoryRuleStatus.success,
        rules: rules,
      )),
    );
  }

  Future<void> _onCreated(
    RuleCreated event,
    Emitter<CategoryRuleState> emit,
  ) async {
    final result = await _repository.createRule(event.rule);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryRuleStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const RulesLoaded()),
    );
  }

  Future<void> _onDeleted(
    RuleDeleted event,
    Emitter<CategoryRuleState> emit,
  ) async {
    final result = await _repository.deleteRule(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryRuleStatus.failure,
        failureMessage: failure.message,
      )),
      (_) => add(const RulesLoaded()),
    );
  }
}
