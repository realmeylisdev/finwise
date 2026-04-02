import 'package:finwise/core/theme/app_colors.dart';
import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/security/presentation/bloc/security_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String? _error;

  void _onDigit(String digit) {
    HapticFeedback.lightImpact();
    if (_isConfirming) {
      if (_confirmPin.length >= 4) return;
      setState(() => _confirmPin += digit);
      if (_confirmPin.length == 4) _checkConfirm();
    } else {
      if (_pin.length >= 4) return;
      setState(() => _pin += digit);
      if (_pin.length == 4) {
        setState(() => _isConfirming = true);
      }
    }
  }

  void _onDelete() {
    HapticFeedback.lightImpact();
    if (_isConfirming) {
      if (_confirmPin.isEmpty) return;
      setState(() => _confirmPin = _confirmPin.substring(
            0,
            _confirmPin.length - 1,
          ));
    } else {
      if (_pin.isEmpty) return;
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _checkConfirm() {
    if (_pin == _confirmPin) {
      context.read<SecurityBloc>().add(SecurityPinSet(_pin));
      context.pop(true);
    } else {
      setState(() {
        _error = 'PINs do not match. Try again.';
        _confirmPin = '';
        _isConfirming = false;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return Scaffold(
      appBar: AppBar(title: const Text('Set PIN')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              _isConfirming ? 'Confirm PIN' : 'Enter new PIN',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppDimensions.paddingL),
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
                    color: i < currentPin.length
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            if (_error != null) ...[
              SizedBox(height: AppDimensions.paddingM),
              Text(
                _error!,
                style: TextStyle(color: AppColors.expense, fontSize: 14.sp),
              ),
            ],
            const Spacer(),
            // Reuse same number pad layout
            _SimplePad(onDigit: _onDigit, onDelete: _onDelete),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _SimplePad extends StatelessWidget {
  const _SimplePad({required this.onDigit, required this.onDelete});

  final void Function(String) onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', 'del'],
        ])
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                if (key == 'del') {
                  return _Btn(
                    child: const Icon(Icons.backspace_outlined),
                    onTap: onDelete,
                  );
                }
                if (key.isEmpty) return SizedBox(width: 88.w);
                return _Btn(
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

class _Btn extends StatelessWidget {
  const _Btn({required this.child, this.onTap});
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
