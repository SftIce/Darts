import 'package:flutter/material.dart';
import '../logic/logic_501.dart';
import '../widgets/dartboard_widget.dart';
import '../widgets/player_stats_panel.dart';

class Scoreboard501 extends StatefulWidget {
  final Logic501 logic501;
  const Scoreboard501({Key? key, required this.logic501}) : super(key: key);
  @override
  _Scoreboard501State createState() => _Scoreboard501State();
}

class _Scoreboard501State extends State<Scoreboard501> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('501')),
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
          Expanded(flex:2, child: DartboardWidget(logic501: widget.logic501,size:400)),
          Expanded(flex:3, child: Column(children:[
            Text('Player 1: '),
            Text('Player 2: '),
          ])),
        ],
      ),
    );
  }
}
