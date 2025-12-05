import 'package:app/presentation/screens/add_contact_screen.dart';
import 'package:app/presentation/screens/chat_screen.dart';
import 'package:app/presentation/screens/contacts_screen.dart';
import 'package:app/presentation/screens/edit_contact_screen.dart';
import 'package:app/presentation/screens/home_screen.dart';
import 'package:app/presentation/screens/profile_screen.dart';
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
          return buildRightToLeftPage(
            state: state,
            child: const AddContactScreen(),
          );
        },
      ),
      GoRoute(
        path: '/edit-contact',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return buildRightToLeftPage(
            state: state,
            child: EditContactScreen(
              emailReceiver: data['emailReceiver'] as String,
              emailSender: data['emailSender'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: '/contacts',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildRightToLeftPage(
            state: state,
            child: const ContactsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String emailReceiver = state.extra as String;
          return buildRightToLeftPage(
            state: state,
            child: ProfileScreen(emailReceiver: emailReceiver),
          );
        },
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return buildRightToLeftPage(
            state: state,
            child: ChatScreen(
              emailReceiver: data['emailReceiver'] as String,
              emailSender: data['emailSender'] as String,
            ),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage<dynamic> buildRightToLeftPage({
  required GoRouterState state,
  required Widget child,
}) {
  const Offset begin = Offset(1.0, 0.0);
  const Offset end = Offset.zero;

  final Animatable<Offset> tween = Tween<Offset>(
    begin: begin,
    end: end,
  ).chain(CurveTween(curve: Curves.easeOut));

  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
  );
}
