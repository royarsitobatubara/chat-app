class ContactModel {
  final int? id;
  final String name;
  final String emailSender;
  final String emailReceiver;

  const ContactModel({
    this.id,
    required this.name,
    required this.emailSender,
    required this.emailReceiver,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int?,
      name: json['name'],
      emailSender: json['email_sender'] as String,
      emailReceiver: json['email_receiver'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email_sender': emailSender,
      'email_receiver': emailReceiver,
    };
  }
}
