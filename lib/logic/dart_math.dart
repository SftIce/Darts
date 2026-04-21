import 'dart:math';

class DartHit {
  final int sector;
  final int multiplier;
  DartHit(this.sector, this.multiplier);
  @override
  String toString() => 'Sector  x';
}

class DartMath {
  static const double boardRadius = 200.0;
  static const double bullRadius = 12.7;
  static const double outerBullRadius = 31.8;
  static const double doubleRingInner = 170.0;
  static const double doubleRingOuter = 200.0;
  static const double trebleRingInner = 107.0;
  static const double trebleRingOuter = 115.0;

  static const List<int> sectorOrder = [
    6,13,4,18,1,20,5,12,9,14,
    11,8,16,7,19,3,17,2,15,10
  ];

  static DartHit getHit(double x, double y) {
    double dx = x - boardRadius;
    double dy = y - boardRadius;
    double r = sqrt(dx*dx + dy*dy);
    double angle = atan2(dy, dx);
    double deg = (angle * 180 / pi + 360 + 90) % 360;
    int sectorIndex = (deg / 18).floor();
    int sector = sectorOrder[sectorIndex];
    if (r <= bullRadius) return DartHit(25,2);
    if (r <= outerBullRadius) return DartHit(25,1);
    if (r >= doubleRingInner && r <= doubleRingOuter) return DartHit(sector,2);
    if (r >= trebleRingInner && r <= trebleRingOuter) return DartHit(sector,3);
    if (r <= boardRadius) return DartHit(sector,1);
    return DartHit(0,0);
  }
}
