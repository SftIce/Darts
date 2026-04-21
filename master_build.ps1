# 1. Setup Folder Structure
$base = "lib"
mkdir "$base\logic", "$base\screens", "$base\models" -Force

# 2. CREATE THE 501 LOGIC (The Rules)
Set-Content "$base\logic\logic_501.dart" @'
class Logic501 {
  int p1Score = 501;
  int p2Score = 501;
  bool isP1Turn = true;

  void submitScore(int points) {
    if (isP1Turn) {
      if (p1Score - points >= 0) p1Score -= points;
    } else {
      if (p2Score - points >= 0) p2Score -= points;
    }
    isP1Turn = !isP1Turn;
  }
}
'@

# 3. CREATE THE CRICKET SA LOGIC
Set-Content "$base\logic\cricket_sa_logic.dart" @'
class CricketSALogic {
  Map<String, int> p1Marks = {"20":0,"19":0,"18":0,"17":0,"16":0,"15":0,"14":0,"13":0,"12":0,"11":0,"10":0,"Bull":0};
  Map<String, int> p2Marks = {"20":0,"19":0,"18":0,"17":0,"16":0,"15":0,"14":0,"13":0,"12":0,"11":0,"10":0,"Bull":0};
  int p1Score = 0;
  int p2Score = 0;

  void registerHit(String num, int mult, bool isP1) {
    var marks = isP1 ? p1Marks : p2Marks;
    marks[num] = (marks[num] ?? 0) + mult;
  }
}
'@

# 4. CREATE THE GAME HUB (Menu)
Set-Content "$base\game_selection.dart" @'
import 'package:flutter/material.dart';
import 'screens/scoreboard_cricket_sa.dart';
import 'screens/scoreboard_501.dart';

class GameSelection extends StatelessWidget {
  const GameSelection({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Darts South Africa Game Hub')),
      body: GridView.count(
        crossAxisCount: 2, padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Scoreboard501())), child: const Text("501 / 301")),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CricketSAScoreboard())), child: const Text("Cricket (SA)")),
        ],
      ),
    );
  }
}
'@

# 5. CREATE THE MAIN ENTRY (The Engine)
Set-Content "$base\main.dart" @'
import 'package:flutter/material.dart';
import 'game_selection.dart';

void main() => runApp(const MaterialApp(home: GameSelection(), debugShowCheckedModeBanner: false));
'@

# 6. CREATE THE ACTUAL SCREENS
ni "$base\screens\scoreboard_501.dart" -Force
ni "$base\screens\scoreboard_cricket_sa.dart" -Force

Write-Host "Project Scaffolding Complete!" -ForegroundColor Green