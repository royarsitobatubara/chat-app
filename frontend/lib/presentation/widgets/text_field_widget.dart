import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
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
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: .5)),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.blue1, AppColors.blue2],
              ).createShader(bounds),
              child: Icon(icon, color: Colors.white),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}
