import 'dart:html';
import 'DrawingGame.dart';
import 'Figure.dart';

class CanvasMouseInput {
  int lastX, lastY;
  int currentX, currentY;
  String currentColor = "black";
  int currentSize = 5;

  DrawingGame game;
  CanvasElement canvas;
  int width, height;
  bool isMouseDown = false;

  CanvasMouseInput(CanvasElement this.canvas, DrawingGame this.game) {
    this.width = canvas.width;
    this.height = canvas.height;

    canvas.addEventListener("mousemove", this.mouseMoved);
    canvas.addEventListener("mousedown", this.mouseDown);
    canvas.addEventListener("mouseup", this.mouseUp);
    canvas.addEventListener("mouseout", this.mouseOut);
  }

  void unregister() {
    canvas.removeEventListener("mousemove", this.mouseMoved);
    canvas.removeEventListener("mousedown", this.mouseDown);
    canvas.removeEventListener("mouseup", this.mouseUp);
    canvas.removeEventListener("mouseout", this.mouseOut);
  }

  void mouseMoved(MouseEvent event) {
    if(this.isMouseDown) {
      this.lastX = currentX;
      this.lastY = currentY;
      this.currentX = event.client.x - canvas.offsetLeft;
      this.currentY = event.client.y - canvas.offsetTop;
      this.game.addFigure(new Stroke.Data(lastX, lastY, currentX, currentY, currentColor, currentSize));
    }
  }

  void mouseDown(MouseEvent event) {
    if(!game.canDraw()) {
      return;
    }
    isMouseDown = true;

    this.lastX = currentX;
    this.lastY = currentY;
    this.currentX = event.client.x - canvas.offsetLeft;
    this.currentY = event.client.y - canvas.offsetTop;
    this.game.addFigure(new Dot.Data(currentX - (currentSize / 2).round(), currentY - (currentSize / 2).round(), currentColor, currentSize));
  }

  void mouseUp(MouseEvent event) {
    isMouseDown = false;
  }

  void mouseOut(MouseEvent event) {

  }
}