import 'package:ai_first_flutter_starter/app/theme/app_radius.dart';
import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

final class EnvironmentBadge extends StatelessWidget {
  const EnvironmentBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Current environment: $label',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: colorScheme.secondary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
      ),
    );
  }
}
