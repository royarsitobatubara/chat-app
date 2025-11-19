import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/widgets/user_item.dart';
import 'package:go_router/go_router.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<dynamic> _userList = [];

  Future<void> searchHandle() async {
    if (_searchCtrl.text.trim().isEmpty) {
      return;
    }
    final data = await UserService().getUserByKeyword(
      keyword: _searchCtrl.text,
    );
    setState(() {
      _userList = data.data ?? [];
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar dengan gradient
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Back Button dengan gradient & shadow
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue1,
                          AppColors.blue2,
                          AppColors.blue3,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue2.withValues(alpha: .3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title dengan gradient
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.blue1,
                          AppColors.blue2,
                          AppColors.blue3,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Add Contact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Field dengan gradient border
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search by name or email...",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: .5),
                        fontSize: 15,
                      ),
                      prefixIcon: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [AppColors.blue1, AppColors.blue2],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Colors.white.withValues(alpha: .6),
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchCtrl.clear();
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Result Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${_userList.length} users found",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User List
            Expanded(
              child: _userList.isEmpty
                  ? const Center(
                      child: Text(
                        "Is empty",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _userList.length,
                      itemBuilder: (context, index) {
                        final user = _userList[index];
                        return UserItem(
                          username: user['username'],
                          email: user['email'],
                          colorAvatar: AppColors.blue1,
                        );
                      },
                    ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: .1),
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue1, AppColors.blue2, AppColors.blue3],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () => searchHandle(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
