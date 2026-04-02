import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/search/presentation/bloc/search_bloc.dart';
import 'package:finwise/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          onChanged: (value) =>
              context.read<SearchBloc>().add(SearchQueryChanged(value)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              context.read<SearchBloc>().add(const SearchCleared());
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Column(
            children: [
              // Type filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: state.filterType == null,
                      onTap: () => context.read<SearchBloc>().add(
                            const SearchFilterChanged(),
                          ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    _FilterChip(
                      label: 'Income',
                      isSelected: state.filterType == 'income',
                      color: AppColors.income,
                      onTap: () => context.read<SearchBloc>().add(
                            const SearchFilterChanged(type: 'income'),
                          ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    _FilterChip(
                      label: 'Expense',
                      isSelected: state.filterType == 'expense',
                      color: AppColors.expense,
                      onTap: () => context.read<SearchBloc>().add(
                            const SearchFilterChanged(type: 'expense'),
                          ),
                    ),
                    SizedBox(width: AppDimensions.paddingS),
                    _FilterChip(
                      label: 'Transfer',
                      isSelected: state.filterType == 'transfer',
                      color: AppColors.transfer,
                      onTap: () => context.read<SearchBloc>().add(
                            const SearchFilterChanged(type: 'transfer'),
                          ),
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(child: _buildResults(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64.w, color: AppColors.disabled),
              SizedBox(height: AppDimensions.paddingM),
              Text(
                'Search by note, category, or account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return Center(
          child: Text(
            'No results found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        );
      case SearchStatus.success:
        return ListView.builder(
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            final txn = state.results[index];
            return TransactionListItem(
              transaction: txn,
              onTap: () =>
                  context.push('${AppRoutes.transactions}/${txn.id}'),
            );
          },
        );
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.primary).withValues(alpha: 0.15)
              : null,
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? (color ?? AppColors.primary) : null,
          ),
        ),
      ),
    );
  }
}
