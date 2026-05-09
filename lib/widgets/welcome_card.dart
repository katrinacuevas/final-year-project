import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, child) {
        final svc = UserService.instance;
        final profile = svc.profile;
        final xp = svc.xp;
        final level = svc.level;
        final xpCeiling = svc.xpNeededForNextLevel;

        final String name = profile?.username ?? 'Explorer';
        final double totalProgress =
            xpCeiling > 0 ? (xp / xpCeiling).clamp(0.0, 1.0) : 1.0;

        final List<String> greetings = [
          'Ready for a mission,',
          "Let's get learning,",
          'Great to see you,',
          'Awesome to have you back,',
          'Ready to level up,',
        ];
        final String greeting = greetings[name.length % greetings.length];

        final Color avatarColor = profile != null
            ? Color(int.parse(profile.avatarColour))
            : const Color(0xFFFFC857);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.6, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [avatarColor, const Color(0xFF0D1117)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: avatarColor.withValues(alpha: 0.7),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile?.avatarEmoji ?? '🧒',
                      style: const TextStyle(fontSize: 38),
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
                        style: GoogleFonts.fredoka(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: '$greeting '),
                          TextSpan(
                            text: '$name!',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00D1FF).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFF00D1FF), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'LEVEL $level',
                            style: GoogleFonts.fredoka(
                              color: const Color(0xFF00D1FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0, end: totalProgress),
                      builder: (context, value, child) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 7,
                          backgroundColor:
                              const Color(0xFF00D1FF).withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            value >= 1.0
                                ? const Color(0xFF00E676)
                                : const Color(0xFF00D1FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$xp / $xpCeiling XP',
                      style: GoogleFonts.fredoka(
                        fontSize: 11,
                        color: Colors.white38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}