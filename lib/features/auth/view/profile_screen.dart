import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../view_model/auth_viewmodel.dart';
import 'widgets/about_app_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile on screen load
    Future.microtask(() {
      context.read<AuthViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.user;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await authVM.logout();
                  // Navigation handled inside logout itself
                },
              ),
            ],
          ),

          body: authVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Icon(Icons.account_circle, size: AppSpacing.xxl * 2),

                      const SizedBox(height: 16),

                      Text(
                        user?.fullName ?? "Unknown User",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        user?.email ?? "No Email",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 30),

                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("Edit Profile"),
                        onTap: () {},
                      ),

                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Settings"),
                        onTap: () {},
                      ),

                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("About App"),
                        onTap: () => showAboutAppSheet(context),
                      ),

                      const Spacer(),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await authVM.logout();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                      ),
                    ],
                  ),
                ),
        ),

        // 🔥 Loading overlay
        if (authVM.isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
