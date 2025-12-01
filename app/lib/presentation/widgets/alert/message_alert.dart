import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MessageAlert extends StatelessWidget {
  final bool isError;
  final String message;
  const MessageAlert({super.key, required this.isError, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: isError == true ? Colors.redAccent : Colors.greenAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isError == true
            ? Colors.redAccent.withValues(alpha: .5)
            : Colors.greenAccent.withValues(alpha: .5),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isError == true ? Icons.error : Icons.check_circle,
            color: isError == true ? Colors.redAccent : Colors.greenAccent,
            size: 25,
          ),
          const SizedBox(width: 10),
          Text(
            message.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
