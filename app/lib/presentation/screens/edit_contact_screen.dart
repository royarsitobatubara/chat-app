import 'package:app/core/constants/app_color.dart';
import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/providers/contact_provider.dart';
import 'package:app/presentation/widgets/alert/message_alert.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:app/presentation/widgets/buttons/submit_button.dart';
import 'package:app/presentation/widgets/textfields/username_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditContactScreen extends StatefulWidget {
  final String emailReceiver;
  final String emailSender;
  const EditContactScreen({
    super.key,
    required this.emailSender,
    required this.emailReceiver,
  });

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  bool isLoading = false;
  bool _isError = false;
  String _msg = '';

  Future<void> editContactHandle() async {
    setState(() {
      isLoading = true;
    });
    final bool data = await ContactDbService.updateContact(
      widget.emailSender,
      widget.emailReceiver,
      ContactModel(
        name: _usernameCtrl.text,
        emailSender: widget.emailSender,
        emailReceiver: widget.emailReceiver,
      ),
    );
    if (data == false) {
      setState(() {
        isLoading = false;
        _isError = true;
        _msg = "failed_update_user";
      });
      return;
    }
    setState(() {
      isLoading = false;
      _isError = false;
      _msg = "success_update_user";
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.read<ContactProvider>().getContact(
      widget.emailSender,
      widget.emailReceiver,
    );
    context.pop();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: const AppBarCustom(title: 'edit_contact'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Edit Username',
                style: TextStyle(
                  color: AppColor.lightBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              UsernameField(controller: _usernameCtrl),

              const SizedBox(height: 10),

              if (_msg.isNotEmpty)
                MessageAlert(isError: _isError, message: _msg),

              const Spacer(),

              SubmitButton(
                loading: isLoading,
                text: 'confirm',
                handle: editContactHandle,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
