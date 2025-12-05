// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/data/providers/contact_provider.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Map<String, dynamic>> _menu = [
    {
      'label': 'add_contact',
      'icon': Icons.person_add_alt_1_outlined,
      'route': '/add-contact',
    },
  ];

  Future<void> getAllContact() async {
    final emailSender = await UserPreferences.getEmail();
    if (!mounted) return;

    Provider.of<ContactProvider>(
      context,
      listen: false,
    ).getAllContacts(emailSender);
  }

  @override
  void initState() {
    super.initState();
    getAllContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: const AppBarCustom(title: 'Contacts'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('menu'.tr(), style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),

              // MENU LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menu.length,
                itemBuilder: (context, index) {
                  final item = _menu[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColor.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'],
                        color: AppColor.secondary,
                        size: 26,
                      ),
                    ),
                    title: Text(
                      item['label'].toString().tr(),
                      style: const TextStyle(
                        color: AppColor.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => context.push(item['route']),
                  );
                },
              ),

              const SizedBox(height: 25),

              // TOTAL CONTACT
              Consumer<ContactProvider>(
                builder: (context, prov, _) {
                  return Text(
                    '${prov.contacts.length} ${'contacts'.tr()}',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),

              const SizedBox(height: 10),

              // CONTACT LIST
              Expanded(
                child: Selector<ContactProvider, List<ContactModel>>(
                  selector: (context, prov) => prov.contacts,
                  builder: (context, contacts, _) {
                    if (contacts.isEmpty) {
                      return Center(
                        child: Text(
                          'contacts_is_empty'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];

                        return GestureDetector(
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
