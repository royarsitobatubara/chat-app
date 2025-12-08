// ignore_for_file: always_specify_types

import 'package:app/data/database/message_db_service.dart';
import 'package:app/data/models/chat_preview.dart';
import 'package:flutter/material.dart';
import 'package:app/data/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  List<MessageModel> messages = [];
  List<ChatPreview> recentChats = [];
  String emailSender = '';
  String emailReceiver = '';

  // LOAD PESAN
  Future<void> getAllMessage() async {
    final data = await MessageDbService.getMessagesByEmails(
      email1: emailSender,
      email2: emailReceiver,
    );
    messages = data;
    notifyListeners();
  }

}
