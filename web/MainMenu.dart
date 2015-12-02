import 'DrawingGameConnection.dart';
import 'OpCode.dart';
import 'dart:html';
import 'Game.dart';

class MainMenu {

  Game game;
  MainMenuMouseInput mouseInput;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  DrawingGameConnection connection;
  List<Button> buttons = [];
  num lastButton = 0;

  MainMenu(DrawingGameConnection this.connection, CanvasElement this.canvas, CanvasRenderingContext2D this.ctx, this.game) {
    connection.registerEvent(OpCode.RECV_ROOM_LIST, onCommand);
    connection.registerEvent(OpCode.RECV_JOIN_ROOM_RESULT, onCommand);
    connection.sendJSON(OpCode.SEND_LIST_ROOMS, null);
    mouseInput = new MainMenuMouseInput(this.canvas, this);
  }

  void destroy() {
    connection.unregisterEvent(OpCode.RECV_ROOM_LIST, onCommand);
    connection.unregisterEvent(OpCode.RECV_JOIN_ROOM_RESULT, onCommand);
    mouseInput.destroy();
  }

  void onCommand(int opCode, var data) {
    print("Command in main menu");
    switch(opCode) {
      case OpCode.RECV_ROOM_LIST:
        addButton("Create room", () => createRoom());
        for(int i = 0; i < data.length; i++) {
          var room = data[i];
          addButton(room["Name"] + " [" + room["Players"].toString() + "/" + room["MaxPlayers"].toString() + "]", () => joinRoom(room["ID"]));
        }
        redraw();
        break;

      case OpCode.RECV_JOIN_ROOM_RESULT:
        num status = data["Status"];
        switch(status) {
          case OpCode.STATUS_OK:
            game.roomJoined();
            break;
          default:
            print(Strings.getText(status));
            connection.sendJSON(OpCode.SEND_LIST_ROOMS, null);
          break;
        }
        break;
    }
  }

  void redraw() {
      ctx..fillStyle = "white"
        ..fillRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = "black";
      ctx.font = "16px Georgia";
    for(int i = 0; i < buttons.length; i++) {
      Button button = buttons[i];
      Rectangle r = getRectangleForIndex(i);
      ctx.strokeRect(r.left, r.top, r.width, r.height);
      num textWidth = ctx.measureText(button.text).width;
      num textHeight = 14;
      ctx.fillText(button.text, r.left + (r.width / 2) - (textWidth / 2), r.top + (r.height / 2) + (textHeight / 2));
    }
  }

  Rectangle getRectangleForIndex(int buttonIndex) {
    num butStartX = canvas.width / 5;
    num butWidth = butStartX * 3;
    num butStartY = canvas.height / 10 + (buttonIndex * (canvas.height / 12)) + (buttonIndex *(canvas.height / 12));
    num butHeight = (canvas.height / 7);

    return new Rectangle(butStartX, butStartY, butWidth, butHeight);
  }

  num getClickedIndex(Point clickedPosition) {
    //later add cool math, now just loop through it without optimizing
    for(int i = 0; i < buttons.length; i++) {
      Button button = buttons[i];
      Rectangle r = getRectangleForIndex(i);
      if(r.containsPoint(clickedPosition)) {
        return i;
      }
    }

    return -1;
  }

  void addButton(String text, [cb()]) {
    buttons.add(new Button(text, cb));
    lastButton++;
  }

  void buttonPressed(num index) {
    buttons[index].cb();
  }

  void createRoom() {
    print("Not available yet");
  }

  void joinRoom(num roomID) {
    connection.sendJSON(OpCode.SEND_JOIN_ROOM, {"ID": roomID});
  }
}

class Button {
  String text;
  var cb;
  Button(this.text, [this.cb()]);

  void clicked() {
    cb();
  }
}

class MainMenuMouseInput {

  List<StreamSubscription> subscriptions = [];
  CanvasElement canvas;
  MainMenu mainMenu;

  MainMenuMouseInput(CanvasElement this.canvas, MainMenu this.mainMenu) {
    subscriptions.add(canvas.onMouseDown.listen(this.mouseDown));
  }

  void mouseDown(MouseEvent event) {
    Point realPoint = new Point(event.client.x - canvas.offsetLeft, event.client.y - canvas.offsetTop);
    num clickedIndex = mainMenu.getClickedIndex(realPoint);
    if(clickedIndex != -1) {
      mainMenu.buttonPressed(clickedIndex);
    }
  }

  void destroy() {
    for(int i = 0; i < subscriptions.length; i++) {
      subscriptions[i].cancel();
    }
  }

}