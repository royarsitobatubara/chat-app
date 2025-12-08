import 'package:uuid/uuid.dart';

class GenerateId {
  static final Uuid _uuid = Uuid();  

  static String generate() {
    return _uuid.v4();
  }
}
