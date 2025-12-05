import 'package:app/data/database/contact_db_service.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  ContactModel? _contact;
  List<ContactModel> _contacts = <ContactModel>[];

  ContactModel get contact => _contact!;
  List<ContactModel> get contacts => _contacts;

  Future<void> getContact(String emailSender, String emailReceiver) async {
    final ContactModel? data = await ContactDbService.getContactByEmails(
      emailSender,
      emailReceiver,
    );
    _contact = data;
    notifyListeners();
  }

  Future<void> getAllContacts(String emailSender) async {
    final List<ContactModel> data = await ContactDbService.getAllContacts(
      emailSender,
    );
    _contacts = data;
    notifyListeners();
  }
}
