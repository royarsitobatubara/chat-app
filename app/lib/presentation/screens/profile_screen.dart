// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/database/user_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/models/user_model.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String emailReceiver;
  const ProfileScreen({super.key, required this.emailReceiver});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  ContactModel? contact;
  final _actions = [
    {'icon': Icons.chat, 'handle': () {}},
    {'icon': Icons.edit, 'handle': () {}},
    {'icon': Icons.delete, 'handle': () {}},
  ];

  Future<void> getDataUser() async {
    final emailSender = await UserPreferences.getEmail();
    final userDB = await UserDbService.getUserByEmailReceiver(
      widget.emailReceiver,
    );
    final contactDB = await ContactDbService.getContactByEmails(
      emailSender,
      widget.emailReceiver,
    );
    if (contactDB != null) {
      setState(() {
        user = userDB;
        contact = contactDB;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: const AppBarCustom(title: 'profile'),
      body: SafeArea(
        child: contact == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.lightBlue),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  // USERNAME
                  Text(
                    contact!.name,
                    style: const TextStyle(
                      color: AppColor.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PHOTO PROFILE
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          AppColor.lightBlue,
                          AppColor.lightBlue,
                          AppColor.mediumBlue,
                        ],
                      ),
                    ),
                    child: Text(
                      contact!.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColor.secondary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // EMAIL
                  Text(
                    contact!.emailReceiver,
                    style: const TextStyle(
                      color: AppColor.lightBlue,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _actions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: InkWell(
                          onTap: () => action['handle'],
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: AppColor.lightBlue.withValues(alpha: .2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              action['icon'] as IconData,
                              color: AppColor.lightBlue,
                              size: 28,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }
}
