import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/utils/validator.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String? _message;
  bool _isLoading = false;
  bool _isError = false;
  bool _obscurePassword = true;

  Future<void> signUpHandle() async {
    final emailError = validateEmail(emailCtrl.text);
    final passError = validatePassword(passCtrl.text);
    final usernameError = validateUsername(usernameCtrl.text);

    if (emailError != null || passError != null || usernameError != null) {
      setState(() {
        _isError = true;
        _message = usernameError ?? emailError ?? passError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = await UserService().signUp(
      username: usernameCtrl.text,
      email: emailCtrl.text,
      password: passCtrl.text,
    );

    if (data.success == false) {
      debugPrint('Error in signUpHandle: ${data.error}');
      setState(() {
        _isLoading = false;
        _isError = true;
        _message = data.message;
      });
      return;
    }

    setState(() {
      _isError = false;
      _message = data.message;
    });

    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return;
    context.go('/signin');
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan gradient text effect
                Center(
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppColors.blue1,
                            AppColors.blue2,
                            AppColors.blue3,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign up to get started",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Username TextField dengan gradient border
                const Text(
                  "Username",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue1,
                        AppColors.blue2,
                        AppColors.blue3,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: usernameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: .5),
                        ),
                        prefixIcon: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.blue1, AppColors.blue2],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email TextField dengan gradient border
                const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue1,
                        AppColors.blue2,
                        AppColors.blue3,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: .5),
                        ),
                        prefixIcon: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.blue1, AppColors.blue2],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextField dengan gradient border
                const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue1,
                        AppColors.blue2,
                        AppColors.blue3,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: passCtrl,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: .5),
                        ),
                        prefixIcon: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.blue2, AppColors.blue3],
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white.withValues(alpha: .7),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Message (Error atau Success)
                if (_message != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _isError
                          ? Colors.red.withValues(alpha: .2)
                          : Colors.green.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isError
                            ? Colors.red.withValues(alpha: .5)
                            : Colors.green.withValues(alpha: .5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isError
                              ? Icons.error_outline
                              : Icons.check_circle_outline,
                          color: _isError ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _message!,
                            style: TextStyle(
                              color: _isError ? Colors.red : Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Sign Up Button dengan gradient
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue1,
                        AppColors.blue2,
                        AppColors.blue3,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue2.withValues(alpha: .3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isLoading ? null : signUpHandle,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: .3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: .3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        icon: Icons.g_mobiledata,
                        label: "Google",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _socialButton(icon: Icons.apple, label: "Apple"),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Sign In Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .7),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/signin');
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.blue1, AppColors.blue3],
                          ).createShader(bounds),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({required IconData icon, required String label}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blue1.withValues(alpha: .2),
            AppColors.blue2.withValues(alpha: .2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue2.withValues(alpha: .3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle social login
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
