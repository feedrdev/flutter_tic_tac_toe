import 'package:flutter/material.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({
    Key? key,
    required this.size,
    required this.isWin,
    required this.isDraw,
    this.onTap,
  }) : super(key: key);

  final double size;
  final bool isWin;
  final bool isDraw;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              width: size * 3,
              height: size * 2.5,
              child: Center(
                child: Text(
                  isDraw
                      ? 'It\'s a Draw!'
                      : 'You ${isWin ? 'Won!' : 'Lost :('}',
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
            onTap: onTap,
          ),
          Flexible(child: SizedBox(height: size)),
        ],
      ),
    );
  }
}
