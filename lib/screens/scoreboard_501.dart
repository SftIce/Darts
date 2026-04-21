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
          Text('Player 1 Score: ${logic.player1Score}'),
          Text('Player 2 Score:
