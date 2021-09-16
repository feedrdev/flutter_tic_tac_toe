import 'package:tic_tac_toe/position.dart';

class Board {
  List<Position> positions = [
    Position.topLeft(),
    Position.topCenter(),
    Position.topRight(),
    Position.centerLeft(),
    Position.center(),
    Position.centerRight(),
    Position.bottomLeft(),
    Position.bottomCenter(),
    Position.bottomRight(),
  ];
}