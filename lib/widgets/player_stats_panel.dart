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
              'Player Stats: ',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(title: Text('Games Played: ')),
          ListTile(title: Text('Win Rate: %')),
          ListTile(title: Text('High Score: ')),
          ListTile(
              title: Text('3-Dart Average: ')),
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
