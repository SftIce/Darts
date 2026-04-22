# create_chalkboard_stats.ps1
# Run this script from your Flutter project root (E:\Darts)

$statsPath = "lib\screens\player_stats.dart"

# Ensure folder exists
New-Item -ItemType Directory -Force -Path (Split-Path $statsPath)

# Write Chalkboard Player Stats Screen
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

  const PlayerStats({
    super.key,
    required this.playerName,
    required this.profileImage,
    required this.gamesPlayed,
    required this.winRate,
    required this.highScore,
    required this.average,
    required this.recentMatches,
  });

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
        title: Text('Player Stats & History', style: chalkStyle(24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(profileImage),
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Text(playerName, style: chalkStyle(28)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Games Played: \$gamesPlayed', style: chalkStyle(20)),
            Text('Win Rate: \${winRate.toStringAsFixed(1)}%', style: chalkStyle(20)),
            Text('High Score: \$highScore', style: chalkStyle(20)),
            Text('3-Dart Average: \${average.toStringAsFixed(1)}', style: chalkStyle(20)),
            const SizedBox(height: 20),
            Text('Recent Matches:', style: chalkStyle(22)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentMatches.length,
                itemBuilder: (context, index) {
                  final match = recentMatches[index];
                  return Text(
                    '\${match['game']} – \${match['result']} \${match['score']}',
                    style: chalkStyle(18),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {},
                  child: Text('View Full History', style: chalkStyle(18)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {},
                  child: Text('Close', style: chalkStyle(18)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
"@ | Set-Content $statsPath

Write-Host "✅ Chalkboard Player Stats & History file created successfully."
