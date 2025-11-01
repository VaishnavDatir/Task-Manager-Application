import 'package:flutter/material.dart';
import 'package:wowtask/core/routing/app_navigator.dart';
import 'package:wowtask/core/routing/route_names.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails? details;

  const ErrorScreen({Key? key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 90,
              ),
              const SizedBox(height: 24),

              Text(
                AppStrings.somethingWentWrong,
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                "Please try again or restart the app.",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  AppNavigator.goToNamed(context, RouteNames.splash);
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: Text(
                  "Retry",
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (details != null) ...[
                const SizedBox(height: 20),
                Text(
                  details!.exceptionAsString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
