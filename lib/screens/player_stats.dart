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
        Text('Games Played: ', style: chalkStyle(20)),
        Text('Win Rate: %', style: chalkStyle(20)),
        Text('High Score: ', style: chalkStyle(20)),
        Text('3-Dart Average: ', style: chalkStyle(20)),
        const SizedBox(height: 20),
        Text('Recent Matches:', style: chalkStyle(22)),
        ...recentMatches.map((m) => Text(' –  ', style: chalkStyle(18))),
      ],
    );
  }
}
