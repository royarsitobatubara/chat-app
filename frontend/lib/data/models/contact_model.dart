class ContactModel {
  final String id;
  final String emailFrom;
  final String emailTo;

  ContactModel({
    required this.id,
    required this.emailFrom,
    required this.emailTo,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      emailFrom: json['emailFrom'] as String,
      emailTo: json['emailTo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailFrom': emailFrom,
      'emailTo': emailTo,
    };
  }
}
