// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/presentation/widgets/buttons/icon_custom_button.dart';
import 'package:app/presentation/widgets/buttons/new_message_button.dart';
import 'package:app/presentation/widgets/drawer_custom.dart';
import 'package:app/presentation/widgets/textfields/search_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final int _msgCount = 10;
  bool _isSearch = false;
  final List<Map<String, dynamic>> _listItemDrawer = [
    {'label': 'profile', 'icon': Icons.person, 'router': ''},
    {
      'label': 'contacts',
      'icon': Icons.contact_emergency_outlined,
      'router': '/contacts',
    },
    {'label': 'settings', 'icon': Icons.settings, 'router': ''},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColor.primary,
      drawer: DrawerCustom(
        listItemDrawer: _listItemDrawer,
        keyDrawer: _globalKey,
      ),
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
                  IconCustomButton(
                    icon: Icons.menu,
                    handle: () => _globalKey.currentState!.openDrawer(),
                  ),
                  IconCustomButton(
                    icon: _isSearch ? Icons.close : Icons.search,
                    handle: () => setState(() => _isSearch = !_isSearch),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // SEARCH FIELD
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _isSearch
                    ? Column(
                        children: <Widget>[
                          SearchField(controller: _searchCtrl),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              // INBOX AND COUNT MESSAGE
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "inbox".tr(),
                    style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "($_msgCount ${"messages".tr()})",
                    style: const TextStyle(
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
