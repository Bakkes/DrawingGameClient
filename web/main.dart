// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'Game.dart';

Game game;

void main() {
  querySelector('#output').text = 'Drawing game started';

  CanvasElement canvas = querySelector("#canvas");
  game = new Game(canvas);
}