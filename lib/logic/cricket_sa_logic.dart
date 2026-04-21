class CricketSALogic {
  Map<String, int> p1Marks = {"20":0,"19":0,"18":0,"17":0,"16":0,"15":0,"14":0,"13":0,"12":0,"11":0,"10":0,"Bull":0};
  Map<String, int> p2Marks = {"20":0,"19":0,"18":0,"17":0,"16":0,"15":0,"14":0,"13":0,"12":0,"11":0,"10":0,"Bull":0};
  int p1Score = 0;
  int p2Score = 0;

  void registerHit(String num, int mult, bool isP1) {
    var marks = isP1 ? p1Marks : p2Marks;
    marks[num] = (marks[num] ?? 0) + mult;
  }
}
