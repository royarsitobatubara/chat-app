import 'package:app/core/constants/app_color.dart';
import 'package:app/core/helper/api_response.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/data/services/auth_service.dart';
import 'package:app/presentation/widgets/alert/message_alert.dart';
import 'package:app/presentation/widgets/buttons/submit_button.dart';
import 'package:app/presentation/widgets/textfields/email_field.dart';
import 'package:app/presentation/widgets/textfields/password_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  String? _msg;
  bool _isError = true;
  bool _isLoading = false;

  Future<void> _submitHandle() async {
    setState(() {
      _isLoading = true;
      _msg = null;
    });

    if (_formKey.currentState!.validate()) {
      final ApiResponse data = await signIn(
        email: _emailCtrl.text.toLowerCase(),
        password: _passCtrl.text,
      );

      if (data.success == true) {
        setState(() {
          _isError = false;
          _msg = data.message;
        });
        await UserPreferences.setLogin(true);
        await UserPreferences.setEmail(_emailCtrl.text);
        await Future<dynamic>.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        context.push('/home');
      } else {
        // gagal login
        setState(() {
          _msg = data.message; // tampilkan pesan error dari API
        });
      }
    }

    // reset loading apapun hasilnya
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Welcome\nBack!",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                EmailField(controller: _emailCtrl),
                const SizedBox(height: 30),
                PasswordField(controller: _passCtrl),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/signup'),
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(
                        color: AppColor.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_msg != null)
                  MessageAlert(isError: _isError, message: _msg!),
                const SizedBox(height: 20),
                SubmitButton(
                  loading: _isLoading,
                  text: "Sign in",
                  handle: _submitHandle,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => context.push('/signup'),
                    child: const Text(
                      'Dont have account? Sign up',
                      style: TextStyle(
                        color: AppColor.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
