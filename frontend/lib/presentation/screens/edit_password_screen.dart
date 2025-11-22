import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/utils/validator.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/widgets/app_bar_custom.dart';
import 'package:frontend/presentation/widgets/text_field_widget.dart';
import 'package:go_router/go_router.dart';

class EditPasswordScreen extends StatefulWidget {
  final String email;
  const EditPasswordScreen({super.key, required this.email});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _passOldCtrl = TextEditingController();
  final TextEditingController _passNewCtrl = TextEditingController();
  String? _msg;
  bool _loading = false;

  void submitHandle() async {
    final validate = validatePassword(_passNewCtrl.text);
    final passOld = _passOldCtrl.text.trim();
    final passNew = _passNewCtrl.text.trim();
    if (passNew.isEmpty || passOld.isEmpty) {
      setState(() => _msg = "Field cannot empty");
      return;
    }

    if (validate != null) {
      setState(() => _msg = validate);
      return;
    }

    setState(() => _loading = true);

    final res = await UserService().updatePassword(
      email: widget.email,
      passOld: passOld,
      passNew: passNew,
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
    _passNewCtrl.dispose();
    _passOldCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(nameScreen: 'Edit password'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFieldWidget(
                controller: _passOldCtrl,
                hintText: 'Enter old password',
                icon: Icons.lock_clock_outlined,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFieldWidget(
                controller: _passNewCtrl,
                hintText: 'Enter new password',
                icon: Icons.lock,
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
