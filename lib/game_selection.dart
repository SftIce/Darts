import 'package:flutter/material.dart';
import 'screens/scoreboard_cricket_sa.dart';
import 'screens/scoreboard_501.dart';

class GameSelection extends StatelessWidget {
  final List<String> games = [
    '501 / 301 / 701',
    'Cricket (South African)',
    'Cricket (International)',
    'Around the Clock',
    'Killer',
    'Shanghai',
    'Halve-It',
    'Baseball',
    'High Score',
    'Chase the Dragon'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Darts South Africa – Game Hub')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              if (games[index] == 'Cricket (South African)') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CricketSAScoreboard()),
                );
              }
              if (games[index] == '501 / 301 / 701') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Scoreboard501()),
                );
              }
            },
            child: Text(games[index], textAlign: TextAlign.center),
          );
        },
      ),
    );
  }
}
