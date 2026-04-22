# create_dartboard_widget.ps1
# Run this script from your Flutter project root (E:\Darts)

$widgetPath = "lib\widgets\dartboard_widget.dart"

# Ensure folder exists
New-Item -ItemType Directory -Force -Path (Split-Path $widgetPath)

# Write Interactive Dartboard Widget
@"
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
  // Placeholder mapping: in real version, use polar coordinates
  int _mapTapToNumber(Offset position, Size size) {
    // Simple demo: divide vertically into segments
    double segmentHeight = size.height / 11;
    int index = (position.dy ~/ segmentHeight);
    List<int> targets = [20,19,18,17,16,15,14,13,12,11,10];
    if (index >= 0 && index < targets.length) {
      return targets[index];
    }
    return 25; // Bull
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final number = _mapTapToNumber(localPos, box.size);
        widget.onHit(number, 1); // default single hit
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

Write-Host "✅ Interactive Dartboard widget file created successfully."
