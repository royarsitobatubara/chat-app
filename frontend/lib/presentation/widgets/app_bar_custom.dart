import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppBarCustom extends StatelessWidget {
  final String nameScreen;
  const AppBarCustom({super.key, required this.nameScreen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back Button dengan gradient & shadow
          Container(
            width: 48,
            height: 48,
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
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(12),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
              ).createShader(bounds),
              child: Text(
                nameScreen,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
