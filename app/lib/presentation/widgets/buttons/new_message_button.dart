import 'package:app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class NewMessageButton extends StatelessWidget {
  final VoidCallback handler;
  const NewMessageButton({super.key, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppColor.lightBlue, AppColor.mediumBlue],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.lightBlue.withValues(alpha: .5),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => handler(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.edit_square, size: 25, color: AppColor.secondary),
              SizedBox(width: 10),
              Text(
                "New Messages",
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
