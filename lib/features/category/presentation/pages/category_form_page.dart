import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/category/domain/entities/category_entity.dart';
import 'package:finwise/features/category/presentation/bloc/category_bloc.dart';
import 'package:finwise/features/category/presentation/widgets/category_icon_widget.dart';
import 'package:finwise/shared/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:finwise/shared/widgets/app_icon.dart';
import 'package:uuid/uuid.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({this.category, super.key});

  final CategoryEntity? category;

  bool get isEditing => category != null;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late CategoryType _type;
  late String _selectedIcon;
  late int _selectedColor;

  static const _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.category?.name ?? '');
    _type = widget.category?.type ?? CategoryType.expense;
    _selectedIcon = widget.category?.icon ?? 'category';
    _selectedColor =
        widget.category?.color ?? Colors.blue.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final category = CategoryEntity(
      id: widget.category?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      icon: _selectedIcon,
      color: _selectedColor,
      isDefault: false,
      sortOrder: widget.category?.sortOrder ?? 99,
      createdAt: widget.category?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.isEditing) {
      context.read<CategoryBloc>().add(CategoryUpdated(category));
    } else {
      context.read<CategoryBloc>().add(CategoryCreated(category));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Category' : 'New Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Type selector
            PillTabBar(
              selectedIndex:
                  _type == CategoryType.expense ? 0 : 1,
              onChanged: (i) => setState(
                () => _type = i == 0
                    ? CategoryType.expense
                    : CategoryType.income,
              ),
              tabs: [
                PillTab(
                  label: 'Expense',
                  icon: HugeIcons.strokeRoundedArrowUp01,
                  activeColor: AppColors.expense,
                ),
                PillTab(
                  label: 'Income',
                  icon: HugeIcons.strokeRoundedArrowDown01,
                  activeColor: AppColors.income,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g. Groceries',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 2) return 'Name is too short';
                return null;
              },
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Icon preview
            Center(
              child: CategoryIconWidget(
                iconName: _selectedIcon,
                color: _selectedColor,
                size: 64,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Icon picker
            Text(
              'Icon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: CategoryIconWidget.categoryIcons.entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () =>
                          setState(() => _selectedIcon = entry.key),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: _selectedIcon == entry.key
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : null,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                          border: _selectedIcon == entry.key
                              ? Border.all(color: AppColors.primary)
                              : null,
                        ),
                        child: Icon(
                          entry.value,
                          color: _selectedIcon == entry.key
                              ? AppColors.primary
                              : AppColors.disabled,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Color picker
            Text(
              'Color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: _availableColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () =>
                          setState(() => _selectedColor = color.value),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: _selectedColor == color.value
                              ? Border.all(
                                  color: Colors.white,
                                  width: 3,
                                  strokeAlign:
                                      BorderSide.strokeAlignInside,
                                )
                              : null,
                          boxShadow: _selectedColor == color.value
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: _selectedColor == color.value
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: AppDimensions.paddingXL),

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
