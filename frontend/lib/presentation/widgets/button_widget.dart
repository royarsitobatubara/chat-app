import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

Widget buildButton(BuildContext context, String text, VoidCallback onTap) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
      ),
    ),
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),
  );
}

Widget gradientIconButton({
  required IconData icon,
  required VoidCallback onPressed,
  double sizeButton = 48,
}) {
  return Container(
    width: sizeButton,
    height: sizeButton,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.blue2.withValues(alpha: .3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    ),
  );
}

Widget squareActionButton({
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.blue1.withValues(alpha: .2),
          AppColors.blue2.withValues(alpha: .2),
        ],
      ),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: AppColors.blue2.withValues(alpha: .3),
        width: 1.5,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    ),
  );
}
