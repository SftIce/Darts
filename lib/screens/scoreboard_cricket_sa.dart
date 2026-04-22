import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class ScoreboardCricketSA extends StatelessWidget {
  final CricketSAGame game;
  ScoreboardCricketSA({Key? key, required this.game}) : super(key: key);

  final List<String> targets = ['20','19','18','17','16','15','14','13','12','11','10','D','T','Bull'];

  TextStyle chalkStyle(double size, {Color color = Colors.white}) => TextStyle(
    fontFamily: 'ChalkFont',
    color: color,
    fontSize: size,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.5), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1),
            3: FlexColumnWidth(1), 4: FlexColumnWidth(1.5), 5: FlexColumnWidth(1),
            6: FlexColumnWidth(1), 7: FlexColumnWidth(1), 8: FlexColumnWidth(1.5),
          },
          border: TableBorder.all(color: Colors.white24),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[900]),
              children: [
                header('P1 Score'), header('X'), header('X'), header('X'),
                header('Darts'),
                header('X'), header('X'), header('X'), header('P2 Score'),
              ]
            ),
            ...targets.map((t) {
              int p1m = game.player1.marks[t] ?? 0;
              int p2m = game.player2.marks[t] ?? 0;
              bool isAlt = targets.indexOf(t) % 2 == 0;
              return TableRow(
                decoration: BoxDecoration(color: isAlt ? Colors.transparent : Colors.white10),
                children: [
                  const Center(child: Text('')), 
                  Center(child: Text(p1m >= 1 ? 'X' : '', style: chalkStyle(18))),
                  Center(child: Text(p1m >= 2 ? 'X' : '', style: chalkStyle(18))),
                  Center(child: Text(p1m >= 3 ? 'X' : '', style: chalkStyle(18))),
                  Center(child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    color: _getTargetColor(t),
                    child: Text(t, style: chalkStyle(18, color: Colors.black), textAlign: TextAlign.center),
                  )),
                  Center(child: Text(p2m >= 1 ? 'X' : '', style: chalkStyle(18))),
                  Center(child: Text(p2m >= 2 ? 'X' : '', style: chalkStyle(18))),
                  Center(child: Text(p2m >= 3 ? 'X' : '', style: chalkStyle(18))),
                  const Center(child: Text('')),
                ]
              );
            }).toList(),
          ],
        ),
        const SizedBox(height: 20),
        _buildBottomScoreboard(),
      ],
    );
  }

  Color _getTargetColor(String t) {
    if (t == 'Bull') return Colors.blue[200]!;
    if (t == 'D') return Colors.yellow[200]!;
    if (t == 'T') return Colors.red[300]!;
    int? val = int.tryParse(t);
    if (val == null) return Colors.grey;
    return (val % 2 == 0) ? Colors.green[400]! : Colors.red[400]!;
  }

  Widget header(String txt) => Center(child: Text(txt, style: chalkStyle(14, color: Colors.amber)));

  Widget _buildBottomScoreboard() {
    int s1 = game.player1.totalScore;
    int s2 = game.player2.totalScore;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        scoreBox('Score', s1),
        scoreBox('Winning by', (s1 - s2) > 0 ? (s1 - s2) : 0),
        scoreBox('Difference', s1 - s2),
        scoreBox('Losing By', (s2 - s1) > 0 ? (s2 - s1) : 0),
        scoreBox('Score', s2),
      ],
    );
  }

  Widget scoreBox(String label, int val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          Text(label, style: chalkStyle(11)),
          Text(val.toString(), style: chalkStyle(18, color: Colors.amber)),
        ],
      ),
    );
  }
}
