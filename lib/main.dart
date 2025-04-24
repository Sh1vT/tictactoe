import 'package:flutter/material.dart';
import 'screens/game_mode_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        fontFamily: 'FredokaOne',
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.cyanAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.cyanAccent,
          secondary: Colors.yellowAccent,
          background: Colors.black,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 20,
            color: Colors.cyanAccent,
            fontFamily: 'FredokaOne',
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            color: Colors.cyanAccent,
            fontFamily: 'FredokaOne',
            fontWeight: FontWeight.w400,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.cyanAccent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.cyanAccent,
            fontFamily: 'FredokaOne',
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
          iconTheme: IconThemeData(color: Colors.cyanAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.yellowAccent),
            foregroundColor: MaterialStatePropertyAll(Colors.black),
            textStyle: MaterialStatePropertyAll(
              TextStyle(
                fontFamily: 'FredokaOne',
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const GameModeScreen(),
    );
  }
}
