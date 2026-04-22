import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import 'scoreboard_cricket_sa.dart';
import '../widgets/dartboard_widget.dart';

class CricketSALayout extends StatefulWidget {
  final CricketSAGame game;
  CricketSALayout({Key? key, required this.game}) : super(key: key);

  @override
  State<CricketSALayout> createState() => _CricketSALayoutState();
}

class _CricketSALayoutState extends State<CricketSALayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(' Throwing... ( left)'),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: DartboardWidget(
                    game: widget.game,
                    onHit: (target, mult) {
                      setState(() {
                        widget.game.recordHit(target, mult);
                        if (widget.game.currentTurnDarts >= 3) {
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (mounted) setState(() => widget.game.nextTurn());
                          });
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScoreboardCricketSA(game: widget.game),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () => setState(() => widget.game.garyPlayer()),
                  icon: const Icon(Icons.golf_course, color: Colors.white),
                  label: const Text("GARY PLAYER (Keep it on the green)", 
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => setState(() => widget.game.nextTurn()),
                  child: const Text("MISS / NEXT", style: TextStyle(color: Colors.white54)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
