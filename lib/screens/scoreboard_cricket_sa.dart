import 'package:flutter/material.dart';
import '../logic/dart_math.dart';
import '../logic/cricket_sa_logic.dart';

class ScoreboardCricketSA extends StatefulWidget {
  const ScoreboardCricketSA({super.key});

  @override
  State<ScoreboardCricketSA> createState() => _ScoreboardCricketSAState();
}

class _ScoreboardCricketSAState extends State<ScoreboardCricketSA> {
  final CricketSALogic _logic = CricketSALogic();
  final List<String> _history = [];

  void _handleTap(TapDownDetails details) {
    final hit = DartMath.calculate(details.localPosition.dx, details.localPosition.dy);

    setState(() {
      if (hit.isMiss) {
        _history.insert(0, "🔴 GARY PLAYER MISS (Wire / Outer)");
      } else {
        final playerName = _logic.isP1Turn ? "P1" : "P2";
        _logic.registerHit(hit.score, hit.multiplier, isP1: _logic.isP1Turn);

        if (hit.score == 25 || hit.score == 50) {
          _history.insert(0, "$playerName hit ${hit.score} (${hit.ring})");
        } else {
          _history.insert(0, "$playerName hit ${hit.multiplier}x${hit.score}");
        }
      }
    });
  }

  String _getMarkSymbol(int number, bool forP1) {
    return _logic.getMarkSymbol(number, forP1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("CRICKET (SA Rules)"),
        backgroundColor: const Color(0xFF262626),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _logic.reset();
                _history.clear();
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Dartboard - Click to Score
          Expanded(
            child: Center(
              child: GestureDetector(
                onTapDown: _handleTap,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/dartboard.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Scoreboard Panel
          Container(
            width: 320,
            color: const Color(0xFF262626),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Scores
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPlayerScore("P1", _logic.p1Score, _logic.isP1Turn),
                      const Text("VS", style: TextStyle(color: Colors.white54, fontSize: 18)),
                      _buildPlayerScore("P2", _logic.p2Score, !_logic.isP1Turn),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Cricket Numbers + Marks
                const Text(
                  "NUMBERS",
                  style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...[20, 19, 18, 17, 16, 15, 25].map((val) => _buildNumberRow(val)),

                const SizedBox(height: 20),

                // History
                const Text(
                  "HISTORY",
                  style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _history.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _history[index],
                        style: const TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ),

                // Controls
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _logic.isP1Turn = !_logic.isP1Turn;
                          });
                        },
                        child: Text("NEXT PLAYER (${_logic.isP1Turn ? 'P1' : 'P2'})"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _logic.reset();
                          _history.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child: const Text("RESET"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String label, int score, bool isActive) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$score",
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNumberRow(int val) {
    final display = val == 25 ? "BULL" : "$val";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _getMarkSymbol(val, true),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            display,
            style: const TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Text(
            _getMarkSymbol(val, false),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
