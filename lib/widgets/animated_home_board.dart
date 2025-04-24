import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedHomeBoard extends StatefulWidget {
  const AnimatedHomeBoard({super.key});

  @override
  State<AnimatedHomeBoard> createState() => _AnimatedHomeBoardState();
}

class _AnimatedHomeBoardState extends State<AnimatedHomeBoard> {
  static const List<List<int>> demoMoves = [
    [0, 0], 
    [1, 1], 
    [0, 1], 
    [2, 2], 
    [0, 2], 
  ];
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  int moveIndex = 0;
  bool animating = true;

  @override
  void initState() {
    super.initState();
    _startDemo();
  }

  void _startDemo() {
    board = List.generate(3, (_) => List.filled(3, ''));
    moveIndex = 0;
    animating = true;
    Future.delayed(const Duration(milliseconds: 400), _nextMove);
  }

  void _nextMove() {
    if (moveIndex < demoMoves.length) {
      setState(() {
        final player = moveIndex % 2 == 0 ? 'X' : 'O';
        final move = demoMoves[moveIndex];
        board[move[0]][move[1]] = player;
        moveIndex++;
      });
      Future.delayed(const Duration(milliseconds: 400), _nextMove);
    } else {
      animating = false;
      Future.delayed(const Duration(milliseconds: 900), _startDemo);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 90;
    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 9,
        itemBuilder: (context, idx) {
          int row = idx ~/ 3;
          int col = idx % 3;
          String value = board[row][col];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value == 'X'
                    ? Colors.orangeAccent
                    : value == 'O'
                        ? Colors.yellowAccent
                        : Colors.cyanAccent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: value == ''
                    ? const SizedBox.shrink()
                    : Icon(
                        value == 'X' ? Icons.close : Icons.circle,
                        color: value == 'X'
                            ? Colors.orangeAccent
                            : Colors.yellowAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: value == 'X'
                                ? Colors.orangeAccent
                                : Colors.yellowAccent,
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
