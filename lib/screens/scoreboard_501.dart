import 'package:flutter/material.dart';
import '../logic/logic_501.dart';

class Scoreboard501 extends StatefulWidget {
  const Scoreboard501({super.key});
  @override
  State<Scoreboard501> createState() => _Scoreboard501State();
}

class _Scoreboard501State extends State<Scoreboard501> {
  final Logic501 logic = Logic501();
  final TextEditingController _controller = TextEditingController();
  List<int> throwHistory = [];

  void _submit() {
    setState(() {
      int val = int.tryParse(_controller.text) ?? 0;
      logic.submitScore(val);
      throwHistory.insert(0, val); // Adds most recent throw to the top
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("501 Countdown"), backgroundColor: Colors.black),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreDisplay("P1", logic.p1Score, logic.isP1Turn),
              _scoreDisplay("P2", logic.p2Score, !logic.isP1Turn),
            ],
          ),
          const Divider(color: Colors.white24),
          const Text("THROW HISTORY", style: TextStyle(color: Colors.orange, letterSpacing: 2)),
          Expanded(
            child: ListView.builder(
              itemCount: throwHistory.length,
              itemBuilder: (context, i) => ListTile(
                title: Center(child: Text("${throwHistory[i]}", style: const TextStyle(color: Colors.white54, fontSize: 20))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Enter Score", hintStyle: TextStyle(color: Colors.white24)),
              onSubmitted: (_) => _submit(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreDisplay(String name, int score, bool active) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: active ? Colors.orange : Colors.white24)),
        Text("$score", style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
