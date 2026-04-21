import 'package:flutter/material.dart';
import '../logic/logic_501.dart';
import '../widgets/dartboard_widget.dart';

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
      body: Row(
        children: [
          // Dartboard on the left
          Expanded(
            flex: 2,
            child: Center(
              child: DartboardWidget(
                logic501: widget.logic501,
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
                  'Player 1: ${widget.logic501.player1Score}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Player 2: ${widget.logic501.player2Score}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.logic501.isGameOver
                          ? 'Winner: ${widget.logic501.winner}'
                          : 'Game in progress...',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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
