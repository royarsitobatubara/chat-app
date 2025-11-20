class ContactModel {
  final String? id;
  final String emailFrom;
  final String emailTo;

  ContactModel({
    this.id,
    required this.emailFrom,
    required this.emailTo,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      emailFrom: json['email_from'] as String,
      emailTo: json['email_to'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email_from': emailFrom,
      'email_to': emailTo,
    };
  }
}
