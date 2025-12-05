import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String emailSender;
  final String emailReceiver;
  const ChatScreen({
    super.key,
    required this.emailSender,
    required this.emailReceiver,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
