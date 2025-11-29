import 'package:app/core/constants/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat-app',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
