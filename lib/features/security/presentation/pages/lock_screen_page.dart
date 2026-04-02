import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/security/presentation/bloc/security_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  String _enteredPin = '';

  void _onDigit(String digit) {
    if (_enteredPin.length >= 4) return;
    HapticFeedback.lightImpact();
    setState(() => _enteredPin += digit);

    if (_enteredPin.length == 4) {
      context.read<SecurityBloc>().add(SecurityPinVerified(_enteredPin));
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _enteredPin = '');
      });
    }
  }

  void _onDelete() {
    if (_enteredPin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() => _enteredPin = _enteredPin.substring(
          0,
          _enteredPin.length - 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final securityState = context.watch<SecurityBloc>().state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.lock_outline,
              size: 48.w,
              color: AppColors.primary,
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              'Enter PIN',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: AppDimensions.paddingL),

            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _enteredPin.length
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),

            if (securityState.errorMessage != null) ...[
              SizedBox(height: AppDimensions.paddingM),
              Text(
                securityState.errorMessage!,
                style: TextStyle(
                  color: AppColors.expense,
                  fontSize: 14.sp,
                ),
              ),
            ],

            const Spacer(),

            // Number pad
            _NumberPad(
              onDigit: _onDigit,
              onDelete: _onDelete,
              onBiometric: securityState.biometricAvailable
                  ? () => context
                      .read<SecurityBloc>()
                      .add(const SecurityBiometricRequested())
                  : null,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad({
    required this.onDigit,
    required this.onDelete,
    this.onBiometric,
  });

  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['bio', '0', 'del'],
        ])
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                if (key == 'del') {
                  return _PadButton(
                    child: const Icon(Icons.backspace_outlined),
                    onTap: onDelete,
                  );
                }
                if (key == 'bio') {
                  return _PadButton(
                    child: Icon(
                      Icons.fingerprint,
                      color: onBiometric != null
                          ? AppColors.primary
                          : AppColors.disabled,
                    ),
                    onTap: onBiometric,
                  );
                }
                return _PadButton(
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => onDigit(key),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40.r),
        child: Container(
          width: 64.w,
          height: 64.w,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
