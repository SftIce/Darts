import 'package:flutter/material.dart';
import '../logic/logic_501.dart';

class Scoreboard501 extends StatefulWidget {
  const Scoreboard501({super.key});

  @override
  State<Scoreboard501> createState() => _Scoreboard501State();
}

class _Scoreboard501State extends State<Scoreboard501> {
  final Logic501 logic = Logic501();

  void _hit(int value, int multiplier) {
    setState(() {
      logic.registerHit(logic.currentPlayer, value, multiplier);
      if (logic.checkWin(logic.currentPlayer, multiplier)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('${logic.currentPlayer} wins!'),
          ),
        );
      }
      logic.currentPlayer = logic.currentPlayer == 'P1' ? 'P2' : 'P1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('501')),
      body: Column(
        children: [
          Text('Player 1 Score: ${logic.player1Score}', style: const TextStyle(fontSize: 20)),
          Text('Player 2 Score: ${logic.player2Score}', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                for (var number in [20,19,18,17,16,15,14,13,12,11,10])
                  _buildRow(number),
                _buildRow(25), // Bull
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int number) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number == 25 ? 'Bull' : number.toString(),
              style: const TextStyle(fontSize: 24)),
          ElevatedButton(onPressed: () => _hit(number, 1), child: const Text('Single')),
          ElevatedButton(onPressed: () => _hit(number, 2), child: const Text('Double')),
          ElevatedButton(onPressed: () => _hit(number, 3), child: const Text('Treble')),
        ],
      ),
    );
  }
}
