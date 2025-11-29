import 'package:app/core/constants/app_color.dart';
import 'package:app/presentation/widgets/buttons/icon_custom_button.dart';
import 'package:app/presentation/widgets/buttons/new_message_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            right: 20.0,
            left: 20.0,
            bottom: 10.0,
          ),
          child: Column(
            children: <Widget>[
              // TOP NAVIGATION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <IconCustomButton>[
                  IconCustomButton(icon: Icons.menu, handle: () {}),
                  IconCustomButton(icon: Icons.search, handle: () {}),
                ],
              ),

              const SizedBox(height: 30),

              // INBOX AND COUNT MESSAGE
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Inbox",
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "(10 messages)",
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // NEW MESSAGES AND FILTER CHAT
              Row(
                children: <Widget>[
                  NewMessageButton(handler: () {}),
                  const SizedBox(width: 12),
                  IconCustomButton(
                    icon: Icons.settings_input_component,
                    handle: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-contact'),
        elevation: 0,
        backgroundColor: AppColor.lightBlue,
        child: const Icon(Icons.add, size: 25, color: AppColor.secondary),
      ),
    );
  }
}
