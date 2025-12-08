// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/data/providers/contact_provider.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String emailReceiver;
  const ProfileScreen({super.key, required this.emailReceiver});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ContactModel? contact;

  Future<void> getDataUser() async {
    final emailSender = await UserPreferences.getEmail();
    final contactDB = await ContactDbService.getContactByEmails(
      emailSender,
      widget.emailReceiver,
    );
    if (contactDB != null) {
      setState(() {
        contact = contactDB;
      });
    }
  }

  void _loadData() async {
    final emailSender = await UserPreferences.getEmail();
    if (!mounted) return;
    Provider.of<ContactProvider>(
      context,
      listen: false,
    ).getContact(emailSender, widget.emailReceiver);
  }

  Future<void> handleDelete() async {
    final bool? result = await showConfirmDelete();
    if (result != true) return;

    final emailSender = await UserPreferences.getEmail();
    await ContactDbService.deleteContact(emailSender, widget.emailReceiver);

    if (!mounted) return;
    context.read<ContactProvider>().getAllContacts(emailSender);
    context.pop();
  }

  Future<bool?> showConfirmDelete() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'delete_profile'.tr(),
            style: const TextStyle(
              color: AppColor.lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'are_you_sure_to_delete_this_contact'.tr(),
            style: const TextStyle(color: AppColor.lightBlue),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: AppColor.lightBlue),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'delete'.tr(),
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.chat,
        'handle': () => context.push(
          '/chat',
          extra: {
            'emailSender': contact!.emailSender,
            'emailReceiver': widget.emailReceiver,
          },
        ),
      },
      {
        'icon': Icons.edit,
        'handle': () => context.push(
          '/edit-contact',
          extra: {
            'emailSender': contact!.emailSender,
            'emailReceiver': widget.emailReceiver,
          },
        ),
      },
      {'icon': Icons.delete, 'handle': handleDelete},
    ];
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
                  Selector<ContactProvider, ContactModel?>(
                    selector: (_, selector) => selector.contact,
                    builder: (_, data, _) {
                      if (data == null) {
                        return const Text(
                          'Guest',
                          style: TextStyle(
                            color: AppColor.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        );
                      }
                      return Text(
                        data.name,
                        style: const TextStyle(
                          color: AppColor.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // PHOTO PROFILE
                  Selector<ContactProvider, ContactModel?>(
                    selector: (_, selector) => selector.contact,
                    builder: (_, data, _) {
                      if (data == null) {
                        return Container(
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
                          child: const Text(
                            '?',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Container(
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
                          data.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColor.secondary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
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
                    children: actions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: InkWell(
                          onTap: action['handle'] as void Function(),
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
