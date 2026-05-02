import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  Color _getLevelColor(int level) {
    if (level >= 5) return Colors.orange;
    if (level >= 4) return Colors.cyan;
    if (level >= 3) return Colors.green;
    if (level >= 2) return Colors.purple;
    if (level >= 1) return Colors.pink;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final svc = UserService.instance;
    final profile = svc.profile;
    final xp = svc.xp;
    final level = svc.level;
    final xpCeiling = svc.xpNeededForNextLevel;

    final String name = profile?.username ?? 'Explorer';
    final double totalProgress = xpCeiling > 0 ? (xp / xpCeiling).clamp(0.0, 1.0) : 1.0;

    final List<String> greetings = [
      "Ready for a mission,",
      "Let's get learning,",
      "Great to see you,",
      "Awesome to have you back,",
      "Ready to level up,"
    ];
    final String greeting = greetings[name.length % greetings.length];

    final avatarColor = profile != null
        ? Color(int.parse(profile.avatarColour))
        : const Color(0xFFFFE4B5);

    final levelColor = _getLevelColor(level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: levelColor,
                  width: 3.0,
                ),
              ),
              child: Center(
                child: Text(
                  profile?.avatarEmoji ?? '🧒',
                  style: const TextStyle(fontSize: 42),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF1A2E45),
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: '$greeting ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '$name! 🌟',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: levelColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Level $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  tween: Tween<double>(begin: 0, end: totalProgress),
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          value >= 1.0 ? Colors.green : levelColor,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$xp / $xpCeiling XP',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}