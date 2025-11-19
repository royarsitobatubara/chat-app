import 'package:frontend/presentation/screens/add_contact_screen.dart';
import 'package:frontend/presentation/screens/chat_screen.dart';
import 'package:frontend/presentation/screens/home_screen.dart';
import 'package:frontend/presentation/screens/list_contact_screen.dart';
import 'package:frontend/presentation/screens/sign_in_screen.dart';
import 'package:frontend/presentation/screens/sign_up_screen.dart';
import 'package:frontend/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/add-contact',
      builder: (context, state) => const AddContactScreen(),
    ),
    GoRoute(
      path: '/list-contact',
      builder: (context, state) => const ListContactScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        final emailFrom = data['email_from'].toString();
        final emailTo = data['email_to'].toString();
        return ChatScreen(emailFrom: emailFrom, emailTo: emailTo);
      },
    ),
  ],
);
