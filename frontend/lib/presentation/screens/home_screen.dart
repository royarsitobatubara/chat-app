import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/presentation/widgets/button_widget.dart';
import 'package:frontend/presentation/widgets/chat_item.dart';
import 'package:frontend/presentation/widgets/filter_chip_widget.dart';
import 'package:frontend/presentation/widgets/text_field_widget.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;
  bool _isSearch = false;
  final List<String> _filters = ['All', 'Unread', 'Groups'];
  final TextEditingController _searchCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _drawerButtonList = [
    {'icon': Icons.person_3_outlined, 'label': 'Account', 'route': '/account'},
    {'icon': Icons.settings, 'label': 'Setting', 'route': '/settings'},
    {
      'icon': Icons.notifications,
      'label': 'Notification',
      'route': '/notification',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primary,
      drawer: _drawerModern(),
      body: SafeArea(
        child: Column(
          children: [
            // TOP APPBAR CUSTOM
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Button Drawer
                  gradientIconButton(
                    icon: Icons.menu_rounded,
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  gradientIconButton(
                    icon: _isSearch ? Icons.close : Icons.search_rounded,
                    onPressed: () => setState(() => _isSearch = !_isSearch),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1, // muncul dari atas
                  child: child,
                );
              },
              child: _isSearch
                  ? Padding(
                      key: ValueKey(1),
                      padding: const EdgeInsets.all(20.0),
                      child: TextFieldWidget(
                        controller: _searchCtrl,
                        hintText: 'Search here...',
                        icon: Icons.search,
                      ),
                    )
                  : const SizedBox(key: ValueKey(2)),
            ),

            // HEADER INBOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppColors.blue1,
                            AppColors.blue2,
                            AppColors.blue3,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Inbox',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '24 new messages',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Notification Badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue1.withValues(alpha: .2),
                          AppColors.blue2.withValues(alpha: .2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.blue2.withValues(alpha: .3),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.blue1, AppColors.blue2],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FILTER BUTTON
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilter == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChipWidget(
                      label: _filters[index],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ACTION BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.add_circle_outline,
                      label: "New Message",
                      onPressed: () => context.push('/list-contact'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  squareActionButton(
                    icon: Icons.tune_rounded,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // CHAT LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.push(
                      '/chat',
                      extra: {'email_from': 's', 'email_to': 's'},
                    ),
                    child: ChatItem(
                      name: 'User ${index + 1}',
                      message: 'This is a sample message preview...',
                      time: '${index + 1}m ago',
                      unreadCount: index % 3 == 0 ? index + 1 : 0,
                      avatarColor: index % 3 == 0
                          ? AppColors.blue1
                          : index % 3 == 1
                          ? AppColors.blue2
                          : AppColors.blue3,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button dengan gradient
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue2.withValues(alpha: .4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/add-contact'),
            borderRadius: BorderRadius.circular(16),
            child: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  // Action Button
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue2.withValues(alpha: .3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerModern() {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.only(
              top: 100,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            color: AppColors.blue2.withValues(alpha: .09),
            child: Column(
              children: [
                // PROFILE
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.blue2.withValues(alpha: .5),
                        AppColors.blue3.withValues(alpha: .08),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .5),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // PHOTO PROFILE
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue2,
                        ),
                        child: Text(
                          'A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'someone@example.com',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // LIST NAVIGATION
                Expanded(
                  child: ListView.builder(
                    itemCount: _drawerButtonList.length,
                    itemBuilder: (context, index) {
                      final itm = _drawerButtonList[index];
                      return GestureDetector(
                        onTap: () => context.push(itm['route']),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .05),
                              width: 2,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.blue1.withValues(alpha: .5),
                                AppColors.blue3.withValues(alpha: .5),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(itm['icon'], color: Colors.white, size: 25),
                              const SizedBox(width: 10),
                              Text(
                                itm['label'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
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
      ),
    );
  }
}
