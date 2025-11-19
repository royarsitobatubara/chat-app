import 'package:flutter/material.dart';
import 'package:frontend/data/providers/contact_provider.dart';
import 'package:frontend/data/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/constants/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat app',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}