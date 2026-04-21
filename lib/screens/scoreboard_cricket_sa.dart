import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import '../widgets/dartboard_widget.dart';
import '../widgets/player_stats_panel.dart';

class ScoreboardCricketSA extends StatefulWidget {
  final CricketSALogic cricketLogic;
  const ScoreboardCricketSA({Key? key, required this.cricketLogic}) : super(key: key);
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
          {'game':'Cricket SA','result':'Won 192-165'},
          {'game':'501','result':'Lost 34-0'},
        ],
      ),
      body: Row(
        children: [
          Expanded(flex:2, child: DartboardWidget(cricketLogic: widget.cricketLogic,size:400)),
          Expanded(flex:3, child: Column(children:[
            Text('Player 1: '),
            Text('Player 2: '),
          ])),
        ],
      ),
    );
  }
}
