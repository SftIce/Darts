import 'package:flutter/material.dart';
import '../logic/dart_math.dart';

class ScoreboardCricketSA extends StatefulWidget {
  @override
  _ScoreboardCricketSAState createState() => _ScoreboardCricketSAState();
}

class _ScoreboardCricketSAState extends State<ScoreboardCricketSA> {
  Map<int, int> p1Marks = {for (var v in [20,19,18,17,16,15,25]) v: 0};
  Map<int, int> p2Marks = {for (var v in [20,19,18,17,16,15,25]) v: 0};
  int p1Score = 0;
  int p2Score = 0;
  bool isP1Turn = true;
  List<String> history = [];

  void _handleTap(TapDownDetails details) {
    final hit = DartMath.getHit(details.localPosition.dx, details.localPosition.dy, 300);
    setState(() {
      if (hit.isGaryPlayer) {
        history.insert(0, "GARY PLAYER (0)");
      } else {
        _applyCricketLogic(hit);
        history.insert(0, "${isP1Turn ? 'P1' : 'P2'} hit ${hit.multiplier}x${hit.score}");
      }
    });
  }

  void _applyCricketLogic(DartHit hit) {
    if (![20,19,18,17,16,15,25].contains(hit.score)) return;
    var marks = isP1Turn ? p1Marks : p2Marks;
    var oppMarks = isP1Turn ? p2Marks : p1Marks;
    
    for (int i = 0; i < hit.multiplier; i++) {
      if (marks[hit.score]! < 3) {
        marks[hit.score] = marks[hit.score]! + 1;
      } else if (oppMarks[hit.score]! < 3) {
        if (isP1Turn) p1Score += hit.score; else p2Score += hit.score;
      }
    }
  }

  String _getMarkSym(int marks) {
    if (marks == 1) return "/";
    if (marks == 2) return "X";
    if (marks >= 3) return "";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Row(
        children: [
          Expanded(child: Center(
            child: GestureDetector(
              onTapDown: _handleTap,
              child: Image.asset('assets/dartboard.png', width: 300),
            ),
          )),
          Container(
            width: 300,
            color: Color(0xFF262626),
            child: Column(
              children: [
                Text("P1: $p1Score | P2: $p2Score", style: TextStyle(color: Colors.orange, fontSize: 24)),
                ...[20,19,18,17,16,15,25].map((val) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_getMarkSym(p1Marks[val]!), style: TextStyle(color: Colors.white, fontSize: 30)),
                    Text(val == 25 ? "BULL" : "$val", style: TextStyle(color: Colors.orange, fontSize: 20)),
                    Text(_getMarkSym(p2Marks[val]!), style: TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                )),
                Expanded(child: ListView(children: history.map((e) => Text(e, style: TextStyle(color: Colors.green))).toList())),
                ElevatedButton(onPressed: () => setState(() => isP1Turn = !isP1Turn), child: Text("NEXT PLAYER")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
