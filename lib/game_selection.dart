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
