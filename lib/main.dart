import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(title: 'Tic Tac Toe'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Board _board = Board();
  final Player _player1 = Player(isX: true);
  final Player _player2 = Player(isX: false);
  Player? _winner;
  bool _isGameOver = false;

  void _handleMove(Position position, Player player) {
    if (_winner != null) return; // game over
    if (position.player != null) return; // position is not empty
    setState(() {
      position.player = _player1;
      _player2.nextMove(_board);
      _checkGameOver();
    });
  }

  void _checkGameOver() {
    final player1Positions =
        _board.positions.where((p) => p.player == _player1).map((e) => e.id);
    if (_hasWinner(player1Positions)) {
      _winner = _player1;
    } else {
      final player2Positions =
          _board.positions.where((p) => p.player == _player2).map((e) => e.id);
      if (_hasWinner(player2Positions)) {
        _winner = _player2;
      }
    }
    _isGameOver = _board.positions.where((p) => p.player == null).isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    const size = 80.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Builder(builder: (context) {
                      final position = _board.positions[i];
                      return TileWidget(
                        key: Key('${position.id}'),
                        isX: position.player?.isX ?? false,
                        checked: position.player != null,
                        size: size,
                        onTap: () => _handleMove(position, _player1),
                      );
                    }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 3; i < 6; i++)
                    Builder(builder: (context) {
                      final position = _board.positions[i];
                      return TileWidget(
                        key: Key('${position.id}'),
                        isX: position.player?.isX ?? false,
                        checked: position.player != null,
                        size: size,
                        onTap: () => _handleMove(position, _player1),
                      );
                    }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 6; i < 9; i++)
                    Builder(builder: (context) {
                      final position = _board.positions[i];
                      return TileWidget(
                        key: Key('${position.id}'),
                        isX: position.player?.isX ?? false,
                        checked: position.player != null,
                        size: size,
                        onTap: () => _handleMove(position, _player1),
                      );
                    }),
                ],
              ),
              const SizedBox(height: size),
            ],
          ),
          if (_isGameOver)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size * 3,
                    height: size * 2.5,
                    child: Center(
                      child: Text(
                        _winner == null
                            ? 'It\'s a Draw!'
                            : 'You ${_winner == _player1 ? 'Won!' : 'Lost :('}',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black87,
                            height: 2,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: size),
                ],
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            // reset state to restart the game
            _board = Board();
            _winner = null;
            _isGameOver = false;
          });
        },
        tooltip: 'Start Over',
        icon: const Icon(Icons.restart_alt),
        label: const Text('New Game'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key? key,
    required this.size,
    required this.onTap,
    this.isX = true,
    this.checked = false,
  }) : super(key: key);

  final double size;
  final Function() onTap;
  final bool checked;
  final bool isX;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: checked
                ? isX
                    ? Icon(
                        Icons.clear_rounded,
                        size: size,
                        color: Colors.orange[600],
                      )
                    : Icon(
                        Icons.circle_outlined,
                        size: 0.8 * size,
                        color: Colors.grey[600],
                      )
                : Container(),
          ),
        ),
      ),
    );
  }
}

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

class Player {
  final bool isX; // X or O
  List<Position> positions = [];

  Player({required this.isX});

  void nextMove(Board board) {
    Position next;
    next = _canWin(board);
    if (next.isValid) {
      debugPrint('Can win @${next.id}!');
      next.player = this;
      return;
    }
    next = _canLose(board);
    if (next.isValid) {
      debugPrint('Can lose @${next.id}!');
      next.player = this;
      return;
    }
    next = _canOtherFork(board);
    if (next.isValid) {
      debugPrint('Other can fork @${next.id}');
      next.player = this;
      return;
    }
    next = _canGrabCenter(board);
    if (next.isValid) {
      debugPrint('Grabbing empty center!');
      next.player = this;
      return;
    }
    next = _canGrabCorner(board);
    if (next.isValid) {
      debugPrint('Grabbing empty corner ${next.id}!');
      next.player = this;
      return;
    }
    next = board.positions.firstWhere(
      (p) => p.isEmpty,
      orElse: () => Position.none(),
    );
    if (next.isValid) {
      debugPrint('Grabbing free position @${next.id}');
      next.player = this;
    }
  }

  Position _canWin(Board board) {
    final myPositions =
        board.positions.where((e) => e.player == this).map((e) => e.id).toSet();
    final freePositions = board.positions.where((e) => e.isEmpty).toSet();
    return freePositions.firstWhere((position) {
      final set = Set<int>.from(myPositions)..add(position.id);
      return _hasWinner(set);
    }, orElse: () => Position.none());
  }

  Position _canLose(Board board) {
    final otherPositions = board.positions
        .where((e) => e.player != null && e.player != this)
        .map((e) => e.id)
        .toSet();
    final freePositions = board.positions.where((e) => e.isEmpty).toSet();
    return freePositions.firstWhere((p) {
      final set = Set<int>.from(otherPositions)..add(p.id);
      return _hasWinner(set);
    }, orElse: () => Position.none());
  }

  Position _canOtherFork(Board board) {
    final otherPositions = board.positions
        .where((e) => e.player != null && e.player != this)
        .map((e) => e.id)
        .toSet();
    debugPrint(otherPositions.toString());
    final freePositions = board.positions.where((e) => e.isEmpty).toSet();
    return freePositions.firstWhere(
      (e) {
        final set = Set<int>.from(otherPositions)..add(e.id);
        return _countWinnersIn(set) > 1;
      },
      orElse: () => Position.none(),
    );
  }

  Position _canGrabCenter(Board board) =>
      board.positions[4].isEmpty ? board.positions[4] : Position.none();

  Position _canGrabCorner(Board board) {
    final corners = [1, 3, 7, 9];
    return board.positions.firstWhere(
      (element) => element.isEmpty && corners.contains(element.id),
      orElse: () => Position.none(),
    );
  }
}

const winners = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
  [1, 4, 7],
  [2, 5, 8],
  [3, 6, 9],
  [1, 5, 9],
  [3, 5, 7]
];

bool _hasWinner(Iterable<int> positions) {
  final set = positions.toSet();
  final first = winners.firstWhere((element) => set.containsAll(element),
      orElse: () => []);
  return first.isNotEmpty;
}

int _countWinnersIn(Set<int> set) {
  return winners.where((element) => set.containsAll(element)).length;
}
