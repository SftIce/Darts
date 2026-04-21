class Logic501 {
  int p1Score = 501;
  int p2Score = 501;
  bool isP1Turn = true;

  void submitScore(int points) {
    if (isP1Turn) {
      if (p1Score - points >= 0) p1Score -= points;
    } else {
      if (p2Score - points >= 0) p2Score -= points;
    }
    isP1Turn = !isP1Turn;
  }
}
