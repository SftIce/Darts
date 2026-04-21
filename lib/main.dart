import 'package:flutter/material.dart';
import 'game_selection.dart';

void main() => runApp(const DartsApp());

class DartsApp extends StatelessWidget {
  const DartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darts Scoring App',
      theme: ThemeData.dark(),
      home: GameSelection(),
    );
  }
}
