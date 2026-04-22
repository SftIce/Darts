# create_cricket_sa.ps1
# Run this script from your Flutter project root (E:\Darts)

$logicPath = "lib\logic\cricket_sa_logic.dart"
$screenPath = "lib\screens\scoreboard_cricket_sa.dart"

# Ensure folders exist
New-Item -ItemType Directory -Force -Path (Split-Path $logicPath)
New-Item -ItemType Directory -Force -Path (Split-Path $screenPath)

# Write Cricket SA Logic
@"
class CricketSAPlayer {
  final String name;
  Map<int, int> marks = {};   // number → count of X’s (0–3)
  Map<int, int> score = {};   // number → accumulated points

  CricketSAPlayer(this.name) {
    for (var n = 10; n <= 20; n++) {
      marks[n] = 0;
      score[n] = 0;
    }
    marks[25] = 0; // Bull
    score[25] = 0;
  }
}

class CricketSAGame {
  CricketSAPlayer player1;
  CricketSAPlayer player2;

  CricketSAGame(this.player1, this.player2);

  void addHit(CricketSAPlayer player, CricketSAPlayer opponent, int number, int multiplier) {
    int currentMarks = player.marks[number] ?? 0;

    if (currentMarks < 3) {
      // Add closure marks
      player.marks[number] = (player.marks[number] ?? 0) + multiplier;
      if (player.marks[number]! > 3) player.marks[number] = 3;
    } else {
      // Already closed → check if opponent closed
      if ((opponent.marks[number] ?? 0) < 3) {
        player.score[number] = (player.score[number] ?? 0) + (number * multiplier);
      }
    }
  }

  int totalScore(CricketSAPlayer player) {
    return player.score.values.fold(0, (a, b) => a + b);
  }
}
"@ | Set-Content $logicPath

# Write Scoreboard Screen
@"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class ScoreboardCricketSA extends StatefulWidget {
  final CricketSAGame game;
  const ScoreboardCricketSA({super.key, required this.game});

  @override
  State<ScoreboardCricketSA> createState() => _ScoreboardCricketSAState();
}

class _ScoreboardCricketSAState extends State<ScoreboardCricketSA> {
  final List<int> targets = [20,19,18,17,16,15,14,13,12,11,10,25]; // 25 = Bull

  Widget buildRow(int number) {
    final p1Marks = 'X' * (widget.game.player1.marks[number] ?? 0);
    final p2Marks = 'X' * (widget.game.player2.marks[number] ?? 0);
    final p1Score = widget.game.player1.score[number] ?? 0;
    final p2Score = widget.game.player2.score[number] ?? 0;

    return TableRow(
      children: [
        Center(child: Text(p1Marks)),
        Center(child: Text(number == 25 ? 'Bull' : number.toString())),
        Center(child: Text(p2Marks)),
        Center(child: Text(p1Score.toString())),
        Center(child: Text(p2Score.toString())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket SA Scoreboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              Center(child: Text('P1 Marks')),
              Center(child: Text('Target')),
              Center(child: Text('P2 Marks')),
              Center(child: Text('P1 Score')),
              Center(child: Text('P2 Score')),
            ]),
            ...targets.map((n) => buildRow(n)).toList(),
            TableRow(children: [
              Center(child: Text(widget.game.totalScore(widget.game.player1).toString())),
              const Center(child: Text('TOTAL')),
              Center(child: Text(widget.game.totalScore(widget.game.player2).toString())),
              const SizedBox(),
              const SizedBox(),
            ])
          ],
        ),
      ),
    );
  }
}
"@ | Set-Content $screenPath

Write-Host "✅ Cricket SA logic and scoreboard files created successfully."
