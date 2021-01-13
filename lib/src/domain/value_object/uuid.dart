import 'package:uuid/uuid.dart' as uuid_lib;

var uuid = uuid_lib.Uuid();

class Uuid {
  static String random() {
    return uuid.v4();
  }
}
