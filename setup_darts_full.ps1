# Base project path
$base = "E:\Darts\lib"

# Create folder structure
$folders = @(
    "$base\logic",
    "$base\screens",
    "$base\widgets"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Created folder: $folder"
    }
}

# Helper function to write full Dart code into files
function Write-DartFile($path, $content) {
    Set-Content -Path $path -Value $content -Force
    Write-Host "Wrote file: $path"
}

# === main.dart ===
Write-DartFile "$base\main.dart" @"
import 'package:flutter/material.dart';
import 'game_selection.dart';

void main() {
  runApp(const DartsApp());
}

class DartsApp extends StatelessWidget {
  const DartsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darts Scoring',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameSelectionScreen(),
    );
  }
}
"@

# === game_selection.dart ===
Write-DartFile "$base\game_selection.dart" @"
import 'package:flutter/material.dart';
import 'logic/cricket_sa_logic.dart';
import 'logic/logic_501.dart';
import 'screens/scoreboard_cricket_sa.dart';
import 'screens/scoreboard_501.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Game')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Cricket SA'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScoreboardCricketSA(
                    cricketLogic: CricketSALogic(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('501'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scoreboard501(
                    logic501: Logic501(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
"@

# === cricket_sa_logic.dart ===
Write-DartFile "$base\logic\cricket_sa_logic.dart" @"
// Basic Cricket SA logic
class CricketSALogic {
  final List<int> targets = [20,19,18,17,16,15,14,13,12,10,25];
  int player1Score = 0;
  int player2Score = 0;
  Map<int,String> player1Marks = {};
  Map<int,String> player2Marks = {};

  void registerHit(int sector, int multiplier) {
    // TODO: implement full scoring logic
    player1Score += sector * multiplier;
  }
}
"@

# === logic_501.dart ===
Write-DartFile "$base\logic\logic_501.dart" @"
// Basic 501 logic
class Logic501 {
  int player1Score = 501;
  int player2Score = 501;
  bool isGameOver = false;
  String winner = '';

  void registerHit(int sector, int multiplier) {
    int value = sector * multiplier;
    player1Score -= value;
    if (player1Score <= 0) {
      isGameOver = true;
      winner = 'Player 1';
    }
  }
}
"@

# === dart_math.dart ===
Write-DartFile "$base\logic\dart_math.dart" @"
import 'dart:math';

class DartHit {
  final int sector;
  final int multiplier;
  DartHit(this.sector, this.multiplier);
  @override
  String toString() => 'Sector $sector x$multiplier';
}

class DartMath {
  static const double boardRadius = 200.0;
  static const double bullRadius = 12.7;
  static const double outerBullRadius = 31.8;
  static const double doubleRingInner = 170.0;
  static const double doubleRingOuter = 200.0;
  static const double trebleRingInner = 107.0;
  static const double trebleRingOuter = 115.0;

  static const List<int> sectorOrder = [
    6,13,4,18,1,20,5,12,9,14,
    11,8,16,7,19,3,17,2,15,10
  ];

  static DartHit getHit(double x, double y) {
    double dx = x - boardRadius;
    double dy = y - boardRadius;
    double r = sqrt(dx*dx + dy*dy);
    double angle = atan2(dy, dx);
    double deg = (angle * 180 / pi + 360 + 90) % 360;
    int sectorIndex = (deg / 18).floor();
    int sector = sectorOrder[sectorIndex];
    if (r <= bullRadius) return DartHit(25,2);
    if (r <= outerBullRadius) return DartHit(25,1);
    if (r >= doubleRingInner && r <= doubleRingOuter) return DartHit(sector,2);
    if (r >= trebleRingInner && r <= trebleRingOuter) return DartHit(sector,3);
    if (r <= boardRadius) return DartHit(sector,1);
    return DartHit(0,0);
  }
}
"@

# === scoreboard_cricket_sa.dart ===
Write-DartFile "$base\screens\scoreboard_cricket_sa.dart" @"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import '../widgets/dartboard_widget.dart';
import '../widgets/player_stats_panel.dart';

class ScoreboardCricketSA extends StatefulWidget {
  final CricketSALogic cricketLogic;
  const ScoreboardCricketSA({Key? key, required this.cricketLogic}) : super(key: key);
  @override
  _ScoreboardCricketSAState createState() => _ScoreboardCricketSAState();
}

class _ScoreboardCricketSAState extends State<ScoreboardCricketSA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket SA')),
      drawer: PlayerStatsPanel(
        playerName: 'Mark',
        gamesPlayed: 42,
        winRate: 62,
        highScore: 140,
        threeDartAverage: 54.7,
        recentMatches: [
          {'game':'Cricket SA','result':'Won 192-165'},
          {'game':'501','result':'Lost 34-0'},
        ],
      ),
      body: Row(
        children: [
          Expanded(flex:2, child: DartboardWidget(cricketLogic: widget.cricketLogic,size:400)),
          Expanded(flex:3, child: Column(children:[
            Text('Player 1: ${widget.cricketLogic.player1Score}'),
            Text('Player 2: ${widget.cricketLogic.player2Score}'),
          ])),
        ],
      ),
    );
  }
}
"@

# === scoreboard_501.dart ===
Write-DartFile "$base\screens\scoreboard_501.dart" @"
import 'package:flutter/material.dart';
import '../logic/logic_501.dart';
import '../widgets/dartboard_widget.dart';
import '../widgets/player_stats_panel.dart';

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
      drawer: PlayerStatsPanel(
        playerName: 'Mark',
        gamesPlayed: 42,
        winRate: 62,
        highScore: 140,
        threeDartAverage: 54.7,
        recentMatches: [
          {'game':'Cricket SA','result':'Won 192-165'},
          {'game':'501','result':'Lost 34-0'},
        ],
      ),
      body: Row(
        children: [
          Expanded(flex:2, child: DartboardWidget(logic501: widget.logic501,size:400)),
          Expanded(flex:3, child: Column(children:[
            Text('Player 1: ${widget.logic501.player1Score}'),
            Text('Player 2: ${widget.logic501.player2Score}'),
          ])),
        ],
      ),
    );
  }
}
"@

# === full_history_screen.dart ===
Write-DartFile "$base\screens\full_history_screen.dart" @"
import 'package:flutter/material.dart';

class FullHistoryScreen extends StatelessWidget {
  final String playerName;
  final List<Map<String, dynamic>> matchHistory;

  const FullHistoryScreen({
    Key? key,
    required this.playerName,
    required this.matchHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$playerName - Full History')),
      body: ListView.builder(
        itemCount: matchHistory.length,
        itemBuilder: (context, index) {
          final match = matchHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(match['game'] ?? ''),
              subtitle: Text('Result: ${match['result']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Score: ${match['score'] ?? ''}'),
                  Text('Date: ${match['date'] ?? ''}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
"@

# === dartboard_widget.dart ===
Write-DartFile "$base\widgets\dartboard_widget.dart" @"
import 'package:flutter/material.dart';
import '../logic/dart_math.dart';
import '../logic/cricket_sa_logic.dart';
import '../logic/logic_501.dart';

class DartboardWidget extends StatelessWidget {
  final CricketSALogic? cricketLogic;
  final Logic501? logic501;
  final double size;

  const DartboardWidget({
    Key? key,
    this.cricketLogic,
    this.logic501,
    this.size = 400.0,
  }) : super(key: key);

  void _handleTap(BuildContext context, TapUpDetails details) {
    final localPos = details.localPosition;
    DartHit hit = DartMath.getHit(localPos.dx, localPos.dy);

    if (hit.sector == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missed the board!')),
      );
      return;
    }

    if (cricketLogic != null) {
      cricketLogic!.registerHit(hit.sector, hit.multiplier);
    }
    if (logic501 != null) {
      logic501!.registerHit(hit.sector, hit.multiplier);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hit: $hit')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(context, details),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dartboard.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
"@

# === player_stats_panel.dart ===
Write-DartFile "$base\widgets\player_stats_panel.dart" @"
import 'package:flutter/material.dart';
import '../screens/full_history_screen.dart';

class PlayerStatsPanel extends StatelessWidget {
  final String playerName;
  final int gamesPlayed;
  final double winRate;
  final int highScore;
  final double threeDartAverage;
  final List<Map<String, String>> recentMatches;

  const PlayerStatsPanel({
    Key? key,
    required this.playerName,
    required this.gamesPlayed,
    required this.winRate,
    required this.highScore,
    required this.threeDartAverage,
    required this.recentMatches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Text(
              'Player Stats: $playerName',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(title: Text('Games Played: $gamesPlayed')),
          ListTile(title: Text('Win Rate: ${winRate.toStringAsFixed(1)}%')),
          ListTile(title: Text('High Score: $highScore')),
          ListTile(
              title: Text('3-Dart Average: ${threeDartAverage.toStringAsFixed(1)}')),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Recent Matches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recentMatches.length,
              itemBuilder: (context, index) {
                final match = recentMatches[index];
                return ListTile(
                  title: Text(match['game'] ?? ''),
                  subtitle: Text(match['result'] ?? ''),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullHistoryScreen(
                          playerName: playerName,
                          matchHistory: recentMatches
                              .map((m) => {
                                    'game': m['game'],
                                    'result': m['result'],
                                    'score': m['result'],
                                    'date': DateTime.now()
                                        .toIso8601String()
                                        .substring(0, 10),
                                  })
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: const Text('View Full History'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
"@

Write-Host "✅ All Dart files created successfully under E:\Darts\lib"
