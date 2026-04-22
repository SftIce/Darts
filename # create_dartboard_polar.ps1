# create_dartboard_polar.ps1
# Run this script from your Flutter project root (E:\Darts)

$widgetPath = "lib\widgets\dartboard_widget.dart"

New-Item -ItemType Directory -Force -Path (Split-Path $widgetPath)

@"
import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/cricket_sa_logic.dart';

class DartboardWidget extends StatefulWidget {
  final CricketSAGame game;
  final Function(int number, int multiplier) onHit;

  const DartboardWidget({super.key, required this.game, required this.onHit});

  @override
  State<DartboardWidget> createState() => _DartboardWidgetState();
}

class _DartboardWidgetState extends State<DartboardWidget> {
  // Dartboard sector order clockwise starting at 20 at top
  final List<int> sectors = [20,1,18,4,13,6,10,15,2,17,3,19,7,16,8,11,14,9,12,5];

  int _mapTapToNumber(Offset pos, Size size) {
    final center = Offset(size.width/2, size.height/2);
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final r = sqrt(dx*dx + dy*dy);
    final angle = atan2(dy, dx); // radians

    // Normalize angle: 0 at top (20), clockwise
    double deg = angle * 180 / pi;
    deg = (deg + 450) % 360; // rotate so 0° = top

    // Sector width ~18°
    int sectorIndex = (deg ~/ 18) % 20;
    int number = sectors[sectorIndex];

    // Radius thresholds (approximate)
    double boardRadius = size.width/2;
    if (r < boardRadius*0.05) return 25; // Bull inner
    if (r < boardRadius*0.12) return 25; // Bull outer
    if (r > boardRadius*0.95) return number; // Miss outside

    // Rings
    if (r > boardRadius*0.85) return number; // Double ring
    if (r > boardRadius*0.55 && r < boardRadius*0.65) return number; // Treble ring
    return number; // Single
  }

  int _mapMultiplier(Offset pos, Size size) {
    final center = Offset(size.width/2, size.height/2);
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final r = sqrt(dx*dx + dy*dy);
    double boardRadius = size.width/2;

    if (r < boardRadius*0.05) return 2; // Inner bull counts double
    if (r < boardRadius*0.12) return 1; // Outer bull
    if (r > boardRadius*0.85) return 2; // Double ring
    if (r > boardRadius*0.55 && r < boardRadius*0.65) return 3; // Treble ring
    return 1; // Single
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final number = _mapTapToNumber(localPos, box.size);
        final mult = _mapMultiplier(localPos, box.size);
        widget.onHit(number, mult);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white54),
        ),
        child: Center(
          child: Text(
            '🎯 Tap Dartboard',
            style: TextStyle(
              fontFamily: 'ChalkFont',
              color: Colors.white,
              fontSize: 24,
              shadows: [
                const Shadow(
                  blurRadius: 2,
                  color: Colors.white24,
                  offset: Offset(1,1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
"@ | Set-Content $widgetPath

Write-Host "✅ Interactive polar dartboard widget file created successfully."
