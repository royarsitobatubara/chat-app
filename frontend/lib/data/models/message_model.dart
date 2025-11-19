class MessageModel {
  final String? id;
  final String message;
  final String from;
  final String to;
  final String? type;
  final bool isRead;
  final String time;

  MessageModel({
    this.id,
    required this.message,
    required this.from,
    required this.to,
    this.type,
    required this.isRead,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] != null ? json['id'] as String : null,
      message: json['message'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'from': from,
      'to': to,
      'type': type ?? 'text',
      'isRead': isRead==true? 1 : 0,
      'time': time,
    };
  }
}
