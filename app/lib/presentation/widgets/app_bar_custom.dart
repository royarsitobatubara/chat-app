import 'package:app/core/constants/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarCustom({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primary,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColor.lightBlue,
        ),
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title.tr(),
        style: const TextStyle(
          color: AppColor.lightBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
