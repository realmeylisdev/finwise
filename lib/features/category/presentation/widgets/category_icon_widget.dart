import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    required this.iconName,
    required this.color,
    this.size = 40,
    super.key,
  });

  final String iconName;
  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(
        _getIcon(iconName),
        color: Color(color),
        size: size * 0.5,
      ),
    );
  }

  static IconData _getIcon(String name) {
    return categoryIcons[name] ?? Icons.category;
  }

  static const Map<String, IconData> categoryIcons = {
    // Expense
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'home': Icons.home,
    'bolt': Icons.bolt,
    'movie': Icons.movie,
    'shopping_bag': Icons.shopping_bag,
    'favorite': Icons.favorite,
    'school': Icons.school,
    'spa': Icons.spa,
    'card_giftcard': Icons.card_giftcard,
    'security': Icons.security,
    'more_horiz': Icons.more_horiz,
    // Income
    'work': Icons.work,
    'laptop': Icons.laptop,
    'trending_up': Icons.trending_up,
    'redeem': Icons.redeem,
    'apartment': Icons.apartment,
    'attach_money': Icons.attach_money,
    // Extra
    'pets': Icons.pets,
    'fitness_center': Icons.fitness_center,
    'flight': Icons.flight,
    'local_cafe': Icons.local_cafe,
    'local_gas_station': Icons.local_gas_station,
    'phone_android': Icons.phone_android,
    'child_care': Icons.child_care,
    'local_hospital': Icons.local_hospital,
    'local_grocery_store': Icons.local_grocery_store,
    'wifi': Icons.wifi,
    'music_note': Icons.music_note,
    'sports_esports': Icons.sports_esports,
    'camera_alt': Icons.camera_alt,
    'build': Icons.build,
    'savings': Icons.savings,
    'account_balance': Icons.account_balance,
    'category': Icons.category,
  };
}
