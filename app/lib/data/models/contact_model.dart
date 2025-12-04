class ContactModel {
  final int? id;
  final String emailSender;
  final String emailReceiver;

  const ContactModel({
    this.id,
    required this.emailSender,
    required this.emailReceiver,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int?,
      emailSender: json['email_sender'] as String,
      emailReceiver: json['email_receiver'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email_sender': emailSender,
      'email_receiver': emailReceiver,
    };
  }
}
