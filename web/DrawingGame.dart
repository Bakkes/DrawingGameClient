import 'dart:html';
import 'dart:collection';
import 'CanvasMouseInput.dart';
import 'Figure.dart';
import 'OpCode.dart';
import 'DrawingGameConnection.dart';
import 'package:exportable/exportable.dart';

class DrawingGame {


  bool _allowDrawing = false;

  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  DrawingGameConnection conn;
  CanvasMouseInput input;
  List<Figure> _figures = [];
  Queue<int> figureSteps = new Queue<int>();
  Queue<List<Figure>> redoStack = new Queue<List<Figure>>();

  DrawingGame(this.canvas, this.ctx, this.conn) {
    this.input = new CanvasMouseInput(this.canvas, this);
    this._allowDrawing = false;
    conn.registerEvent(OpCode.RECV_FIGURE, onMessageReceived);
    conn.registerEvent(OpCode.RECV_UNDO, onMessageReceived);
    conn.registerEvent(OpCode.RECV_REDO, onMessageReceived);
    conn.registerEvent(OpCode.RECV_TURN, onMessageReceived);
    conn.registerEvent(OpCode.RECV_RESET, onMessageReceived);
    conn.registerEvent(OpCode.RECV_DRAW_QUEUE_INFO, onMessageReceived);
    this.reset();
  }

  void destroy() {//make something better for this
    conn.unregisterEvent(OpCode.RECV_FIGURE, onMessageReceived);
    conn.unregisterEvent(OpCode.RECV_UNDO, onMessageReceived);
    conn.unregisterEvent(OpCode.RECV_REDO, onMessageReceived);
    conn.unregisterEvent(OpCode.RECV_TURN, onMessageReceived);
    conn.unregisterEvent(OpCode.RECV_RESET, onMessageReceived);
    conn.unregisterEvent(OpCode.RECV_DRAW_QUEUE_INFO, onMessageReceived);
    this.input.unregister();
  }

  void undoLast(int steps) {
    if(steps >= _figures.length) { //prevent malicious packets where steps > length of figures
      redoStack.add(_figures);
      _figures = [];
    } else {
      var listt = _figures.getRange(_figures.length - steps, _figures.length).toList();
      redoStack.addLast(listt);
      _figures.removeRange(_figures.length - steps, _figures.length);
    }
    if(_allowDrawing) {
      conn.sendJSON(OpCode.SEND_UNDO, {"steps": steps});
    }

    this.redraw();
  }

  void redo() {
    if(redoStack.isEmpty) {
      return;
    }

    List<Figure> redoFigures = redoStack.removeLast();
    _figures.addAll(redoFigures);
    figureSteps.addLast(redoFigures.length);
    redraw();

    if(_allowDrawing) {
      conn.sendJSON(OpCode.SEND_REDO, null);
    }
  }

  void onReady() {
    this.reset();
    conn.sendJSON(OpCode.SEND_LIST_ROOMS, null);
    conn.joinRoom(0);
  }

  void reset() {
    if(_allowDrawing) {
      conn.sendJSON(OpCode.SEND_RESET, null);
    }
    this.redoStack.clear();
    this._figures = [];
    redoStack.clear();
    figureSteps.clear();
    this.ctx.lineJoin = ctx.lineCap = 'round';
    this.clear();
  }

  void clear() {
    ctx..fillStyle = "white"
      ..fillRect(0, 0, canvas.width, canvas.height);
  }

  void redraw() {
    this.clear();
    for(int i = 0; i < _figures.length; i++) {
      _figures[i].draw(ctx);
    }
  }

  void addFigure(Figure figure) {
    this._figures.add(figure);
    figure.draw(this.ctx);
    if(_allowDrawing) {
      conn.send(OpCode.SEND_FIGURE, figure);
    }
    redoStack.clear();
  }

  bool canDraw() => this._allowDrawing;

  void allowInput(bool canDraw) {
    this._allowDrawing = canDraw;
  }

  void enqueue() {
    conn.sendJSON(OpCode.SEND_ENQUEUE_DRAW_QUEUE, null);
  }

  void onMessageReceived(int opCode, var data) {
    switch(opCode) {
      case OpCode.RECV_FIGURE:
        var figure;
        switch(data["id"]) {
          case 0: //dot
            figure = new Exportable(Dot, data);
            break;
          case 1: //stroke
            figure = new Exportable(Stroke, data);
            break;
        }
        addFigure(figure);
        break;
      case OpCode.RECV_UNDO:
        undoLast(data["steps"]);
        break;
      case OpCode.RECV_REDO:
        redo();
        break;
      case OpCode.RECV_RESET:
        reset();
        break;
      case OpCode.RECV_TURN:
        allowInput(data["Turn"]);
        break;
      case OpCode.RECV_DRAW_QUEUE_INFO:
        var queueHtml = querySelector("#drawingqueue");
        String newHtml = "";
        for(int i = 0; i < data["Queue"].length; i++) {
          var player = data["Queue"][i];
          newHtml += "<i>";
          newHtml += "[" + (player["Turn"] + 1).toString() + "]" + player["Name"];
          newHtml += "</i>\n";
        }
        queueHtml.innerHtml = newHtml;
        allowInput(data["MyTurn"] == 0);
        break;
    }
  }
}