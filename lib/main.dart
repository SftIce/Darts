import 'package:flutter/material.dart';
import 'logic/cricket_sa_logic.dart';
import 'screens/cricket_sa_layout.dart';

void main() {
  final player1 = CricketSAPlayer('Player 1');
  final player2 = CricketSAPlayer('Player 2');
  final game = CricketSAGame(player1, player2);

  runApp(MyApp(game: game));
}

class MyApp extends StatelessWidget {
  final CricketSAGame game;
  const MyApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darts Scoring',
      theme: ThemeData.dark(),
      home: CricketSALayout(game: game),
    );
  }
}
