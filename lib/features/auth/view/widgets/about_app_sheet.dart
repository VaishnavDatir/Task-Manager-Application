import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/wow_task_logo.dart';

Future<void> showAboutAppSheet(BuildContext context) async {
  final info = await PackageInfo.fromPlatform();

  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Center(
                  child: WowTaskLogo(bgColor: Theme.of(context).cardColor),
                ),
                const SizedBox(height: AppSpacing.md),

                Center(
                  child: const Text(
                    'About',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'WowTask helps you organize your daily work efficiently. '
                  'You can create, edit, and track your tasks seamlessly '
                  'with a smooth and intuitive experience.',
                  style: TextStyle(fontSize: AppSpacing.md, height: 1.5),
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  leading: const Icon(Icons.app_settings_alt_outlined),
                  title: const Text('Version'),
                  subtitle: Text(info.version),
                ),
                const ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Developed by'),
                  subtitle: Text('Vaishnav Datir'),
                ),
                const ListTile(
                  leading: Icon(Icons.code_outlined),
                  title: Text('Built with'),
                  subtitle: Text('Flutter • Back4App'),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    '© 2025 WowTask',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
