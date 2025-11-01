import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import '../theme/app_spacing.dart';

class WowTaskLogo extends StatelessWidget {
  final double? fontSize;
  final bool showShadow;

  const WowTaskLogo({super.key, this.fontSize, this.showShadow = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = AppTypography.textTheme(theme.brightness);

    final baseStyle = textTheme.displayLarge!.copyWith(
      fontSize: fontSize ?? textTheme.displayLarge!.fontSize,
      shadows: showShadow
          ? [
              Shadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(1, 1),
                blurRadius: 4,
              ),
            ]
          : [],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.task_alt_rounded, size: 100, color: Colors.white),
        const SizedBox(height: AppSpacing.lg),
        RichText(
          text: TextSpan(
            style: AppTypography.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'Wow',
                style: AppTypography.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                ),
              ),
              TextSpan(
                text: 'Task',
                style: AppTypography.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
