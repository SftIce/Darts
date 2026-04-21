import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class CricketSAScoreboard extends StatefulWidget {
  const CricketSAScoreboard({super.key});

  @override
  State<CricketSAScoreboard> createState() => _CricketSAScoreboardState();
}

class _CricketSAScoreboardState extends State<CricketSAScoreboard> {
  final CricketSALogic logic = CricketSALogic();
  String currentPlayer = 'P1';

  void _hit(String number, int multiplier) {
    setState(() {
      logic.registerHit(currentPlayer, number, multiplier);
      currentPlayer = currentPlayer == 'P1' ? 'P2' : 'P1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket South Africa')),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildRow('20'),
                _buildRow('19'),
                _buildRow('18'),
                _buildRow('17'),
                _buildRow('16'),
                _buildRow('15'),
                _buildRow('14'),
                _buildRow('13'),
                _buildRow('12'),
                _buildRow('11'),
                _buildRow('10'),
                _buildRow('Bull'),
              ],
            ),
          ),
          Text('Player 1 Score: ${logic.player1Score}'),
          Text('Player 2 Score: ${logic.player2Score}'),
        ],
      ),
    );
  }

  Widget _buildRow(String number) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number, style: const TextStyle(fontSize: 24)),
          ElevatedButton(onPressed: () => _hit(number, 1), child: const Text('Single')),
          ElevatedButton(onPressed: () => _hit(number, 2), child: const Text('Double')),
          ElevatedButton(onPressed: () => _hit(number, 3), child: const Text('Treble')),
        ],
      ),
    );
  }
}
