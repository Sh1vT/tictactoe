import 'package:flutter/material.dart';
import '../models/game_logic.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onReset;

  const GameControls({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellowAccent,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontFamily: 'FredokaOne',
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
      onPressed: () {
        onReset(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game Reset!')),
        );
      },
      child: const Text('Reset Game'),
    );
  }
}
