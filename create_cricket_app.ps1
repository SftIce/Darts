# create_cricket_app.ps1
# Run this script from your Flutter project root (E:\Darts)

# Paths
$logicPath      = "lib\logic\cricket_sa_logic.dart"
$scoreboardPath = "lib\screens\scoreboard_cricket_sa.dart"
$statsPath      = "lib\screens\player_stats.dart"
$layoutPath     = "lib\screens\cricket_sa_layout.dart"
$dartboardPath  = "lib\widgets\dartboard_widget.dart"
$mainPath       = "lib\main.dart"

# Ensure folders exist
New-Item -ItemType Directory -Force -Path (Split-Path $logicPath)
New-Item -ItemType Directory -Force -Path (Split-Path $scoreboardPath)
New-Item -ItemType Directory -Force -Path (Split-Path $statsPath)
New-Item -ItemType Directory -Force -Path (Split-Path $layoutPath)
New-Item -ItemType Directory -Force -Path (Split-Path $dartboardPath)
New-Item -ItemType Directory -Force -Path (Split-Path $mainPath)

# Logic file
@"
class CricketSAPlayer {
  final String name;
  Map<int, int> marks = {};
  Map<int, int> score = {};

  CricketSAPlayer(this.name) {
    for (var n = 10; n <= 20; n++) {
      marks[n] = 0;
      score[n] = 0;
    }
    marks[25] = 0; // Bull
    score[25] = 0;
  }
}

class CricketSAGame {
  CricketSAPlayer player1;
  CricketSAPlayer player2;

  CricketSAGame(this.player1, this.player2);

  void addHit(CricketSAPlayer player, CricketSAPlayer opponent, int number, int multiplier) {
    int currentMarks = player.marks[number] ?? 0;
    if (currentMarks < 3) {
      player.marks[number] = (player.marks[number] ?? 0) + multiplier;
      if (player.marks[number]! > 3) player.marks[number] = 3;
    } else {
      if ((opponent.marks[number] ?? 0) < 3) {
        player.score[number] = (player.score[number] ?? 0) + (number * multiplier);
      }
    }
  }

  int totalScore(CricketSAPlayer player) {
    return player.score.values.fold(0, (a, b) => a + b);
  }
}
"@ | Set-Content $logicPath

# Scoreboard
@"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class ScoreboardCricketSA extends StatelessWidget {
  final CricketSAGame game;
  ScoreboardCricketSA({Key? key, required this.game}) : super(key: key);

  final List<int> targets = [20,19,18,17,16,15,14,13,12,11,10,25];

  TextStyle chalkStyle(double size) => TextStyle(
    fontFamily: 'ChalkFont',
    color: Colors.white,
    fontSize: size,
    shadows: [
      Shadow(
        blurRadius: 2,
        color: Colors.white24,
        offset: Offset(1,1),
      )
    ],
  );

  Widget buildMarks(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => Text(i < count ? 'X' : '', style: chalkStyle(20))),
    );
  }

  TableRow buildRow(int number) {
    final p1Marks = game.player1.marks[number] ?? 0;
    final p2Marks = game.player2.marks[number] ?? 0;
    final p1Score = game.player1.score[number] ?? 0;
    final p2Score = game.player2.score[number] ?? 0;

    return TableRow(children: [
      buildMarks(p1Marks),
      Center(child: Text(number == 25 ? 'Bull' : number.toString(), style: chalkStyle(20))),
      buildMarks(p2Marks),
      Center(child: Text(p1Score.toString(), style: chalkStyle(20))),
      Center(child: Text(p2Score.toString(), style: chalkStyle(20))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final p1Total = game.totalScore(game.player1);
    final p2Total = game.totalScore(game.player2);
    final diff = p1Total - p2Total;

    return Table(
      border: TableBorder.all(color: Colors.white54),
      children: [
        TableRow(children: [
          Center(child: Text(game.player1.name, style: chalkStyle(22))),
          Center(child: Text('Target', style: chalkStyle(22))),
          Center(child: Text(game.player2.name, style: chalkStyle(22))),
          Center(child: Text('Score P1', style: chalkStyle(22))),
          Center(child: Text('Score P2', style: chalkStyle(22))),
        ]),
        ...targets.map((n) => buildRow(n)).toList(),
        TableRow(children: [
          Center(child: Text(p1Total.toString(), style: chalkStyle(24))),
          Center(child: Text('TOTAL', style: chalkStyle(24))),
          Center(child: Text(p2Total.toString(), style: chalkStyle(24))),
          Center(child: Text('Winning by: $diff', style: chalkStyle(18))),
          Center(child: Text('Losing by: ${-diff}', style: chalkStyle(18))),
        ])
      ],
    );
  }
}
"@ | Set-Content $scoreboardPath

# Player Stats
@"
import 'package:flutter/material.dart';

class PlayerStats extends StatelessWidget {
  final String playerName;
  final String profileImage;
  final int gamesPlayed;
  final double winRate;
  final int highScore;
  final double average;
  final List<Map<String, dynamic>> recentMatches;

  PlayerStats({
    Key? key,
    required this.playerName,
    required this.profileImage,
    required this.gamesPlayed,
    required this.winRate,
    required this.highScore,
    required this.average,
    required this.recentMatches,
  }) : super(key: key);

  TextStyle chalkStyle(double size) => TextStyle(
    fontFamily: 'ChalkFont',
    color: Colors.white,
    fontSize: size,
    shadows: [
      Shadow(
        blurRadius: 2,
        color: Colors.white24,
        offset: Offset(1,1),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          CircleAvatar(backgroundImage: AssetImage(profileImage), radius: 40),
          const SizedBox(width: 16),
          Text(playerName, style: chalkStyle(28)),
        ]),
        const SizedBox(height: 20),
        Text('Games Played: $gamesPlayed', style: chalkStyle(20)),
        Text('Win Rate: ${winRate.toStringAsFixed(1)}%', style: chalkStyle(20)),
        Text('High Score: $highScore', style: chalkStyle(20)),
        Text('3-Dart Average: ${average.toStringAsFixed(1)}', style: chalkStyle(20)),
        const SizedBox(height: 20),
        Text('Recent Matches:', style: chalkStyle(22)),
        ...recentMatches.map((m) => Text('${m['game']} – ${m['result']} ${m['score']}', style: chalkStyle(18))),
      ],
    );
  }
}
"@ | Set-Content $statsPath

# Layout
@"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import 'scoreboard_cricket_sa.dart';
import 'player_stats.dart';
import '../widgets/dartboard_widget.dart';

class CricketSALayout extends StatefulWidget {
  final CricketSAGame game;
  CricketSALayout({Key? key, required this.game}) : super(key: key);

  @override
  State<CricketSALayout> createState() => _CricketSALayoutState();
}

class _CricketSALayoutState extends State<CricketSALayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('South African Cricket'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: DartboardWidget(
              game: widget.game,
              onHit: (number, mult) {
                setState(() {
                  widget.game.addHit(
                    widget.game.player1,
                    widget.game.player2,
                    number,
                    mult,
                  );
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: ScoreboardCricketSA(game: widget.game),
          ),
                    Expanded(
            flex: 3,
            child: PlayerStats(
              playerName: widget.game.player1.name,
              profileImage: 'assets/images/profile.png',
              gamesPlayed: 42,
              winRate: 62,
              highScore: 140,
              average: 54.7,
              recentMatches: [
                {'game': 'Cricket SA', 'result': 'Won', 'score': '192 - 165'},
                {'game': '501', 'result': 'Lost', 'score': '34 - 0'},
                {'game': 'Shanghai', 'result': 'Won', 'score': '72 - 65'},
                {'game': 'Around the Clock', 'result': 'Won', 'score': '20 - 18'},
                {'game': 'Killer', 'result': 'Lost', 'score': 'Eliminated'},
              ],
            ),
          ),
        ],
      ),
    );
  }
}
