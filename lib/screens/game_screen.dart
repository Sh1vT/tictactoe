import 'package:flutter/material.dart';
import '../widgets/game_board.dart';
import '../models/game_logic.dart';

class GameScreen extends StatefulWidget {
  final bool isVsPC;

  const GameScreen({super.key, required this.isVsPC});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String currentPlayer = 'X';
  int resetCounter = 0;

  void updateCurrentPlayer(String player) {
    setState(() {
      currentPlayer = player;
    });
  }

  void resetGame() {
    setState(() {
      resetCounter++;
      currentPlayer = 'X';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.cyanAccent, size: 28),
                  tooltip: 'Reset Game',
                  onPressed: resetGame,
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 28,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
                children: [
                  const TextSpan(text: "Player "),
                  TextSpan(
                    text: currentPlayer,
                    style: TextStyle(
                      color: currentPlayer == 'X' ? Colors.orangeAccent : Colors.yellowAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const TextSpan(text: "'s Turn"),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Center(
              child: GameBoard(
                onPlayerChange: updateCurrentPlayer,
                isVsPC: widget.isVsPC,
                reset: resetCounter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
