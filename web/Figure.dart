import 'dart:html';
import 'package:exportable/exportable.dart';

abstract class Figure {
  void draw(CanvasRenderingContext2D ctx);
}

@export
class Dot extends Object with Exportable implements Figure {
  @export int id = 0;
  @export int x;
  @export int y;
  @export String color;
  @export int size;

  Dot.Data(this.x, this.y, this.color, this.size);
  Dot.FromEmpty();
  Dot();

  void draw(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.fillStyle = color;
    ctx.fillRect(x, y, size, size);
    ctx.closePath();
    ctx.stroke();
  }
}

@export
class Stroke extends Object with Exportable implements Figure {
  @export int id = 1;
  @export int startX;
  @export int startY;
  @export int endX;
  @export int endY;
  @export String color;
  @export int width;

  Stroke.Data(this.startX, this.startY, this.endX, this.endY, this.color, this.width);
  Stroke.FromEmpty();
  Stroke();

  void draw(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    ctx.strokeStyle = color;
    ctx.lineWidth = width;
    ctx.closePath();
    ctx.stroke();
  }
}

class FigureFactory {
  static Figure CreateFigure(String figureName, int startX, int startY, int endX, int endY, int color, int size) {
    switch(figureName) {
      case "line":
        break;

    }
  }

}