import "package:uuid/uuid.dart";

String generateUUID() {
  return Uuid().v4();
}