class OpCode {
  static const int SEND_PING = 0;
  static const int SEND_LIST_ROOMS = 1;
  static const int SEND_JOIN_ROOM = 2;
  static const int SEND_SAY = 3;
  static const int SEND_FIGURE = 4;
  static const int SEND_UNDO = 6;
  static const int SEND_REDO = 7;
  static const int SEND_TURN = 8;
  static const int SEND_RESET = 9;
  static const int SEND_ENQUEUE_DRAW_QUEUE = 10;
  static const int SEND_DRAW_QUEUE_INFO = 11; //not sent currently

  static const int RECV_PONG = 10000;
  static const int RECV_ROOM_LIST = 10001;
  static const int RECV_JOIN_ROOM_RESULT = 10002;
  static const int RECV_SAY = 10003;
  static const int RECV_FIGURE = 10004;
  static const int RECV_UNDO = 10006;
  static const int RECV_REDO = 10007;
  static const int RECV_TURN = 10008;
  static const int RECV_RESET = 10009;
  static const int RECV_ENQUEUE = 10010;
  static const int RECV_DRAW_QUEUE_INFO = 10011;


  static const int STATUS_OK = 2000;
}