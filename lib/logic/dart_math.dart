import 'dart:math' as math;

class DartHit {
  final int score;           // the base number (1-20, 25, or 50)
  final int multiplier;      // 1 = single, 2 = double, 3 = triple
  final bool isMiss;         // true for wire / outer buffer / Gary Player
  final String ring;         // 'single', 'double', 'triple', 'single_bull', 'double_bull'

  DartHit({
    required this.score,
    required this.multiplier,
    this.isMiss = false,
    this.ring = 'single',
  });

  int get points => isMiss ? 0 : score * multiplier;

  @override
  String toString() => 'DartHit(score: $score, mult: $multiplier, miss: $isMiss, points: $points)';
}

class DartMath {
  // Calibrated for a standard 300px dartboard image (adjust slightly if your image has padding/borders)
  static const double kBoardSize = 300.0;
  static const double kCenter = kBoardSize / 2;

  // Radii percentages based on real dartboard proportions (fine-tuned for 300px)
  static const double kMaxRadius = 148.0;           // outer edge of double wire
  static const double kWireBuffer = 2.5;            // Gary Player tolerance for wires

  static const double kOuterDouble = 148.0;
  static const double kInnerDouble = 128.0;
  static const double kOuterTriple = 98.0;
  static const double kInnerTriple = 78.0;
  static const double kOuterBull = 32.0;
  static const double kInnerBull = 12.5;

  // Standard dartboard sector order (20 at top, clockwise)
  static const List<int> _sectors = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];

  static DartHit calculate(double clickX, double clickY) {
    final dx = clickX - kCenter;
    final dy = clickY - kCenter;
    final distance = math.sqrt(dx * dx + dy * dy);

    // 1. Outer miss / Gary Player (anything clearly outside the board)
    if (distance > kMaxRadius + kWireBuffer) {
      return DartHit(score: 0, multiplier: 1, isMiss: true, ring: 'miss');
    }

    // 2. Bullseye (special case - no angle needed)
    if (distance <= kInnerBull) {
      return DartHit(score: 50, multiplier: 2, ring: 'double_bull');
    }
    if (distance <= kOuterBull) {
      return DartHit(score: 25, multiplier: 1, ring: 'single_bull');
    }

    // 3. Determine ring with wire buffers (Gary Player zones)
    String ring = 'single';
    int multiplier = 1;

    if (distance >= kInnerDouble - kWireBuffer && distance <= kOuterDouble + kWireBuffer) {
      ring = 'double';
      multiplier = 2;
    } else if (distance >= kInnerTriple - kWireBuffer && distance <= kOuterTriple + kWireBuffer) {
      ring = 'triple';
      multiplier = 3;
    } else if (distance < kInnerTriple - kWireBuffer || 
               (distance > kOuterDouble + kWireBuffer && distance <= kMaxRadius + kWireBuffer)) {
      // inner single or outer single area
      ring = 'single';
    } else {
      // Hit a wire between rings → Gary Player miss
      return DartHit(score: 0, multiplier: 1, isMiss: true, ring: 'miss');
    }

    // 4. Calculate angle - centered on 20 at top, clockwise
    double angleDeg = math.atan2(dy, dx) * 180 / math.pi;
    angleDeg = (360 - angleDeg + 9.0) % 360;   // +9° offset to perfectly center 20

    final sectorIndex = ((angleDeg / 18.0) % 20).floor();
    final score = _sectors[sectorIndex];

    return DartHit(
      score: score,
      multiplier: multiplier,
      isMiss: false,
      ring: ring,
    );
  }
}
