import 'package:app/core/constants/app_color.dart';
import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/preferences/user_preferences.dart';
import 'package:app/data/providers/contact_provider.dart';
import 'package:app/presentation/widgets/bubble_chat.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String emailSender;
  final String emailReceiver;
  const ChatScreen({
    super.key,
    required this.emailSender,
    required this.emailReceiver,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageCtrl = TextEditingController();
  ContactModel? _contact;
  Future<void> getDataUser() async {
    final emailSender = await UserPreferences.getEmail();
    final contactDB = await ContactDbService.getContactByEmails(
      emailSender,
      widget.emailReceiver,
    );
    if (contactDB != null) {
      setState(() {
        _contact = contactDB;
      });
    }
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.lightBlue,
          ),
        ),
        title: GestureDetector(
          onTap: () => context.push('/profile', extra: widget.emailReceiver),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
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
                child: Selector<ContactProvider, ContactModel>(
                  // ignore: always_specify_types
                  selector: (_, prev) => prev.contact,
                  builder: (_, ContactModel data, _) {
                    return Text(
                      data.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColor.secondary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Selector<ContactProvider, ContactModel>(
                    // ignore: always_specify_types
                    selector: (_, prev) => prev.contact,
                    builder: (_, ContactModel data, _) {
                      return Text(
                        data.name,
                        style: const TextStyle(
                          color: AppColor.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                  Text(
                    "online".tr(),
                    style: const TextStyle(
                      color: AppColor.lightBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // CHAT LIST
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return BubbleChat(isMe: true, message: 'nigga $index');
                  },
                ),
              ),
            ),

            // SEND MESSAGE
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                border: Border(
                  top: BorderSide(color: AppColor.secondary, width: 1),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: <Widget>[
                  // TEXTFIELD
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColor.mediumBlue.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'type_message'.tr(),
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // SEND BUTTON
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColor.lightBlue,
                            AppColor.mediumBlue,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: AppColor.secondary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
