import 'package:app/core/constants/app_color.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      appBar: AppBarCustom(title: 'Contacts'),
      backgroundColor: AppColor.primary,
      body: SafeArea(child: Column(children: <Widget>[])),
    );
  }
}
