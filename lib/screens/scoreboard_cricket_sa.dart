import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import '../widgets/dartboard_widget.dart';

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
                        subtitle: Text(
                            'P1: $marksP1   |   P2: $marksP2'),
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
