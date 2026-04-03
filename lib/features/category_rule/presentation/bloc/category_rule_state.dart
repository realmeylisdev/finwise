part of 'category_rule_bloc.dart';

enum CategoryRuleStatus { initial, loading, success, failure }

class CategoryRuleState extends Equatable {
  const CategoryRuleState({
    this.status = CategoryRuleStatus.initial,
    this.rules = const [],
    this.failureMessage,
  });

  final CategoryRuleStatus status;
  final List<CategoryRuleEntity> rules;
  final String? failureMessage;

  CategoryRuleState copyWith({
    CategoryRuleStatus? status,
    List<CategoryRuleEntity>? rules,
    String? failureMessage,
  }) {
    return CategoryRuleState(
      status: status ?? this.status,
      rules: rules ?? this.rules,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [status, rules, failureMessage];
}
