import 'package:flutter/material.dart';
import 'package:wowtask/core/theme/app_spacing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (_) => true, // avoids default overscroll glow
        child: CustomScrollView(
          slivers: [
            SliverLayoutBuilder(
              builder: (context, constraints) {
                final scrollOffset = constraints.scrollOffset;
                final bool isCollapsed = scrollOffset > 70;

                final double fadeStart = 30; // start fading earlier
                final double fadeEnd = 100; // fully visible after this
                final double opacity =
                    ((scrollOffset - fadeStart) / (fadeEnd - fadeStart)).clamp(
                      0.0,
                      1.0,
                    );

                return SliverAppBar(
                  backgroundColor: AppColors.background,
                  elevation: isCollapsed ? 2 : 0,
                  pinned: true,
                  expandedHeight: 150,
                  toolbarHeight: 70,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: opacity,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hello, ',
                            style: AppTypography.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: 'Vaishnav!',
                            style: AppTypography.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.account_circle),
                      iconSize: AppSpacing.xxl,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.none,
                    background: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        top: 70,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hello, ',
                                    style: AppTypography.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Vaishnav!',
                                    style: AppTypography.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Have a productive day',
                              style: AppTypography.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Placeholder content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 2000,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🧩 Dashboard content coming soon...'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
