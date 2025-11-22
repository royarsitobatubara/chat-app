import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/widgets/app_bar_custom.dart';
import 'package:frontend/presentation/widgets/text_field_widget.dart';
import 'package:go_router/go_router.dart';

class EditUsernameScreen extends StatefulWidget {
  final String email;
  const EditUsernameScreen({super.key, required this.email});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  String? _msg;
  bool _loading = false;

  void submitHandle() async {
    final username = _usernameCtrl.text.trim();
    if (username.isEmpty) return;

    setState(() => _loading = true);

    final res = await UserService().updateUsername(
      email: widget.email,
      username: username,
    );

    setState(() => _loading = false);

    if (res.success == false) {
      setState(() => _msg = res.message);
      return;
    }

    if (!mounted) return;
    context.pop();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(nameScreen: 'Edit username'),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFieldWidget(
                controller: _usernameCtrl,
                hintText: 'Enter username',
                icon: Icons.person,
              ),
            ),

            if (_msg != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text(
                    _msg!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

            const Spacer(),

            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.blue2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: _loading ? null : submitHandle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Save change",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
