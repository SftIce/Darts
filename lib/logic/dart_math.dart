import 'dart:math' as math;

class DartHit {
  final int score;
  final int multiplier;
  final bool isGaryPlayer;
  DartHit({required this.score, required this.multiplier, this.isGaryPlayer = false});
}

class DartMath {
  static DartHit getHit(double dx, double dy, double width) {
    double center = width / 2;
    double x = dx - center;
    double y = dy - center;
    double distance = math.sqrt(x * x + y * y);
    double radius = center;

    if (distance > radius * 0.92) return DartHit(score: 0, multiplier: 1, isGaryPlayer: true);
    if (distance < radius * 0.05) return DartHit(score: 25, multiplier: 2);
    if (distance < radius * 0.12) return DartHit(score: 25, multiplier: 1);

    double angle = (math.atan2(y, x) * 180 / math.pi + 90 + 9) % 360;
    if (angle < 0) angle += 360;
    List<int> board = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];
    int score = board[(angle / 18).floor() % 20];

    int mult = 1;
    if (distance > radius * 0.55 && distance < radius * 0.62) mult = 3;
    if (distance > radius * 0.85 && distance < radius * 0.92) mult = 2;

    return DartHit(score: score, multiplier: mult);
  }
}
