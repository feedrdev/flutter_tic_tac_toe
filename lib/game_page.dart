import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board.dart';
import 'package:tic_tac_toe/player.dart';
import 'package:tic_tac_toe/position.dart';

import 'board_tile.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Board _board = Board();
  final Player _player1 = Player(isX: true);
  final Player _player2 = Player(isX: false);
  Player? _winner;
  bool _isGameOver = false;

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
    if (_player1.hasWinner(_board)) {
      _winner = _player1;
    } else if (_player2.hasWinner(_board)) {
      _winner = _player2;
    }
    _isGameOver = _winner != null ||
        _board.positions.where((p) => p.player == null).isEmpty;
  }
}