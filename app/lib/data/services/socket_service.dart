import 'package:app/core/constants/app_endpoint.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  static void connect() {
    socket = IO.io(
      AppEndpoint.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();
  }

  static void registerUser(String email) {
    socket?.emit("user-register", email);
  }

  static void listenUserOnline(Function(List<String>) callback) {
    socket?.on("user-online-list", (data) {
      final List<String> users = List<String>.from(data);
      callback(users);
    });
  }

  static void disconnect() {
    socket?.disconnect();
  }
}
