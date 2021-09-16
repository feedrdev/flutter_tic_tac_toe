import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe/player.dart';

class Position {
  final int id;
  Player? player;

  Position(this.id);

  Position.none() : this(0);

  Position.topLeft() : this(1);

  Position.topCenter() : this(2);

  Position.topRight() : this(3);

  Position.centerLeft() : this(4);

  Position.center() : this(5);

  Position.centerRight() : this(6);

  Position.bottomLeft() : this(7);

  Position.bottomCenter() : this(8);

  Position.bottomRight() : this(9);

  bool get isEmpty => (player == null);

  bool get isValid => id != 0;

  @override
  bool operator ==(Object other) {
    return other is Position && id == other.id;
  }

  @override
  int get hashCode => hashValues(id, player);
}
