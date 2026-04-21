class Logic501 {
  int player1Score = 501;
  int player2Score = 501;
  String currentPlayer = 'P1';

  void registerHit(String player, int value, int multiplier) {
    int hitValue = value * multiplier;
    if (player == 'P1') {
      player1Score -= hitValue;
      if (player1Score < 0) player1Score += hitValue; // bust
    } else {
      player2Score -= hitValue;
      if (player2Score < 0) player2Score += hitValue; // bust
    }
  }

  bool checkWin(String player, int multiplier) {
    int score = player == 'P1' ? player1Score : player2Score;
    return score == 0 && multiplier == 2; // must finish on double
  }
}
