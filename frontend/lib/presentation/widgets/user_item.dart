import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class UserItem extends StatelessWidget {
  final String username;
  final String email;
  final Color colorAvatar;
  final VoidCallback handle;
  final bool isAdded;

  const UserItem({
    super.key,
    required this.username,
    required this.email,
    required this.colorAvatar,
    required this.handle,
    required this.isAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: .5),
          width: .7,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [colorAvatar, colorAvatar.withValues(alpha: .5)],
            ),
          ),
          child: Center(
            child: Text(
              username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        title: Text(
          username,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Text(
          email,
          style: TextStyle(color: Colors.white.withValues(alpha: .7)),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                AppColors.blue1.withValues(alpha: .5),
                AppColors.blue2.withValues(alpha: .9),
              ],
            ),
          ),
          child: IconButton(
            onPressed: handle,
            icon: Icon(
              isAdded ? Icons.cancel_outlined : Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
