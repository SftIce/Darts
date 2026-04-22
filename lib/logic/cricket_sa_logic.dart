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
