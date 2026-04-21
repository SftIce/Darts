class CricketSALogic {
  Map<String, int> player1Marks = {
    '20': 0, '19': 0, '18': 0, '17': 0, '16': 0,
    '15': 0, '14': 0, '13': 0, '12': 0, '11': 0,
    '10': 0, 'Bull': 0
  };

  Map<String, int> player2Marks = {
    '20': 0, '19': 0, '18': 0, '17': 0, '16': 0,
    '15': 0, '14': 0, '13': 0, '12': 0, '11': 0,
    '10': 0, 'Bull': 0
  };

  int player1Score = 0;
  int player2Score = 0;

  String marker(int marks) {
    if (marks == 1) return "/";
    if (marks == 2) return "X";
    if (marks >= 3) return "ⓧ";
    return "";
  }

  void registerHit(String player, String number, int multiplier) {
    Map<String, int> marks = player == 'P1' ? player1Marks : player2Marks;
    Map<String, int> opponentMarks = player == 'P1' ? player2Marks : player1Marks;
    int score = player == 'P1' ? player1Score : player2Score;

    marks[number] = (marks[number] ?? 0) + multiplier;

    if (marks[number]! > 3) {
      if ((opponentMarks[number] ?? 0) < 3) {
        int value = number == 'Bull' ? 25 : int.parse(number);
        score += (marks[number]! - 3) * value;
      }
      marks[number] = 3;
    }

    if (player == 'P1') {
      player1Score = score;
    } else {
      player2Score = score;
    }
  }
}
