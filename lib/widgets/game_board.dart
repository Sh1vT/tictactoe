import 'package:flutter/material.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
import '../models/game_logic.dart';

class GameBoard extends StatefulWidget {
  final Function(String) onPlayerChange;
  final bool isVsPC;
  final int reset;

  const GameBoard({super.key, required this.onPlayerChange, required this.isVsPC, required this.reset});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  late GameLogic _gameLogic;
  bool _isGameOver = false;
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  late AnimationController _countdownController;
  int _countdown = 3;
  bool _showCountdown = true;
  bool _boardEnabled = false;

  @override
  void initState() {
    super.initState();
    _gameLogic = GameLogic();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reset != oldWidget.reset) {
      setState(() {
        _gameLogic.resetGame();
        _isGameOver = false;
        _showCountdown = true;
        _boardEnabled = false;
      });
      _startCountdown();
    }
  }

  Future<void> _startCountdown() async {
    setState(() {
      _showCountdown = true;
      _boardEnabled = false;
      _countdown = 3;
    });
    for (int i = 3; i > 0; i--) {
      setState(() {
        _countdown = i;
      });
      _countdownController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() {
      _showCountdown = false;
      _boardEnabled = true;
    });
  }

  void _checkGameStatus() {
    final winner = _gameLogic.checkWinner();
    if (winner != null && !_isGameOver) {
      _isGameOver = true;
      String message;
      if (winner == 'Draw') {
        message = 'It\'s a Draw!';
      } else {
        message = 'Player $winner Wins!';
        _confettiController.play(); 
      }

      _animationController.forward();

      showDialog(
        context: context,
        builder: (context) {
          return ScaleTransition(
            scale: _animationController,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.cyanAccent,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: winner == 'X'
                          ? Colors.orangeAccent.withOpacity(0.5)
                          : winner == 'O'
                              ? Colors.yellowAccent.withOpacity(0.5)
                              : Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(
                        fontFamily: 'FredokaOne',
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontFamily: 'FredokaOne',
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _gameLogic.resetGame();
                          widget.onPlayerChange(_gameLogic.currentPlayer);
                          _isGameOver = false;
                          _animationController.reset();
                          _showCountdown = true;
                          _boardEnabled = false;
                        });
                        _startCountdown();
                      },
                      child: const Text(
                        'Restart',
                        style: TextStyle(
                          fontFamily: 'FredokaOne',
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _makePCMove() {
    final pcMove = _gameLogic.getPCMove();
    if (pcMove != null) {
      setState(() {
        _gameLogic.makeMove(pcMove);
        widget.onPlayerChange(_gameLogic.currentPlayer);
      });
      _checkGameStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boardSize = MediaQuery.of(context).size.width * 0.9;

    return Stack(
      alignment: Alignment.center,
      children: [
        
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.cyanAccent, Colors.yellowAccent, Colors.orangeAccent, Colors.white],
              emissionFrequency: 0.08,
              numberOfParticles: 30,
              maxBlastForce: 30,
              minBlastForce: 10,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: boardSize,
              height: boardSize,
              child: AbsorbPointer(
                absorbing: !_boardEnabled,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: _gameLogic.board[index] == 'X'
                              ? Colors.orangeAccent
                              : _gameLogic.board[index] == 'O'
                                  ? Colors.yellowAccent
                                  : Colors.cyanAccent,
                          width: 3,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          if (_gameLogic.board[index] == '' && !_isGameOver && _boardEnabled) {
                            setState(() {
                              _gameLogic.makeMove(index);
                              widget.onPlayerChange(_gameLogic.currentPlayer);
                            });
                            _checkGameStatus();

                            if (widget.isVsPC && _gameLogic.currentPlayer == 'O') {
                              Future.delayed(const Duration(milliseconds: 500), _makePCMove);
                            }
                          }
                        },
                        child: Center(
                          child: _buildCartoonCell(_gameLogic.board[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (_showCountdown)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _countdownController,
                builder: (context, child) {
                  double scale = 1.0 + 0.5 * _countdownController.value;
                  String text = _countdown > 0 ? '$_countdown' : 'Go!';
                  return Opacity(
                    opacity: 1.0 - _countdownController.value * 0.3,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.cyanAccent,
                            width: 4,
                          ),
                        ),
                        width: 160,
                        height: 160,
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontFamily: 'FredokaOne',
                            fontSize: 64,
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartoonCell(String value) {
    if (value == 'X') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orangeAccent, width: 4),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.close,
          size: 56,
          color: Colors.orangeAccent.shade100,
          shadows: const [
            Shadow(
              blurRadius: 12,
              color: Colors.orangeAccent,
              offset: Offset(0, 0),
            ),
          ],
        ),
      );
    } else if (value == 'O') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.yellowAccent, width: 4),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.circle,
          size: 56,
          color: Colors.yellowAccent.shade100,
          shadows: const [
            Shadow(
              blurRadius: 12,
              color: Colors.yellowAccent,
              offset: Offset(0, 0),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
