import 'package:app/presentation/screens/signin_screen.dart';
import 'package:app/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/signin',
    routes: <GoRoute>[
      GoRoute(
        path: '/signin',
        builder: (BuildContext context, GoRouterState state) =>
            const SigninScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
    ],
  );
}
