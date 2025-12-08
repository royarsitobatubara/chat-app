class ChatPreview {
  final String email;
  final String? name;
  final String message;
  final String status;
  final String time;

  ChatPreview({
    this.name,
    required this.email,
    required this.message,
    required this.status,
    required this.time,
  });
}
