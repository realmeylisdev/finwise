import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/features/category_rule/domain/entities/category_rule_entity.dart';
import 'package:finwise/features/category_rule/presentation/bloc/category_rule_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class CategoryRulesPage extends StatelessWidget {
  const CategoryRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Rules')),
      body: BlocBuilder<CategoryRuleBloc, CategoryRuleState>(
        builder: (context, state) {
          if (state.status == CategoryRuleStatus.loading) {
            return const SkeletonListTileGroup(count: 3);
          }
          if (state.rules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    size: 64.w,
                    color: AppColors.disabled,
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No category rules',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  const Text('Add rules to auto-categorize transactions'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            itemCount: state.rules.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingS),
            itemBuilder: (context, index) {
              final rule = state.rules[index];
              return _RuleCard(rule: rule);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_category_rules',
        onPressed: () => _showAddRuleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRuleDialog(BuildContext context) {
    final keywordController = TextEditingController();
    String? selectedCategoryId;

    final categoryState = context.read<CategoryBloc>().state;
    final allCategories = categoryState.allCategories;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('New Category Rule'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: keywordController,
                    decoration: const InputDecoration(
                      labelText: 'Keyword',
                      hintText: 'e.g. Netflix, Uber, Starbucks',
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingM),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'Select a category',
                    ),
                    isExpanded: true,
                    items: allCategories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Row(
                              children: [
                                CategoryIconWidget(
                                  iconName: c.icon,
                                  color: c.color,
                                  size: 24,
                                ),
                                SizedBox(width: AppDimensions.paddingS),
                                Flexible(child: Text(c.name)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => selectedCategoryId = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final keyword = keywordController.text.trim();
                    if (keyword.isEmpty || selectedCategoryId == null) {
                      return;
                    }

                    final category = allCategories.firstWhere(
                      (c) => c.id == selectedCategoryId,
                    );
                    final now = DateTime.now();

                    final rule = CategoryRuleEntity(
                      id: const Uuid().v4(),
                      keyword: keyword,
                      categoryId: category.id,
                      categoryName: category.name,
                      categoryIcon: category.icon,
                      categoryColor: category.color,
                      createdAt: now,
                      updatedAt: now,
                    );

                    context
                        .read<CategoryRuleBloc>()
                        .add(RuleCreated(rule));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule});

  final CategoryRuleEntity rule;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(rule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppDimensions.paddingM),
        color: AppColors.expense,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          context.read<CategoryRuleBloc>().add(RuleDeleted(rule.id)),
      child: Card(
        child: ListTile(
          leading: CategoryIconWidget(
            iconName: rule.categoryIcon,
            color: rule.categoryColor,
          ),
          title: Text(
            rule.keyword,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Text(rule.categoryName),
          trailing: Icon(
            Icons.arrow_forward,
            size: 16.w,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
