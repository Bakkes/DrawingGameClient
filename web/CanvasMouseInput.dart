import 'dart:html';
import 'dart:collection';
import 'DrawingGame.dart';
import 'Figure.dart';
import 'dart:js' as js;

class CanvasMouseInput {
  int lastX, lastY;
  int currentX, currentY;
  String lastColor = "black";
  String currentColor = "black";
  int currentSize = 5;
  String currentFigure = "line"; //pencil, line, circle

  int currentSteps = 0;


  DrawingGame game;
  CanvasElement canvas;
  int width, height;
  bool isMouseDown = false;

  CanvasMouseInput(CanvasElement this.canvas, DrawingGame this.game) {
    this.width = canvas.width;
    this.height = canvas.height;
    js.context['changeColor'] = colorChanged;//quick hack mebe

    querySelector("#control_undo").onClick.listen(undoLastStep);
    querySelector("#control_redo").onClick.listen(redoLastStep);
    querySelector("#control_pencil").onClick.listen(selectPencil);
    querySelector("#control_eraser").onClick.listen(selectEraser);
    querySelector("#control_enqueue").onClick.listen(enqueue);
    querySelector("#control_clear").onClick.listen(clear);
    //querySelector("#colorr").colorpicker().on['changeColor'].listen(colorChanged);
    //querySelector("#control_pencil").addEventListener('onclick', pencilClicked);
    //querySelector("#control_eraser").addEventListener('onclick', eraserClicked);
    /*querySelector("#control_pencil").addEventListener('onclick', pencilClicked);
    querySelector("#control_pencil").addEventListener('onclick', pencilClicked);
    querySelector("#control_pencil").addEventListener('onclick', pencilClicked);*/

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
    //add change register things?
  }

  void mouseMoved(MouseEvent event) {
    if(this.isMouseDown) {
      this.lastX = currentX;
      this.lastY = currentY;
      this.currentX = event.client.x - canvas.offsetLeft;
      this.currentY = event.client.y - canvas.offsetTop;
      this.game.addFigure(new Stroke.Data(lastX, lastY, currentX, currentY, currentColor, currentSize));
      currentSteps++;
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
    currentSteps++;
  }

  void mouseUp(MouseEvent event) {
    isMouseDown = false;
    this.game.figureSteps.addLast(currentSteps);
    currentSteps = 0;
  }

  void mouseOut(MouseEvent event) {
    if(isMouseDown) {
      isMouseDown = false;
      this.game.figureSteps.addLast(currentSteps);
      currentSteps = 0;
    }
  }

  void selectPencil(MouseEvent event) {
    currentColor = lastColor;
  }

  void selectEraser(MouseEvent event) {
    lastColor = currentColor;
    currentColor = "white";
  }

  void undoLastStep(MouseEvent event) {
    if(!game.canDraw()) {
      return;
    }
    if(game.figureSteps.isEmpty) {
      return;
    }
    int last = game.figureSteps.removeLast();
    this.game.undoLast(last);
  }

  void redoLastStep(MouseEvent event) {
    if(!game.canDraw()) {
      return;
    }
    game.redo();
  }

  void colorChanged(var color) {
    currentColor = color;
  }

  void clear(MouseEvent event) {
    if(!game.canDraw()) {
      return;
    }
    game.reset();
  }

  void enqueue(MouseEvent event) {
    game.enqueue();
  }

  void controlClicked(MouseEvent event) {
    //switch(event.)
  }
}