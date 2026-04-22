import 'dart:math';

class CricketSAPlayer {
  final String name;
  Map<String, int> marks = {};
  int totalScore = 0;

  CricketSAPlayer(this.name) {
    // 20-10, plus Doubles (D), Trebles (T), and Bull
    var targets = ['20','19','18','17','16','15','14','13','12','11','10','D','T','Bull'];
    for (var t in targets) {
      marks[t] = 0;
    }
  }
}

class CricketSAGame {
  CricketSAPlayer player1;
  CricketSAPlayer player2;
  int currentTurnDarts = 0;
  bool isPlayer1Turn = true;
  int garyPlayerCount1 = 0;
  int garyPlayerCount2 = 0;

  CricketSAGame(this.player1, this.player2);

  CricketSAPlayer get activePlayer => isPlayer1Turn ? player1 : player2;
  CricketSAPlayer get opponent => isPlayer1Turn ? player2 : player1;

  void recordHit(String target, int multiplier) {
    if (currentTurnDarts >= 3) return;

    var p = activePlayer;
    var o = opponent;

    int currentMarks = p.marks[target] ?? 0;
    
    if (currentMarks < 3) {
      p.marks[target] = (p.marks[target] ?? 0) + multiplier;
      if (p.marks[target]! > 3) {
        int overflow = p.marks[target]! - 3;
        p.marks[target] = 3;
        _addPoints(p, o, target, overflow);
      }
    } else {
      _addPoints(p, o, target, multiplier);
    }

    currentTurnDarts++;
  }

  void _addPoints(CricketSAPlayer p, CricketSAPlayer o, String target, int mult) {
    if ((o.marks[target] ?? 0) < 3) {
      int val = 0;
      if (target == 'Bull') val = 25;
      else if (target == 'D' || target == 'T') val = 25; 
      else val = int.tryParse(target) ?? 0;
      
      p.totalScore += (val * mult);
    }
  }

  void garyPlayer() {
    if (isPlayer1Turn) garyPlayerCount1++;
    else garyPlayerCount2++;
    nextTurn();
  }

  void nextTurn() {
    currentTurnDarts = 0;
    isPlayer1Turn = !isPlayer1Turn;
  }
}
