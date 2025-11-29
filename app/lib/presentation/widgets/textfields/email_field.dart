import 'package:app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: AppColor.primary, fontSize: 16),
        decoration: InputDecoration(
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.email_outlined, color: AppColor.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColor.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Email cannot be empty';
          }
          if (!value.contains('@')) {
            return 'Invalid email';
          }
          return null;
        },
      ),
    );
  }
}
