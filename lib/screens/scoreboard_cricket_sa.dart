import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import '../widgets/dartboard_widget.dart';
import '../widgets/player_stats_panel.dart';

class ScoreboardCricketSA extends StatefulWidget {
  final CricketSALogic cricketLogic;

  const ScoreboardCricketSA({Key? key, required this.cricketLogic})
      : super(key: key);

  @override
  _ScoreboardCricketSAState createState() => _ScoreboardCricketSAState();
}

class _ScoreboardCricketSAState extends State<ScoreboardCricketSA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket SA')),
      drawer: PlayerStatsPanel(
        playerName: 'Mark',
        gamesPlayed: 42,
        winRate: 62,
        highScore: 140,
        threeDartAverage: 54.7,
        recentMatches: [
          {'game': 'Cricket SA', 'result': 'Won 192 - 165'},
          {'game': '501', 'result': 'Lost 34 - 0'},
          {'game': 'Shanghai', 'result': 'Won 72 - 65'},
          {'game': 'Around the Clock', 'result': 'Won 20 - 18'},
          {'game': 'Killer', 'result': 'Lost – Eliminated'},
        ],
      ),
      body: Row(
        children: [
          // Dartboard on the left
          Expanded(
            flex: 2,
            child: Center(
              child: DartboardWidget(
                cricketLogic: widget.cricketLogic,
                size: 400,
              ),
            ),
          ),
          // Scoreboard on the right
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Player 1: ${widget.cricketLogic.player1Score}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Player 2: ${widget.cricketLogic.player2Score}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cricketLogic.targets.length,
                    itemBuilder: (context, index) {
                      final target = widget.cricketLogic.targets[index];
                      final marksP1 =
                          widget.cricketLogic.player1Marks[target] ?? '';
                      final marksP2 =
                          widget.cricketLogic.player2Marks[target] ?? '';
                      return ListTile(
                        title: Text('Target $target'),
                        subtitle: Text('P1: $marksP1   |   P2: $marksP2'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
