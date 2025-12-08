// ignore_for_file: always_specify_types

import 'package:app/core/constants/app_color.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:app/data/models/message_model.dart';
import 'package:app/data/providers/chat_provider.dart';
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
  final ScrollController _scrollCtrl = ScrollController();

  void adMessageHandle() async {
    if (_messageCtrl.text.isEmpty) return;
    _messageCtrl.clear();
  }

  @override
  void initState() {
    context.read<ChatProvider>().emailReceiver = widget.emailReceiver;
    context.read<ChatProvider>().emailSender = widget.emailSender;
    super.initState();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
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

        // PHOTO PROFILE
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
                child: Selector<ContactProvider, ContactModel?>(
                  selector: (_, prev) => prev.contact,
                  builder: (_, ContactModel? data, _) {
                    if (data == null) {
                      return const Text(
                        '?',
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
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

              // NAME AND STATUS ONLINE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Selector<ContactProvider, ContactModel?>(
                    selector: (_, prev) => prev.contact,
                    builder: (_, ContactModel? data, _) {
                      if (data == null) {
                        return const Text(
                          'Guest',
                          style: TextStyle(
                            color: AppColor.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        );
                      }
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
                child: Selector<ChatProvider, List<MessageModel>>(
                  selector: (_, prov) => prov.messages,
                  builder: (_, messages, _) {
                    return ListView.builder(
                      controller: _scrollCtrl,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final msg = messages[index];
                        final isMe = msg.emailSender == widget.emailSender;
                        return BubbleChat(
                          isMe: isMe,
                          message: msg.message,
                          name: widget.emailReceiver == msg.emailReceiver
                              ? 'a'
                              : 'You',
                        );
                      },
                    );
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
                    onTap: () => adMessageHandle(),
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
