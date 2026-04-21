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
      appBar: AppBar(title: Text(' - Full History')),
      body: ListView.builder(
        itemCount: matchHistory.length,
        itemBuilder: (context, index) {
          final match = matchHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(match['game'] ?? ''),
              subtitle: Text('Result: '),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Score: '),
                  Text('Date: '),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
