import 'dart:html';
import 'DrawingGameConnection.dart';
import 'OpCode.dart';
import 'Messages.dart';
import 'package:exportable/exportable.dart';


class Chat {

  DrawingGameConnection conn;

  Chat(DrawingGameConnection this.conn) {
    querySelector("#chatsubmit").addEventListener('click', buttonClicked);
    querySelector("#chattext").addEventListener('onkeydown', keyDown);
    this.conn.registerEvent(OpCode.RECV_SAY, onChatMessage);
  }

  void buttonClicked(MouseEvent event) {
    sendMessage();
  }

  void keyDown(KeyEvent event) {
    if(event.keyCode == KeyCode.ENTER) {
      sendMessage();
    }
  }

  void sendMessage()
  {
    String text = querySelector("#chattext").value;
    querySelector("#chattext").value = "";

    ChatMessage chatMessage = new ChatMessage.fromData(text);
    conn.send(OpCode.SEND_SAY, chatMessage);
    addMessage(chatMessage);
  }

  void onChatMessage(int opCode, var json)
  {
    if(opCode == OpCode.RECV_SAY)
    {
      var msg = new Exportable(ChatMessage, json);//new ChatMessage()..initFromJson(json);
      addMessage(msg);
    }
  }

  void addMessage(ChatMessage message)
  {
    var html = "<div class='msgln'>(" + message.timestamp.toString() + ") <b>" + message.author + "</b>: " + message.text + "<br></div>";
    querySelector("#chatbox").appendHtml(html);
  }
}