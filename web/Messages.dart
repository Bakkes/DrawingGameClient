import 'package:exportable/exportable.dart';

@export
class ChatMessage extends Object with Exportable {
  @export String author;
  @export num timestamp;
  @export String text;

  ChatMessage();

  ChatMessage.fromData(this.text) {
    this.author = "You";
    this.timestamp = new DateTime.now().millisecondsSinceEpoch;
  }
}