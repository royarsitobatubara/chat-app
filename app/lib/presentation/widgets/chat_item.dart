import 'package:app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String? status;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.onTap,
    this.status,
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
            if (status != null) _buildStatusIcon(status!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return const Icon(Icons.access_time, size: 20, color: Colors.grey);

      case 'send':
        return const Icon(Icons.done, size: 20, color: Colors.grey);

      case 'delivered':
        return const Icon(Icons.done_all, size: 20, color: Colors.grey);

      case 'read':
        return const Icon(Icons.done_all, size: 20, color: AppColor.lightBlue);

      default:
        return const Icon(Icons.help_outline, size: 20, color: Colors.grey);
    }
  }
}
