import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> hard = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
