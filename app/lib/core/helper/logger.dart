import 'dart:developer' as dev;

class Logger {
  Logger._();

  static void info(String message) {
    dev.log(message, name: 'INFO', level: 0);
  }

  static void warning(String message) {
    dev.log(message, name: 'WARNING', level: 1);
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    dev.log(message, name: 'ERROR', level: 2, error: error, stackTrace: stack);
  }

}
