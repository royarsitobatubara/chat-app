import 'package:app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 55,
          height: 55,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColor.lightBlue,
                AppColor.lightBlue,
                AppColor.mediumBlue,
              ],
            ),
          ),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(
              color: AppColor.secondary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColor.lightBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.lightBlue, fontSize: 14),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              time,
              style: const TextStyle(color: AppColor.lightBlue, fontSize: 12),
            ),
            const Icon(Icons.check, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
