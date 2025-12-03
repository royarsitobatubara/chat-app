class ContactModel {
  final String? id;
  final String emailSender;
  final String emailReceiver;

  const ContactModel({
    this.id,
    required this.emailSender,
    required this.emailReceiver,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id']?.toString(),
      emailSender: json['email_sender'],
      emailReceiver: json['emailReceiver'],
    );
  }

  Map<String, String> toJson() {
    return <String, String>{
      'id': id as String,
      'emailSender': emailSender,
      'emailReceiver': emailReceiver,
    };
  }
}
