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
  Player _player1 = Player(isX: true);
  Player _player2 = Player(isX: false);
  Player? _winner;

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
    if (_has3InARow(player1Positions)) {
      _winner = _player1;
    } else {
      final player2Positions =
          _board.positions.where((p) => p.player == _player2).map((e) => e.id);
      if (_has3InARow(player2Positions)) {
        _winner = _player2;
      }
    }
  }

  bool _has3InARow(Iterable<int> positions) {
    final set = positions.toSet();
    return set.containsAll([1, 2, 3]) ||
        set.containsAll([4, 5, 6]) ||
        set.containsAll([7, 8, 9]) ||
        set.containsAll([1, 4, 7]) ||
        set.containsAll([2, 5, 8]) ||
        set.containsAll([3, 6, 9]) ||
        set.containsAll([1, 5, 9]) ||
        set.containsAll([3, 5, 7]);
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
          if (_winner != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size * 3,
                height: size * 3,
                child: Center(
                  child: Text(
                    'Game Over\n'
                    'You ${_winner == _player1 ? 'Won!' : 'Lost :('}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        height: 2,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.lime.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _board = Board();
            _winner = null;
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
    Position(1),
    Position(2),
    Position(3),
    Position(4),
    Position(5),
    Position(6),
    Position(7),
    Position(8),
    Position(9),
  ];
}

class Position {
  final int id;
  Player? player;

  Position(this.id);

  bool isEmpty() => (player == null);
}

class Player {
  final bool isX;
  List<Position> positions = [];

  Player({required this.isX});

  void nextMove(Board board) {
    final next = board.positions
        .firstWhere((value) => value.player == null, orElse: () => Position(0));
    if (next.id > 0) {
      next.player = this;
    }
  }

  Position? _canWin(Board board) {}
}
