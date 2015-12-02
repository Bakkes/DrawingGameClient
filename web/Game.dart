import 'Chat.dart';
import 'dart:html';
import 'DrawingGame.dart';
import 'DrawingGameConnection.dart';
import 'MainMenu.dart';

class Game {
  static const int CANVAS_WIDTH = 100;
  static const int CANVAS_HEIGHT = 100;

  num activeState = 0;//0 main menu, 1 game

  Chat chat;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  DrawingGameConnection conn;
  DrawingGame drawingGame;
  MainMenu mainMenu;

  Game(this.canvas) {
    this.ctx = canvas.getContext("2d");
    this.conn = new DrawingGameConnection(this, onReady);
    //drawingGame.onReady(); //add this somewhere
  }

  void onReady(event) {
    this.mainMenu = new MainMenu(this.conn, this.canvas, this.ctx);
    this.chat = new Chat(conn);
  }
}