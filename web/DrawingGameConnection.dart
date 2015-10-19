import 'dart:html';
import 'DrawingGame.dart';
import 'dart:convert';
import 'OpCode.dart';
import 'Figure.dart';
import 'package:exportable/exportable.dart';

class DrawingGameConnection {
  String host = "127.0.0.1";
  int port = 4444;
  WebSocket webSocket;
  DrawingGame drawingGame;

  DrawingGameConnection(this.drawingGame)
  {
    webSocket = new WebSocket("ws://" + host + ":" + port.toString() + "/");
    webSocket.onOpen.listen(onOpen);
    webSocket.onMessage.listen(messageReceived);
  }

  void onOpen(event) {
    drawingGame.onReady();
  }

  void _send(data) {
    if(webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(data);
    } else {
      Console.error("Could not send data");
    }
  }

  void sendJSON(int opcode, var data) {
    _send(JSON.encode({"MessageID": opcode, "Data": JSON.encode(data)}));
  }

  void send(int opcode, var data) {
    _send(JSON.encode({"MessageID": opcode, "Data": data.toJson()}));
  }

  void messageReceived(MessageEvent event) {
    var data = event.data;
    var json = JSON.decode(data);
    print(json);
    switch(json["MessageID"]) {
      case OpCode.RECV_PONG: //pong
        break;
      case OpCode.RECV_ROOM_LIST: //list of rooms
        break;
      case OpCode.RECV_JOIN_ROOM_RESULT: //room joined
        break;
      case OpCode.RECV_SAY: //chat message
        break;
      case OpCode.RECV_FIGURE:
        var figure;
        switch(json["Data"]["id"]) {
          case 0: //dot
            figure = new Exportable(Dot, json["Data"]);
            break;
          case 1: //stroke
            figure = new Exportable(Stroke, json["Data"]);
            break;
        }
        drawingGame.addFigure(figure);
        break;
    }
  }

  void joinRoom(int roomID) {
    this.sendJSON(OpCode.SEND_JOIN_ROOM, {"ID": roomID});
  }

}