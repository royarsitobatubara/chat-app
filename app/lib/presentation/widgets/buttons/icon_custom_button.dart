import 'package:app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class IconCustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback handle;
  const IconCustomButton({super.key, required this.icon, required this.handle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handle(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.lightBlue,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.lightBlue.withValues(alpha: .5),
              offset: const Offset(0, 5),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, size: 26, color: AppColor.secondary),
      ),
    );
  }
}
