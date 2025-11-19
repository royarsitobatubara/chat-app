import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/data/preferences/data_preferences.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/widgets/button_widget.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool _isOffline = false;

  Future<void> splashHandle() async {
    final data = await UserService().pingServer();

    // Jika server sedang down
    if (data.success == false) {
      debugPrint('Error in splashHandle: ${data.error}');
      setState(() {
        _isOffline = true;
        _isLoading = false;
      });
      return;
    }

    // Jika terhubung dengan server
    final isLogin = await DataPreferences.getLogin();
    // final token = await DataPreferences.getToken();
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    context.go(isLogin == true ? '/home' : '/signin');
  }

  Future<void> offlineModeHandle() async {
    final isLogin = await DataPreferences.getLogin();
    if (!mounted) return;
    context.go(isLogin == true ? '/home' : '/signin');
  }

  @override
  void initState() {
    super.initState();
    splashHandle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Loading di tengah
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : null,
                ),
              ),

              if (_isOffline)
                Row(
                  children: [
                    Expanded(
                      child: buildButton(context, "Reload", splashHandle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildButton(
                        context,
                        "Mode offline",
                        offlineModeHandle,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
