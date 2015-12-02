import 'dart:html';
import 'dart:collection';
import 'CanvasMouseInput.dart';
import 'Figure.dart';
import 'OpCode.dart';
import 'DrawingGameConnection.dart';


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
    this.reset();
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
    this.redoStack.clear();
    this._figures = [];
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
}