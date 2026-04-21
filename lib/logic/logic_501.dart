// Basic 501 logic
class Logic501 {
  int player1Score = 501;
  int player2Score = 501;
  bool isGameOver = false;
  String winner = '';

  void registerHit(int sector, int multiplier) {
    int value = sector * multiplier;
    player1Score -= value;
    if (player1Score <= 0) {
      isGameOver = true;
      winner = 'Player 1';
    }
  }
}
