import 'package:app/core/constants/app_color.dart';
import 'package:app/core/constants/app_router.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Locale startLocale = Locale(await UserPreferences.getLanguage());
  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[Locale('en'), Locale('id')],
      path: 'assets/langs',
      startLocale: startLocale,
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

// ElevatedButton(
//   onPressed: () async {
//     const newLocale = Locale('id');
//     await saveLocale(newLocale);
//     context.setLocale(newLocale);
//   },
//   child: const Text("Ganti ke Indonesia"),
// );

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: 'Chat-app',
      color: AppColor.primary,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
