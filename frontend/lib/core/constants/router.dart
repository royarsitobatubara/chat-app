import 'package:frontend/presentation/screens/home_screen.dart';
import 'package:frontend/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);
