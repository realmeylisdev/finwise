import 'package:finwise/core/di/injection.dart';
import 'package:finwise/core/navigation/app_routes.dart';
import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/account/domain/entities/account_entity.dart';
import 'package:finwise/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:finwise/shared/widgets/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingBloc>(),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.currentStep == OnboardingStep.done) {
            context.go(AppRoutes.dashboard);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Progress dots
                  if (state.currentStep != OnboardingStep.done)
                    Padding(
                      padding: EdgeInsets.only(top: AppDimensions.paddingM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final stepIndex = state.currentStep.index;
                          final isActive = i <= stepIndex;
                          return Container(
                            width: isActive ? 24.w : 8.w,
                            height: 8.w,
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.primary
                                      .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          );
                        }),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingL),
                      child: _buildStep(context, state),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep(BuildContext context, OnboardingState state) {
    switch (state.currentStep) {
      case OnboardingStep.welcome:
        return _WelcomeStep();
      case OnboardingStep.currency:
        return _CurrencyStep(selected: state.selectedCurrency);
      case OnboardingStep.account:
        return _AccountStep();
      case OnboardingStep.done:
        return const Center(child: SkeletonCard());
    }
  }
}

class _WelcomeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Icon(
          Icons.account_balance_wallet,
          size: 80.w,
          color: AppColors.primary,
        ),
        SizedBox(height: AppDimensions.paddingL),
        Text(
          'Welcome to FinWise',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.paddingM),
        Text(
          'Take control of your finances.\nTrack spending, set budgets, and reach your goals.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context
                .read<OnboardingBloc>()
                .add(const OnboardingNextStep()),
            child: const Text('Get Started'),
          ),
        ),
      ],
    );
  }
}

class _CurrencyStep extends StatelessWidget {
  const _CurrencyStep({required this.selected});
  final String selected;

  static const _currencies = [
    ('USD', 'US Dollar', '\$'),
    ('EUR', 'Euro', '€'),
    ('GBP', 'British Pound', '£'),
    ('TMT', 'Turkmen Manat', 'T'),
    ('RUB', 'Russian Ruble', '₽'),
    ('TRY', 'Turkish Lira', '₺'),
    ('CNY', 'Chinese Yuan', '¥'),
    ('JPY', 'Japanese Yen', '¥'),
    ('INR', 'Indian Rupee', '₹'),
    ('BRL', 'Brazilian Real', 'R\$'),
    ('KRW', 'South Korean Won', '₩'),
    ('AED', 'UAE Dirham', 'د.إ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.paddingL),
        Text(
          'Choose your currency',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: AppDimensions.paddingS),
        Text(
          'This will be your default currency for all transactions.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: AppDimensions.paddingL),
        Expanded(
          child: ListView.separated(
            itemCount: _currencies.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppDimensions.paddingXS),
            itemBuilder: (context, index) {
              final c = _currencies[index];
              final isSelected = c.$1 == selected;
              return Card(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : null,
                shape: isSelected
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                        side: const BorderSide(color: AppColors.primary),
                      )
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      c.$3,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(c.$2),
                  subtitle: Text(c.$1),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () => context
                      .read<OnboardingBloc>()
                      .add(OnboardingCurrencySelected(c.$1)),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppDimensions.paddingM),
        Row(
          children: [
            TextButton(
              onPressed: () => context
                  .read<OnboardingBloc>()
                  .add(const OnboardingPrevStep()),
              child: const Text('Back'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context
                  .read<OnboardingBloc>()
                  .add(const OnboardingNextStep()),
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccountStep extends StatefulWidget {
  @override
  State<_AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends State<_AccountStep> {
  final _nameController = TextEditingController(text: 'Cash');
  final _balanceController = TextEditingController();
  var _type = AccountType.cash;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.paddingL),
        Text(
          'Set up your first account',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: AppDimensions.paddingS),
        Text(
          'You can add more accounts later.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: AppDimensions.paddingL),
        SegmentedButton<AccountType>(
          segments: const [
            ButtonSegment(
              value: AccountType.cash,
              label: Text('Cash'),
              icon: Icon(Icons.payments),
            ),
            ButtonSegment(
              value: AccountType.bank,
              label: Text('Bank'),
              icon: Icon(Icons.account_balance),
            ),
            ButtonSegment(
              value: AccountType.savings,
              label: Text('Save'),
              icon: Icon(Icons.savings),
            ),
          ],
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
        ),
        SizedBox(height: AppDimensions.paddingM),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Account Name'),
        ),
        SizedBox(height: AppDimensions.paddingM),
        TextField(
          controller: _balanceController,
          decoration: const InputDecoration(
            labelText: 'Current Balance',
            prefixText: '\$ ',
            hintText: '0.00',
          ),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
        ),
        const Spacer(),
        Row(
          children: [
            TextButton(
              onPressed: () => context
                  .read<OnboardingBloc>()
                  .add(const OnboardingPrevStep()),
              child: const Text('Back'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final balance =
                    double.tryParse(_balanceController.text.trim()) ?? 0;
                context.read<OnboardingBloc>()
                  ..add(OnboardingAccountSetup(
                    name: _nameController.text.trim().isEmpty
                        ? 'Cash'
                        : _nameController.text.trim(),
                    type: _type,
                    balance: balance,
                  ))
                  ..add(const OnboardingCompleted());
              },
              child: const Text('Finish Setup'),
            ),
          ],
        ),
      ],
    );
  }
}
