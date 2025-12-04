import 'package:app/presentation/screens/add_contact_screen.dart';
import 'package:app/presentation/screens/contacts_screen.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/signin_screen.dart';
import 'package:app/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
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
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/add-contact',
        pageBuilder: (BuildContext context, GoRouterState state) {
          // ignore: always_specify_types
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AddContactScreen(),
            transitionsBuilder:
                (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                  const Offset begin = Offset(1.0, 0.0);
                  const Offset end = Offset.zero;
                  // ignore: always_specify_types
                  final Animatable<Offset> tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeOut));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/contacts',
        pageBuilder: (BuildContext context, GoRouterState state) {
          // ignore: always_specify_types
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ContactsScreen(),
            transitionsBuilder:
                (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                  const Offset begin = Offset(1.0, 0.0);
                  const Offset end = Offset.zero;
                  // ignore: always_specify_types
                  final Animatable<Offset> tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeOut));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
    ],
  );
}
