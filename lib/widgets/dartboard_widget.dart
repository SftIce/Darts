import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class DartboardWidget extends StatelessWidget {
  final CricketSAGame game;
  final void Function(int number, int multiplier) onHit;

  const DartboardWidget({super.key, required this.game, required this.onHit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Example: simulate a hit on 20 single
        onHit(20, 1);
      },
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Text(
            'Dartboard Placeholder\nTap to simulate hit',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
