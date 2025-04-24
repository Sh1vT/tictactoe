import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../widgets/animated_home_board.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToGameScreen(bool isVsPC) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => GameScreen(isVsPC: isVsPC),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); 
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontFamily: 'FredokaOne',
                  fontSize: 40,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  shadows: const [
                    Shadow(
                      blurRadius: 16,
                      color: Colors.cyanAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            const AnimatedHomeBoard(),
            const SizedBox(height: 32),
            Card(
              elevation: 8,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Colors.orangeAccent, width: 2),
              ),
              child: InkWell(
                onTap: () => navigateToGameScreen(true),
                borderRadius: BorderRadius.circular(24),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'versus PC',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'FredokaOne',
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.orangeAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 8,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Colors.yellowAccent, width: 2),
              ),
              child: InkWell(
                onTap: () => navigateToGameScreen(false),
                borderRadius: BorderRadius.circular(24),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'versus P2',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'FredokaOne',
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.yellowAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
