import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import 'scoreboard_cricket_sa.dart';
import 'player_stats.dart';
import '../widgets/dartboard_widget.dart';

class CricketSALayout extends StatefulWidget {
  final CricketSAGame game;
  const CricketSALayout({super.key, required this.game});

  @override
  State<CricketSALayout> createState() => _CricketSALayoutState();
}

class _CricketSALayoutState extends State<CricketSALayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('South African Cricket'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: DartboardWidget(
              game: widget.game,
              onHit: (number, mult) {
                setState(() {
                  widget.game.addHit(
                    widget.game.player1,
                    widget.game.player2,
                    number,
                    mult,
                  );
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: ScoreboardCricketSA(game: widget.game),
          ),
          Expanded(
            flex: 3,
            child: PlayerStats(
              playerName: widget.game.player1.name,
              profileImage: 'assets/images/profile.png',
              gamesPlayed: 42,
              winRate: 62,
              highScore: 140,
              average: 54.7,
              recentMatches: [
                {'game': 'Cricket SA', 'result': 'Won', 'score': '192 - 165'},
                {'game': '501', 'result': 'Lost', 'score': '34 - 0'},
                {'game': 'Shanghai', 'result': 'Won', 'score': '72 - 65'},
                {'game': 'Around the Clock', 'result': 'Won', 'score': '20 - 18'},
                {'game': 'Killer', 'result': 'Lost', 'score': 'Eliminated'},
              ],
            ),
          ),
        ],
      ),
    );
  }
}
