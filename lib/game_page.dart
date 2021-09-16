import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board.dart';
import 'package:tic_tac_toe/game_over_widget.dart';
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
  final Player _manPlayer = Player(isX: true);
  final Player _machinePlayer = Player(isX: false);
  Player? _winner;
  bool _isGameOver = false;

  @override
  Widget build(BuildContext context) {
    final tileSize =
        min(100.0, MediaQuery.of(context).size.shortestSide * 0.66 / 3);
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
                    _buildTile(_board.positions[i], tileSize),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 3; i < 6; i++)
                    _buildTile(_board.positions[i], tileSize),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 6; i < 9; i++)
                    _buildTile(_board.positions[i], tileSize),
                ],
              ),
              SizedBox(height: tileSize),
            ],
          ),
          if (_isGameOver)
            GameOverWidget(
              size: tileSize,
              isDraw: _winner == null,
              isWin: _winner == _manPlayer,
              onTap: _playNewGame,
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _board.isClean()
          ? null
          : FloatingActionButton.extended(
              onPressed: _playNewGame,
              tooltip: 'Start Over',
              //icon: const Icon(Icons.restart_alt),
              label: const Text('Start Over'),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTile(Position position, double size) {
    return TileWidget(
      key: Key('${position.id}'),
      isX: position.player?.isX ?? false,
      checked: position.player != null,
      size: size,
      onTap: () => _handleMove(position, _manPlayer),
    );
  }

  void _handleMove(Position position, Player player) {
    if (_winner != null) return; // game over
    if (position.player != null) return; // position is not empty
    setState(() {
      position.player = _manPlayer;
      _machinePlayer.nextMove(_board);
      _checkGameOver();
    });
  }

  void _checkGameOver() {
    if (_manPlayer.hasWinner(_board)) {
      _winner = _manPlayer;
    } else if (_machinePlayer.hasWinner(_board)) {
      _winner = _machinePlayer;
    }
    _isGameOver = _winner != null ||
        _board.positions.where((p) => p.player == null).isEmpty;
  }

  void _playNewGame() {
    setState(() {
      // reset state to restart the game
      _board = Board();
      _winner = null;
      _isGameOver = false;
    });
  }
}
