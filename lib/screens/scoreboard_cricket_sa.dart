import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class ScoreboardCricketSA extends StatelessWidget {
  final CricketSAGame game;
  const ScoreboardCricketSA({super.key, required this.game});

  final List<int> targets = [20,19,18,17,16,15,14,13,12,11,10,25];

  TextStyle chalkStyle(double size) => TextStyle(
    fontFamily: 'ChalkFont',
    color: Colors.white,
    fontSize: size,
    shadows: [
      Shadow(
        blurRadius: 2,
        color: Colors.white24,
        offset: Offset(1,1),
      )
    ],
  );

  Widget buildMarks(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => Text(i < count ? 'X' : '', style: chalkStyle(20))),
    );
  }

  TableRow buildRow(int number) {
    final p1Marks = game.player1.marks[number] ?? 0;
    final p2Marks = game.player2.marks[number] ?? 0;
    final p1Score = game.player1.score[number] ?? 0;
    final p2Score = game.player2.score[number] ?? 0;

    return TableRow(children: [
      buildMarks(p1Marks),
      Center(child: Text(number == 25 ? 'Bull' : number.toString(), style: chalkStyle(20))),
      buildMarks(p2Marks),
      Center(child: Text(p1Score.toString(), style: chalkStyle(20))),
      Center(child: Text(p2Score.toString(), style: chalkStyle(20))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final p1Total = game.totalScore(game.player1);
    final p2Total = game.totalScore(game.player2);
    final diff = p1Total - p2Total;

    return Table(
      border: TableBorder.all(color: Colors.white54),
      children: [
        TableRow(children: [
          Center(child: Text(game.player1.name, style: chalkStyle(22))),
          Center(child: Text('Target', style: chalkStyle(22))),
          Center(child: Text(game.player2.name, style: chalkStyle(22))),
          Center(child: Text('Score P1', style: chalkStyle(22))),
          Center(child: Text('Score P2', style: chalkStyle(22))),
        ]),
        ...targets.map((n) => buildRow(n)).toList(),
        TableRow(children: [
          Center(child: Text(p1Total.toString(), style: chalkStyle(24))),
          Center(child: Text('TOTAL', style: chalkStyle(24))),
          Center(child: Text(p2Total.toString(), style: chalkStyle(24))),
          Center(child: Text('Winning by: ', style: chalkStyle(18))),
          Center(child: Text('Losing by: ', style: chalkStyle(18))),
        ])
      ],
    );
  }
}
