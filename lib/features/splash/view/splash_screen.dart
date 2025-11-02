import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/wow_task_logo.dart';
import '../view_model/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().initialize(context);
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WowTaskLogo(),
            const SizedBox(height: AppSpacing.sm),
            const SizedBox(
              width: AppSpacing.lg * 4,
              child: LinearProgressIndicator(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
