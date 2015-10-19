import 'dart:html';
import 'CanvasMouseInput.dart';
import 'Figure.dart';
import 'OpCode.dart';
import 'DrawingGameConnection.dart';

class DrawingGame {
  static const int CANVAS_WIDTH = 100;
  static const int CANVAS_HEIGHT = 100;


  bool _allowDrawing = false;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  DrawingGameConnection conn;
  CanvasMouseInput input;
  List<Figure> _figures = [];

  DrawingGame(this.canvas) {
    this.ctx = canvas.getContext("2d");
    this.input = new CanvasMouseInput(this.canvas, this);
    this._allowDrawing = true;
    this.reset();
    conn = new DrawingGameConnection(this);
  }

  void onReady() {
    this.reset();
    conn.joinRoom(0);
  }

  void reset() {
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
  }

  bool canDraw() => this._allowDrawing;

  void allowInput(bool canDraw) {
    this._allowDrawing = canDraw;
  }
}