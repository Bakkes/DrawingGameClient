// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'DrawingGame.dart';
WebSocket ws;

string host = "127.0.0.1";
int port = 4444;
DrawingGame drawingGame;

void main() {
  querySelector('#output').text = 'Your Dart app is running.';

  CanvasElement canvas = querySelector("#canvas");
  drawingGame = new DrawingGame(canvas);
  drawingGame.clear();
}

class DrawingGameStart {


/*void initWebSocket([int retrySeconds = 2]) {
    var reconnectScheduled = false;

    ws = new WebSocket("ws://" + this.host + ":" + this.port);

    void scheduleReconnect() {
      if (!reconnectScheduled) {
        new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
      }
      reconnectScheduled = true;
    }

    ws.onClose.listen((e) {
      outputMsg('Websocket closed, retrying in $retrySeconds seconds');
      scheduleReconnect();
    });

    ws.onError.listen((e) {
      outputMsg("Error connecting to ws");
      scheduleReconnect();
    });
  }

  @reflectable
  String reverseText(String text) {
    return text.split('').reversed.join('');
  }*/
}