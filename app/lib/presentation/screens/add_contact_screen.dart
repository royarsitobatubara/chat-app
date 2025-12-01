import 'dart:async';

import 'package:app/core/constants/app_color.dart';
import 'package:app/core/helper/api_response.dart';
import 'package:app/data/database/user_db_service.dart';
import 'package:app/data/models/user_model.dart';
import 'package:app/data/services/user_service.dart';
import 'package:app/presentation/widgets/alert/message_alert.dart';
import 'package:app/presentation/widgets/app_bar_custom.dart';
import 'package:app/presentation/widgets/buttons/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _inputCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  List<UserModel> _userList = <UserModel>[];
  UserModel? _userSelected;
  bool _isExists = true;
  bool _isLoading = false;
  bool _isLoadingAdd = false;
  bool _isError = true;
  String _msg = '';
  Timer? _debounce;

  Future<void> onChangeInput(String e) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final ApiResponse res = await searchUser(e);

      if (res.success == false || res.data == null) {
        setState(() {
          _isExists = false;
          _userList = <UserModel>[];
          _isLoading = false;
        });
        return;
      }

      final List<UserModel> users = (res.data as List<dynamic>)
          .map((dynamic json) => UserModel.fromJson(json))
          .toList();

      setState(() {
        _isExists = users.isNotEmpty;
        _userList = users;
        _isLoading = false;
      });
    });
  }

  Future<void> onAddContact() async {
    if (_userSelected == null) {
      setState(() {
        _isError = true;
        _msg = "user_not_found";
      });
      _clearMsg();
      return;
    }
    setState(() => _isLoadingAdd = true);
    final bool user = await UserDbService.addUser(_userSelected!);
    if (user == false) {
      setState(() {
        _isError = true;
        _msg = "failed_saving_user";
      });
      _clearMsg();
    }
  }

  Future<void> _clearMsg() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _msg = "";
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: const AppBarCustom(title: 'add_contact'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'enter_email_or_id_person'.tr(),
                      style: const TextStyle(
                        color: AppColor.mediumBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // INPUT FIELD
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _inputCtrl,
                      autofocus: true,
                      onChanged: (String? e) => onChangeInput(e!),
                      style: const TextStyle(color: AppColor.white),
                      decoration: InputDecoration(
                        hintText: 'type_here'.tr(),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: AppColor.secondary,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColor.mediumBlue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isExists == true || _inputCtrl.text.isEmpty
                                ? AppColor.lightBlue
                                : Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (_isLoading == true)
                          const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              color: AppColor.lightBlue,
                              strokeWidth: 2,
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (_inputCtrl.text.isNotEmpty)
                          Text(
                            _isExists
                                ? 'user_is_found'.tr()
                                : 'user_not_found'.tr(),
                            style: TextStyle(
                              color: _isExists
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'enter_name'.tr(),
                      style: const TextStyle(
                        color: AppColor.mediumBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAME FIELD
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: AppColor.white),
                      decoration: InputDecoration(
                        hintText: 'type_here'.tr(),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: AppColor.secondary,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColor.mediumBlue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColor.lightBlue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_msg.trim().isNotEmpty)
                    MessageAlert(isError: _isError, message: _msg),

                  const Spacer(),

                  // BUTTON SUBMIT
                  SubmitButton(
                    loading: _isLoadingAdd,
                    text: 'add_contact',
                    handle: onAddContact,
                  ),
                ],
              ),
            ),
            if (_userList.isNotEmpty)
              Positioned(
                top: 140,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.mediumBlue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .5),
                        blurRadius: 10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UserModel user = _userList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColor.lightBlue,
                          child: Text(user.username[0]),
                        ),
                        title: Text(user.email),
                        subtitle: Text(user.username),
                        onTap: () {
                          setState(() {
                            _userList = <UserModel>[];
                            _nameCtrl.text = user.username;
                            _inputCtrl.text = user.email;
                            setState(() {
                              _userSelected = user;
                            });
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
