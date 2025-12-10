class MessageModel {
  final String? id;
  final String emailSender;
  final String emailReceiver;
  final String message;
  final String type;
  final String status;
  final String time;

  MessageModel({
    this.id,
    required this.emailSender,
    required this.emailReceiver,
    required this.message,
    required this.type,
    required this.status,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      emailSender: json['emailSender'] as String,
      emailReceiver: json['emailReceiver'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, String>{
      'id': id!,
      'emailSender': emailSender,
      'emailReceiver': emailReceiver,
      'message': message,
      'type': type,
      'status': status,
      'time': time,
    };
  }
}
