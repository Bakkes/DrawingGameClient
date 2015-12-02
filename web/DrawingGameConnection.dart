import 'dart:html';
import 'DrawingGame.dart';
import 'dart:convert';
import 'dart:collection';
import 'OpCode.dart';
import 'Figure.dart';
import 'Game.dart';
import 'package:exportable/exportable.dart';

typedef void OnSocketMessage(int opCode, var data);

class DrawingGameConnection {
  String host = "127.0.0.1";
  int port = 4444;
  WebSocket webSocket;
  DrawingGame drawingGame;
  Game game;
  HashMap<int, List<OnSocketMessage>> events;

  DrawingGameConnection(this.game, [openCB(event)])
  {
    String hash = window.location.hash;
    if(hash != null && hash.length > 0) { //debugging purposes only, might even be XSS injectable?
      host = hash.substring(1);
      print(host);
    }
    events = new HashMap<int, List<OnSocketMessage>>();
    webSocket = new WebSocket("ws://" + host + ":" + port.toString() + "/");
    webSocket.onOpen.listen(openCB);
    webSocket.onMessage.listen(messageReceived);
  }

  void setDrawingGame(DrawingGame drawingGame) {
    this.drawingGame = drawingGame;
  }

  void registerEvent(int opCode, OnSocketMessage callback) {
    if(!this.events.containsKey(opCode)) {
      this.events[opCode] = new List<OnSocketMessage>();
    }
    this.events[opCode].add(callback);
  }


  void _send(data) {
    if(webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(data);
    } else {
      print("Could not send data");
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
    int opCode = json["MessageID"];
    //print(json);
    switch(opCode) {
      case OpCode.RECV_PONG: //pong
        break;
      case OpCode.RECV_ROOM_LIST: //list of rooms
        print(json);
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
      case OpCode.RECV_UNDO:
        drawingGame.undoLast(json["Data"]["steps"]);
        break;
      case OpCode.RECV_TURN:
        drawingGame.allowInput(json["Data"]["Turn"]);
        break;
      case OpCode.RECV_CLEAR:
        drawingGame.clear();
        break;
      case OpCode.RECV_REDO:
        drawingGame.redo();
        break;
    }

    if(this.events.containsKey(opCode)) {
      for(int i = 0; i < this.events[opCode].length; i++) {
        this.events[opCode][i](opCode, json["Data"]);
      }
    }
  }

  void joinRoom(int roomID) {
    this.sendJSON(OpCode.SEND_JOIN_ROOM, {"ID": roomID});
  }

}