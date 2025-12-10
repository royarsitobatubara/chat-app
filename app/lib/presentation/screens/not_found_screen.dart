import 'package:app/core/constants/app_color.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBarCustom(title: '404'),
      body: Center(
        child: Text(
          'Not Found',
          style: TextStyle(
            color: AppColor.lightBlue,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
