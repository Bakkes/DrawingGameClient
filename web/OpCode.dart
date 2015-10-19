class OpCode {
  static const int SEND_PING = 0;
  static const int SEND_LIST_ROOMS = 1;
  static const int SEND_JOIN_ROOM = 2;
  static const int SEND_SAY = 3;
  static const int SEND_FIGURE = 4;


  static const int RECV_PONG = 10000;
  static const int RECV_ROOM_LIST = 10001;
  static const int RECV_JOIN_ROOM_RESULT = 10002;
  static const int RECV_SAY = 10003;
  static const int RECV_FIGURE = 10004;
}