import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/utils/app_logger.dart';
import 'package:frontend/data/databases/contact_db_service.dart';
import 'package:frontend/data/models/contact_model.dart';
import 'package:frontend/data/preferences/user_preferences.dart';
import 'package:frontend/data/services/contact_service.dart';
import 'package:frontend/data/services/user_service.dart';
import 'package:frontend/presentation/widgets/app_bar_custom.dart';
import 'package:frontend/presentation/widgets/user_item.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String? _message;
  List<dynamic> _userList = [];
  List<ContactModel> _contactList = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    getAllContact();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> getAllContact() async {
    try {
      final emailFrom = await UserPreferences.getEmail();
      final contactFromDB = await ContactDbService.getAllContact(
        email: emailFrom,
      );
      if (mounted) {
        setState(() {
          _contactList = contactFromDB;
        });
      }
      AppLogger.info('data : $contactFromDB');
    } catch (e) {
      _showMessage('Failed to load contacts: $e');
    }
  }

  Future<void> searchHandle() async {
    final keyword = _searchCtrl.text.trim();

    if (keyword.isEmpty) {
      _showMessage('Please enter a search keyword');
      return;
    }

    setState(() {
      _isSearching = true;
      _message = null;
    });

    try {
      final emailFrom = await UserPreferences.getEmail();
      final data = await UserService().getUserByKeyword(keyword: keyword);

      if (mounted) {
        // Filter user yang bukan email sendiri
        final filteredUsers = (data.data ?? [])
            .where((user) => user['email'] != emailFrom)
            .toList();

        setState(() {
          _userList = filteredUsers;
          _isSearching = false;
          if (_userList.isEmpty) {
            _message = 'No users found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _userList = [];
        });
        _showMessage('Search failed: $e');
      }
    }
  }

  Future<void> addContactHandle({
    required String emailTo,
    String? id,
    required bool isAdded,
  }) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // DELETE contact
      if (isAdded && id != null) {
        final data = await ContactService().deleteContactById(id: id);
        _showMessage(data.message ?? 'Contact removed');
      }
      // ADD contact
      else {
        final emailFrom = await UserPreferences.getEmail();
        final data = await ContactService().addContact(
          emailFrom: emailFrom,
          emailTo: emailTo,
        );
        _showMessage(data.message ?? 'Contact added');
      }

      // Refresh contact list
      await getAllContact();
    } catch (e) {
      _showMessage('Operation failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      setState(() {
        _message = message;
      });

      // Auto clear message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _message = null;
          });
        }
      });

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.blue2,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _searchCtrl.clear();
      _userList = [];
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarCustom(nameScreen: 'Add Contact'),

            Expanded(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: AppColors.blue2.withValues(alpha: .09),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Search Input
                        _buildSearchInput(),

                        const SizedBox(height: 20),

                        // Result Info
                        _buildResultInfo(),

                        const SizedBox(height: 16),

                        // User List
                        Expanded(child: _buildUserList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Search Button
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
          boxShadow: [
            BoxShadow(
              color: AppColors.blue2.withValues(alpha: .15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Search by name or email...",
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: .5),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.white.withValues(alpha: .7),
              size: 24,
            ),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.white.withValues(alpha: .6),
                    ),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: (value) => setState(() {}),
          onSubmitted: (value) => searchHandle(),
        ),
      ),
    );
  }

  Widget _buildResultInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isSearching
                ? "Searching..."
                : "${_userList.length} user${_userList.length != 1 ? 's' : ''} found",
            style: TextStyle(
              color: Colors.white.withValues(alpha: .7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_message != null)
            Flexible(
              child: Text(
                _message!,
                style: TextStyle(
                  color: AppColors.blue2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator(color: AppColors.blue2));
    }

    if (_userList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: .3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchCtrl.text.isEmpty
                  ? "Enter a keyword to search"
                  : "No users found",
              style: TextStyle(
                color: Colors.white.withValues(alpha: .5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        final user = _userList[index];
        final email = user['email']?.toString() ?? '';
        final username = user['username']?.toString() ?? 'Unknown';

        final isAdded = _contactList.any((itm) => itm.emailTo == email);
        final contactId = isAdded
            ? _contactList.firstWhere((itm) => itm.emailTo == email).id
            : null;

        return UserItem(
          username: username,
          email: email,
          colorAvatar: AppColors.blue1,
          handle: () {
            if (!_isLoading) {
              addContactHandle(emailTo: email, id: contactId, isAdded: isAdded);
            }
          },
          isAdded: isAdded,
        );
      },
    );
  }

  Widget _buildSearchButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .1), width: 1),
        ),
      ),
      child: Container(
        width: double.infinity,
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
            onTap: _isSearching ? null : searchHandle,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: _isSearching
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
