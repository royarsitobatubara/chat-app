import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/data/preferences/data_preferences.dart';
import 'package:frontend/data/preferences/user_preferences.dart';
import 'package:frontend/presentation/widgets/app_bar_custom.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _email;

  Future<void> getDataInit() async {
    final email = await UserPreferences.getEmail();
    setState(() {
      _email = email;
    });
  }

  void logOutHandle() async {
    await DataPreferences.setLogin(false);
    await UserPreferences.setEmail('');
    if (!mounted) return;
    context.go('/splash');
  }

  @override
  void initState() {
    super.initState();
    getDataInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(nameScreen: 'Profile'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar Section
                    _buildProfileAvatar(),
                    const SizedBox(height: 30),

                    // Info Cards
                    _containerInfo(
                      context: context,
                      label: 'Username',
                      value: 'Guest',
                      icon: Icons.person_outline,
                      route: '/edit-username',
                      extra: _email,
                    ),
                    _containerInfo(
                      context: context,
                      label: 'Email',
                      value: 'someone@gmail.com',
                      icon: Icons.email_outlined,
                    ),
                    _containerInfo(
                      context: context,
                      label: 'Password',
                      value: '******',
                      icon: Icons.lock_outline,
                      route: '/edit-password',
                      extra: _email,
                    ),

                    const SizedBox(height: 20),

                    // Additional Options
                    _buildActionButton(
                      context: context,
                      label: 'Settings',
                      icon: Icons.settings_outlined,
                      onTap: () {},
                    ),
                    _buildActionButton(
                      context: context,
                      label: 'Help & Support',
                      icon: Icons.help_outline,
                      onTap: () {},
                    ),
                    _buildActionButton(
                      context: context,
                      label: 'Logout',
                      icon: Icons.logout,
                      isDestructive: true,
                      onTap: () => logOutHandle(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.blue2, AppColors.blue2.withValues(alpha: .6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue2.withValues(alpha: .3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, size: 50, color: AppColors.blue2),
        ),
      ),
    );
  }

  Widget _containerInfo({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    String? route,
    dynamic extra,
  }) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.blue2.withValues(alpha: .1),
            AppColors.blue2.withValues(alpha: .05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.blue2.withValues(alpha: .3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue2.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: route != null ? () => context.push(route, extra: extra) : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blue2.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.blue2, size: 24),
                ),
                const SizedBox(width: 16),

                // Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Button
                if (route != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.blue2.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: AppColors.blue2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.blue2;

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color.withValues(alpha: .5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
