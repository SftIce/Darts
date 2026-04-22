# create_main.ps1
# Run this script from your Flutter project root (E:\Darts)

$mainPath = "lib\main.dart"

New-Item -ItemType Directory -Force -Path (Split-Path $mainPath)

@"
import 'package:flutter/material.dart';
import 'logic/cricket_sa_logic.dart';
import 'screens/cricket_sa_layout.dart';

void main() {
  // Initialize players and game
  final player1 = CricketSAPlayer('Player 1');
  final player2 = CricketSAPlayer('Player 2');
  final game = CricketSAGame(player1, player2);

  runApp(DartsApp(game: game));
}

class DartsApp extends StatelessWidget {
  final CricketSAGame game;
  const DartsApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CricketSALayout(game: game),
    );
  }
}
"@ | Set-Content $mainPath

Write-Host "✅ main.dart created successfully. Run 'flutter run -d windows' or 'flutter run -d edge' to launch."
