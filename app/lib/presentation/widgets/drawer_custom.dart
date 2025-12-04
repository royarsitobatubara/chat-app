import 'dart:ui';

import 'package:app/core/constants/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerCustom extends StatelessWidget {
  final List<Map<String, dynamic>> listItemDrawer;
  final GlobalKey<ScaffoldState> keyDrawer;
  const DrawerCustom({
    super.key,
    required this.listItemDrawer,
    required this.keyDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: AppColor.secondary.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 80),
                ...listItemDrawer.map((dynamic itm) {
                  return itemDrawer(
                    context,
                    itm['label'],
                    itm['icon'],
                    itm['router'],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemDrawer(
    BuildContext context,
    String label,
    IconData icon,
    String router,
  ) {
    return GestureDetector(
      onTap: () {
        keyDrawer.currentState!.closeDrawer();
        context.push(router);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColor.mediumBlue.withValues(alpha: .20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColor.lightBlue, size: 25),
            const SizedBox(width: 10),
            Text(
              label.tr(),
              style: const TextStyle(
                color: AppColor.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
