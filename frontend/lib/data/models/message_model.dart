class MessageModel {
  final String? id;
  final String message;
  final String sender;
  final String receiver;
  final String? type;
  final bool isRead;
  final String time;

  MessageModel({
    this.id,
    required this.message,
    required this.sender,
    required this.receiver,
    this.type,
    required this.isRead,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] != null ? json['id'] as String : null,
      message: json['message'] as String,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'type': type ?? 'text',
      'isRead': isRead==true? 1 : 0,
      'time': time,
    };
  }
}
