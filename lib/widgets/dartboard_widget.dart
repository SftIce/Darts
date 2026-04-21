import 'package:flutter/material.dart';
import '../logic/dart_math.dart';
import '../logic/cricket_sa_logic.dart';
import '../logic/logic_501.dart';

class DartboardWidget extends StatelessWidget {
  final CricketSALogic? cricketLogic;
  final Logic501? logic501;
  final double size;

  const DartboardWidget({
    Key? key,
    this.cricketLogic,
    this.logic501,
    this.size = 400.0,
  }) : super(key: key);

  void _handleTap(BuildContext context, TapUpDetails details) {
    final localPos = details.localPosition;
    DartHit hit = DartMath.getHit(localPos.dx, localPos.dy);

    if (hit.sector == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missed the board!')),
      );
      return;
    }

    if (cricketLogic != null) {
      cricketLogic!.registerHit(hit.sector, hit.multiplier);
    }
    if (logic501 != null) {
      logic501!.registerHit(hit.sector, hit.multiplier);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hit: ')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(context, details),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dartboard.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
