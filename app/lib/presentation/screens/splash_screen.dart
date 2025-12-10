// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
// import 'package:app/data/database/db_helper.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getInitData() async {
    // await DBHelper.instance.deleteDatabaseFile();
    // await UserPreferences.setLogin(false);
    final bool isLogin = await UserPreferences.getLogin();
    // final String email = await UserPreferences.getEmail();

    await Future.delayed(const Duration(milliseconds: 300));

    if (isLogin) {
      if (mounted) context.go('/home');
      return;
    }

    if (mounted) context.go('/signin');
  }

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
