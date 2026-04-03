part of 'category_rule_bloc.dart';

abstract class CategoryRuleEvent extends Equatable {
  const CategoryRuleEvent();
  @override
  List<Object?> get props => [];
}

class RulesLoaded extends CategoryRuleEvent {
  const RulesLoaded();
}

class RuleCreated extends CategoryRuleEvent {
  const RuleCreated(this.rule);
  final CategoryRuleEntity rule;
  @override
  List<Object?> get props => [rule];
}

class RuleDeleted extends CategoryRuleEvent {
  const RuleDeleted(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}
