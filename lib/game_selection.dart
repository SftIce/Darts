import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/scoreboard_501.dart';
import 'screens/scoreboard_cricket_sa.dart';   // ← Make sure this line is present

class GameSelection extends StatelessWidget {
  const GameSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Colors.grey.withOpacity(0.05), Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Title Section
            Text(
              "DARTS",
              style: GoogleFonts.blackOpsOne(
                color: Colors.white,
                fontSize: 80,
                letterSpacing: 10,
              ),
            ),
            Text(
              "SCOREMASTER PRO",
              style: GoogleFonts.oswald(
                color: Colors.orange,
                fontSize: 18,
                letterSpacing: 5,
              ),
            ),

            const SizedBox(height: 80),

            // Game Mode Selection
            _buildMenuCard(
              context,
              "X01 COUNTDOWN",
              "301, 501, 701 - Traditional Scoring",
              Icons.timer_outlined,
              const Scoreboard501(),
              const Color(0xFF1A3E5C),
            ),
            const SizedBox(height: 20),

            _buildMenuCard(
              context,
              "CRICKET (SA)",
              "South African Rules - / X ⓧ System",
              Icons.sports_cricket,
              const ScoreboardCricketSA(),        // ← const added (better for performance)
              const Color(0xFF7A431D),
            ),
            const SizedBox(height: 20),

            _buildMenuCard(
              context,
              "PLAYER HISTORY",
              "View past matches and averages",
              Icons.bar_chart,
              null,
              Colors.white10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
    Widget? target,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        if (target != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
        }
      },
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(8),   // ← small polish
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 15),
          ],
        ),
      ),
    );
  }
}
