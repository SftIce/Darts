class CricketSALogic {
  // Use int keys for numbers 15-20 + 25 (outer bull). Inner bull is handled as 2 marks on 25.
  final Map<int, int> p1Marks = {15: 0, 16: 0, 17: 0, 18: 0, 19: 0, 20: 0, 25: 0};
  final Map<int, int> p2Marks = {15: 0, 16: 0, 17: 0, 18: 0, 19: 0, 20: 0, 25: 0};

  int p1Score = 0;
  int p2Score = 0;
  bool isP1Turn = true;

  // Get display symbol for the scoreboard UI: /  X  ⓧ
  String getMarkSymbol(int number, bool forP1) {
    final marks = forP1 ? (p1Marks[number] ?? 0) : (p2Marks[number] ?? 0);
    if (marks == 0) return '';
    if (marks == 1) return '/';
    if (marks == 2) return 'X';
    return 'ⓧ'; // 3 or more = closed
  }

  // Main method called from the dartboard click
  void registerHit(int baseScore, int multiplier, {required bool isP1}) {
    if (baseScore == 0) return; // Gary Player miss

    // Only valid Cricket numbers: 15-20 and Bull (25/50)
    if (!p1Marks.containsKey(baseScore) && baseScore != 50) return;

    final targetNumber = (baseScore == 50) ? 25 : baseScore;
    final marksToAdd = (baseScore == 50) ? 2 : multiplier; // inner bull = 2 marks

    final myMarksMap = isP1 ? p1Marks : p2Marks;
    final oppMarksMap = isP1 ? p2Marks : p1Marks;

    int currentMarks = myMarksMap[targetNumber] ?? 0;
    int pointsThisHit = 0;

    if (currentMarks >= 3) {
      // Already closed by me → score points only if opponent hasn't closed it
      if ((oppMarksMap[targetNumber] ?? 0) < 3) {
        pointsThisHit = baseScore * multiplier;
      }
    } else {
      // Still opening/closing this number
      final newMarks = currentMarks + marksToAdd;

      if (newMarks > 3) {
        // Excess marks score points if opponent is still open
        final excess = newMarks - 3;
        if ((oppMarksMap[targetNumber] ?? 0) < 3) {
          pointsThisHit = excess * baseScore;
        }
        myMarksMap[targetNumber] = 3; // cap at 3
      } else {
        myMarksMap[targetNumber] = newMarks;
      }
    }

    if (pointsThisHit > 0) {
      if (isP1) {
        p1Score += pointsThisHit;
      } else {
        p2Score += pointsThisHit;
      }
    }

    // Optional: auto-switch turn (you can manage this from the UI with a dart counter instead)
    // isP1Turn = !isP1Turn;
  }

  // Reset for new game
  void reset() {
    p1Marks.updateAll((key, value) => 0);
    p2Marks.updateAll((key, value) => 0);
    p1Score = 0;
    p2Score = 0;
    isP1Turn = true;
  }

  bool isNumberClosed(int number, bool forP1) {
    final marks = forP1 ? (p1Marks[number] ?? 0) : (p2Marks[number] ?? 0);
    return marks >= 3;
  }
}
