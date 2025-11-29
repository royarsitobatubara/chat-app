class ApiResponse {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;
  final String? error;
  final String? timeStamp;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
    this.timeStamp,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'],
      error: json['error'],
      timeStamp: json['timeStamp'] ?? "",
    );
  }
}
