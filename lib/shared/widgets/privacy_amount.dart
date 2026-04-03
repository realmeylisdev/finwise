import 'package:finwise/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wraps a monetary display. When privacy mode is on, shows bullet dots.
class PrivacyAmount extends StatelessWidget {
  const PrivacyAmount({
    required this.child,
    this.placeholder = '••••••',
    super.key,
  });

  final Widget child;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsBloc, SettingsState, bool>(
      selector: (state) => state.isPrivacyModeEnabled,
      builder: (context, isPrivate) {
        if (!isPrivate) return child;
        return Text(
          placeholder,
          style: DefaultTextStyle.of(context).style,
        );
      },
    );
  }
}
