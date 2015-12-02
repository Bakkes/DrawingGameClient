import 'dart:collection';

class Strings {
  static HashMap<num, String> TEXT = new HashMap<num, String>();

  static String getText(int code) {
    return TEXT[code];
  }

  static void loadText() {
    TEXT.clear();
    TEXT[2001] = "Room doesn't exist?";
    TEXT[2002] = "Room is full, select a different one";
  }
}