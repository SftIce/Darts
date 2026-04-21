import 'package:flutter/material.dart';
import 'game_selection.dart';

void main() {
  runApp(const DartsApp());
}

class DartsApp extends StatelessWidget {
  const DartsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darts Scoring',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameSelectionScreen(),
    );
  }
}
