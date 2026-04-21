# --- Scaffold Darts Scoring App - Expanded Edition ---
$base = "lib"

# Create folders
mkdir "$base\logic" -Force
mkdir "$base\screens" -Force
mkdir "$base\models" -Force

# --- models/player.dart ---
Set-Content "$base\models\player.dart" @"
class Player {
  String name;
  int score;
  Map<String, int> marks; // Used for Cricket

  Player({required this.name, this.score = 0, Map<String, int>? marks})
      : marks = marks ?? {
          '20': 0, '19': 0, '18': 0, '17': 0, '16': 0,
          '15': 0, '14': 0, '13': 0, '12': 0, '11': 0,
          '10': 0, 'Bull': 0
        };
}
"@

# --- logic/cricket_sa_logic.dart ---
Set-Content "$base\logic\cricket_sa_logic.dart" @"
import '../models/player.dart';

class CricketSALogic {
  List<Player> players = [Player(name: 'Player 1'), Player(name: 'Player 2')];
  int currentPlayerIndex = 0;
  List<List<Player>> history = []; // For Undo functionality

  Player get currentPlayer => players[currentPlayerIndex];

  void registerHit(String number, int multiplier) {
    // Save history for undo
    history.add(players.map((p) => Player(
      name: p.name, 
      score: p.score, 
      marks: Map<String, int>.from(p.marks)
    )).toList());

    int hitsLeft = multiplier;
    while (hitsLeft > 0) {
      if (currentPlayer.marks[number]! < 3) {
        currentPlayer.marks[number] = currentPlayer.marks[number]! + 1;
      } else {
        // Check if opponents have closed the number
        bool allOthersClosed = players
            .where((p) => p != currentPlayer)
            .every((p) => p.marks[number] == 3);

        if (!allOthersClosed) {
          int value = number == 'Bull' ? 25 : int.parse(number);
          currentPlayer.score += value;
        }
      }
      hitsLeft--;
    }
    nextTurn();
  }

  void nextTurn() => currentPlayerIndex = (currentPlayerIndex + 1) % players.length;

  void undo() {
    if (history.isNotEmpty) {
      players = history.removeLast();
      currentPlayerIndex = (currentPlayerIndex - 1 + players.length) % players.length;
    }
  }
}
"@

# --- screens/scoreboard_cricket_sa.dart ---
Set-Content "$base\screens\scoreboard_cricket_sa.dart" @"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class CricketSAScoreboard extends StatefulWidget {
  const CricketSAScoreboard({super.key});

  @override
  State<CricketSAScoreboard> createState() => _CricketSAScoreboardState();
}

class _CricketSAScoreboardState extends State<CricketSAScoreboard> {
  final CricketSALogic logic = CricketSALogic();

  void _onHit(String num, int mult) => setState(() => logic.registerHit(num, mult));
  void _undo() => setState(() => logic.undo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket SA Scoreboard'),
        actions: [IconButton(icon: const Icon(Icons.undo), onPressed: _undo)],
      ),
      body: Column(
        children: [
          _buildScoreHeader(),
          Expanded(
            child: ListView(
              children: logic.currentPlayer.marks.keys.map((num) => _buildTargetRow(num)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: logic.players.map((p) => Column(
          children: [
            Text(p.name, style: TextStyle(color: p == logic.currentPlayer ? Colors.orange : Colors.white)),
            Text('${p.score}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildTargetRow(String num) {
    int marks = logic.currentPlayer.marks[num]!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text(num)),
        title: Row(
          children: List.generate(3, (i) => Icon(
            i < marks ? Icons.close : Icons.radio_button_unchecked,
            color: i < marks ? Colors.green : Colors.grey,
          )),
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            ElevatedButton(onPressed: () => _onHit(num, 1), child: const Text('x1')),
            ElevatedButton(onPressed: () => _onHit(num, 2), child: const Text('x2')),
            if(num != 'Bull') ElevatedButton(onPressed: () => _onHit(num, 3), child: const Text('x3')),
          ],
        ),
      ),
    );
  }
}
"@

# --- logic/logic_501.dart ---
Set-Content "$base\logic\logic_501.dart" @"
class Logic501 {
  int p1Score = 501;
  int p2Score = 501;
  bool isP1Turn = true;
  List<int> history = [];

  void submitScore(int totalPoints) {
    history.add(isP1Turn ? p1Score : p2Score);
    if (isP1Turn) {
      if (p1Score - totalPoints >= 2 || p1Score - totalPoints == 0) {
         p1Score -= totalPoints;
      }
    } else {
      if (p2Score - totalPoints >= 2 || p2Score - totalPoints == 0) {
         p2Score -= totalPoints;
      }
    }
    isP1Turn = !isP1Turn;
  }

  void undo() {
    if (history.isNotEmpty) {
      isP1Turn = !isP1Turn;
      if (isP1Turn) p1Score = history.removeLast();
      else p2Score = history.removeLast();
    }
  }
}
"@

Write-Host "Scaffolding Complete! Added Models, Undo Logic, and Enhanced UI." -ForegroundColor Green