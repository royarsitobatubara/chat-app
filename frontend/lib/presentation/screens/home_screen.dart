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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // TOP APPBAR CUSTOM
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  gradientIconButton(
                    icon: Icons.menu_rounded,
                    onPressed: () {},
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
}
