import 'package:flutter/material.dart';
import 'dart:math' as math;

class DartboardWidget extends StatelessWidget {
  final Function(String, int) onHit;
  const DartboardWidget({required this.onHit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return GestureDetector(
        onTapUp: (details) {
          double x = details.localPosition.dx - (box.maxWidth / 2);
          double y = details.localPosition.dy - (box.maxHeight / 2);
          double dist = math.sqrt(x * x + y * y);
          double angle = (math.atan2(y, x) * 180 / math.pi + 360) % 360;
          double s = box.maxWidth / 300;
          if (dist < 8 * s) { onHit('Bull', 2); return; }
          if (dist < 18 * s) { onHit('Bull', 1); return; }
          List<int> segs = [6, 13, 4, 18, 1, 20, 5, 12, 9, 14, 11, 8, 16, 7, 19, 3, 17, 2, 15, 10];
          int idx = (((angle + 9) % 360) / 18).floor();
          int mult = 1;
          if (dist > 85 * s && dist < 105 * s) mult = 3;
          if (dist > 135 * s && dist < 155 * s) mult = 2;
          onHit(segs[idx].toString(), mult);
        },
        child: Image.asset('assets/dartboard.png', fit: BoxFit.contain),
      );
    });
  }
}
