import 'package:flutter/material.dart';

/// Widget that renders a clickable game tile
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