# create_chalkboard_layout.ps1
# Run this script from your Flutter project root (E:\Darts)

$layoutPath = "lib\screens\cricket_sa_layout.dart"

# Ensure folder exists
New-Item -ItemType Directory -Force -Path (Split-Path $layoutPath)

# Write Combined Layout Screen
@"
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';
import 'scoreboard_cricket_sa.dart';
import 'player_stats.dart';

class CricketSALayout extends StatelessWidget {
  final CricketSAGame game;
  const CricketSALayout({super.key, required this.game});

  TextStyle chalkStyle(double size) => TextStyle(
    fontFamily: 'ChalkFont', // Add ChalkFont in pubspec.yaml
    color: Colors.white,
    fontSize: size,
    shadows: [
      const Shadow(
        blurRadius: 2,
        color: Colors.white24,
        offset: Offset(1,1),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('South African Cricket', style: chalkStyle(26)),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Dartboard placeholder
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white54),
              ),
              child: Center(
                child: Text('🎯 Dartboard Here', style: chalkStyle(24)),
              ),
            ),
          ),

          // Center: Scoreboard
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white54),
              ),
              child: ScoreboardCricketSA(game: game),
            ),
          ),

          // Right: Player Stats
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white54),
              ),
              child: PlayerStats(
                playerName: game.player1.name,
                profileImage: 'assets/profile.png', // replace with actual image
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
          ),
        ],
      ),
    );
  }
}
"@ | Set-Content $layoutPath

Write-Host "✅ Combined chalkboard layout file created successfully."
