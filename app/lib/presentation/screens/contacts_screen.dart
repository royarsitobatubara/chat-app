// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ContactModel> _contacts = <ContactModel>[];
  final List<Map<String, dynamic>> _menu = [
    {
      'label': 'add_contact',
      'icon': Icons.person_add_alt_1_outlined,
      'route': '/add-contact',
    },
  ];

  Future<void> getAllContact() async {
    final String emailSender = await UserPreferences.getEmail();
    final List<ContactModel> data = await ContactDbService.getAllContacts(
      emailSender,
    );
    if (data.isNotEmpty) {
      setState(() {
        _contacts = data;
      });
    }
  }

  @override
  void initState() {
    getAllContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'Contacts'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // DAFTAR BUTTON
              Text('menu'.tr(), style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),

              // MANY CONTACTS
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menu.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> itm = _menu[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColor.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        itm['icon'],
                        color: AppColor.secondary,
                        size: 26,
                      ),
                    ),
                    title: Text(
                      itm['label'.tr()],
                      style: const TextStyle(
                        color: AppColor.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => context.push(itm['route']),
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                '${_contacts.length} ${'contacts'.tr()}',
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 10),

              // LIST USER
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ContactModel contact = _contacts[index];

                    return _contacts.isEmpty
                        ? Center(
                            child: Text(
                              'contacts_is_empty'.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => context.push(
                              '/profile',
                              extra: contact.emailReceiver,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    AppColor.mediumBlue.withValues(alpha: .9),
                                    AppColor.mediumBlue.withValues(alpha: .15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 48,
                                    height: 48,
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
                                      contact.emailReceiver[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColor.secondary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          contact.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          contact.emailReceiver,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
