import 'package:logger/logger.dart';

class AppLogger {
  static final _log = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      lineLength: 80,
      errorMethodCount: 5,
      methodCount: 2,
    ),
  );

  static void info(String message) => _log.i(message);

  static void error(String message, [Object? error, StackTrace? stack]) =>
      _log.e(message, error: error, stackTrace: stack);

  static void warn(String message) => _log.w(message);
}
