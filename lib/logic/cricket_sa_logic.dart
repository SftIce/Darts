// Basic Cricket SA logic
class CricketSALogic {
  final List<int> targets = [20,19,18,17,16,15,14,13,12,10,25];
  int player1Score = 0;
  int player2Score = 0;
  Map<int,String> player1Marks = {};
  Map<int,String> player2Marks = {};

  void registerHit(int sector, int multiplier) {
    // TODO: implement full scoring logic
    player1Score += sector * multiplier;
  }
}
