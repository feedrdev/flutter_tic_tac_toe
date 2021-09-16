import 'package:flutter/foundation.dart';
import 'package:tic_tac_toe/board.dart';
import 'package:tic_tac_toe/position.dart';

class Player {
  final bool isX; // X or O

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
    next = _canFork(board);
    if (next.isValid) {
      debugPrint('Can fork @${next.id}');
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

  bool hasWinner(Board board) => _hasWinner(board.positions
      .where((element) => element.player == this)
      .map((e) => e.id));

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

  Position _canFork(Board board) {
    final myPositions = board.positions
        .where((e) => e.player != null && e.player == this)
        .map((e) => e.id)
        .toSet();
    final freePositions = board.positions.where((e) => e.isEmpty).toSet();
    return freePositions.firstWhere(
          (e) {
        final set = Set<int>.from(myPositions)..add(e.id);
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