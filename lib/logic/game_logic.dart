abstract class GameLogic {
  String get name;
  int dartsThrown = 0;
  bool isP1Turn = true;
  void handleHit(String target, int mult);
  bool isOver();
  String getWinner(String p1, String p2);
}

class CricketLogic extends GameLogic {
  @override String get name => "SA Cricket";
  Map<String, int> p1Marks = {};
  Map<String, int> p2Marks = {};
  int p1Score = 0, p2Score = 0;
  bool p1Opened = false, p2Opened = false;
  final List<String> targets = ['20','19','18','17','16','15','14','13','12','11','10','D','T','Bull'];

  CricketLogic() { for (var t in targets) { p1Marks[t] = 0; p2Marks[t] = 0; } }

  @override
  void handleHit(String target, int mult) {
    if (dartsThrown >= 3) return;
    bool isP1 = isP1Turn;
    
    // Rule: Open board with D, T, or Bull
    if (isP1 && !p1Opened) {
      if (mult > 1 || target == 'Bull') p1Opened = true;
    } else if (!isP1 && !p2Opened) {
      if (mult > 1 || target == 'Bull') p2Opened = true;
    }

    if ((isP1 && p1Opened) || (!isP1 && p2Opened)) {
      var active = isP1 ? p1Marks : p2Marks;
      var opponent = isP1 ? p2Marks : p1Marks;
      int cur = active[target] ?? 0;
      int opp = opponent[target] ?? 0;

      if (cur < 3) {
        int total = cur + mult;
        if (total > 3) {
          active[target] = 3;
          if (opp < 3) _score(target, total - 3);
        } else { active[target] = total; }
      } else if (opp < 3) {
        _score(target, mult);
      }
    }
    dartsThrown++;
  }

  void _score(String t, int m) {
    int val = (t == 'Bull' || t == 'D' || t == 'T') ? 25 : (int.tryParse(t) ?? 0);
    if (isP1Turn) p1Score += (val * m); else p2Score += (val * m);
  }

  @override bool isOver() {
    bool p1C = p1Marks.values.every((v) => v >= 3);
    bool p2C = p2Marks.values.every((v) => v >= 3);
    return (p1C && p1Score >= p2Score) || (p2C && p2Score >= p1Score);
  }
  @override String getWinner(String p1, String p2) => p1Score >= p2Score ? p1 : p2;
}

class X01Logic extends GameLogic {
  final int start;
  int p1Score, p2Score;
  X01Logic(this.start) : p1Score = start, p2Score = start;
  @override String get name => "$start";
  @override void handleHit(String t, int m) {
    int val = t == 'Bull' ? 25 : (int.tryParse(t) ?? 0);
    if (isP1Turn) { if (p1Score - (val*m) >= 0) p1Score -= (val*m); }
    else { if (p2Score - (val*m) >= 0) p2Score -= (val*m); }
    dartsThrown++;
  }
  @override bool isOver() => p1Score == 0 || p2Score == 0;
  @override String getWinner(String p1, String p2) => p1Score == 0 ? p1 : p2;
}
