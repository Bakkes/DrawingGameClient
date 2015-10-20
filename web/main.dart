// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'DrawingGame.dart';
WebSocket ws;

string host = "127.0.0.1";
int port = 4444;
DrawingGame drawingGame;

void main() {
  querySelector('#output').text = 'Drawing game started';

  CanvasElement canvas = querySelector("#canvas");
  drawingGame = new DrawingGame(canvas);
  drawingGame.clear();
}