import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/app_bar_custom.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        AppBarCustom(nameScreen: 'Edit password')
      ],)),
    );
  }
}