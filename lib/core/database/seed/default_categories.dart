import 'package:flutter/material.dart';

class DefaultCategory {
  const DefaultCategory({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.sortOrder,
  });

  final String name;
  final String type;
  final String icon;
  final int color;
  final int sortOrder;
}

final defaultExpenseCategories = [
  DefaultCategory(
    name: 'Food & Dining',
    type: 'expense',
    icon: 'restaurant',
    color: Colors.orange.value,
    sortOrder: 0,
  ),
  DefaultCategory(
    name: 'Transportation',
    type: 'expense',
    icon: 'directions_car',
    color: Colors.blue.value,
    sortOrder: 1,
  ),
  DefaultCategory(
    name: 'Housing',
    type: 'expense',
    icon: 'home',
    color: Colors.brown.value,
    sortOrder: 2,
  ),
  DefaultCategory(
    name: 'Utilities',
    type: 'expense',
    icon: 'bolt',
    color: Colors.amber.value,
    sortOrder: 3,
  ),
  DefaultCategory(
    name: 'Entertainment',
    type: 'expense',
    icon: 'movie',
    color: Colors.purple.value,
    sortOrder: 4,
  ),
  DefaultCategory(
    name: 'Shopping',
    type: 'expense',
    icon: 'shopping_bag',
    color: Colors.pink.value,
    sortOrder: 5,
  ),
  DefaultCategory(
    name: 'Health',
    type: 'expense',
    icon: 'favorite',
    color: Colors.red.value,
    sortOrder: 6,
  ),
  DefaultCategory(
    name: 'Education',
    type: 'expense',
    icon: 'school',
    color: Colors.indigo.value,
    sortOrder: 7,
  ),
  DefaultCategory(
    name: 'Personal Care',
    type: 'expense',
    icon: 'spa',
    color: Colors.teal.value,
    sortOrder: 8,
  ),
  DefaultCategory(
    name: 'Gifts & Donations',
    type: 'expense',
    icon: 'card_giftcard',
    color: Colors.deepPurple.value,
    sortOrder: 9,
  ),
  DefaultCategory(
    name: 'Insurance',
    type: 'expense',
    icon: 'security',
    color: Colors.blueGrey.value,
    sortOrder: 10,
  ),
  DefaultCategory(
    name: 'Other Expense',
    type: 'expense',
    icon: 'more_horiz',
    color: Colors.grey.value,
    sortOrder: 11,
  ),
];

final defaultIncomeCategories = [
  DefaultCategory(
    name: 'Salary',
    type: 'income',
    icon: 'work',
    color: Colors.green.value,
    sortOrder: 0,
  ),
  DefaultCategory(
    name: 'Freelance',
    type: 'income',
    icon: 'laptop',
    color: Colors.lightGreen.value,
    sortOrder: 1,
  ),
  DefaultCategory(
    name: 'Investment',
    type: 'income',
    icon: 'trending_up',
    color: Colors.cyan.value,
    sortOrder: 2,
  ),
  DefaultCategory(
    name: 'Gift',
    type: 'income',
    icon: 'redeem',
    color: Colors.deepOrange.value,
    sortOrder: 3,
  ),
  DefaultCategory(
    name: 'Rental',
    type: 'income',
    icon: 'apartment',
    color: Colors.lime.value,
    sortOrder: 4,
  ),
  DefaultCategory(
    name: 'Other Income',
    type: 'income',
    icon: 'attach_money',
    color: Colors.tealAccent.value,
    sortOrder: 5,
  ),
];
