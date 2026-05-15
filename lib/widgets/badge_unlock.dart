import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

const Color _kBg   = Color(0xFF0D1117);
const Color _kCard = Color(0xFF161B2E);

class BadgeUnlock {
  static Future<void> show(
    BuildContext context, {
    required String emoji,
    required String name,
    required String description,
    required Color accent,
  }) async {
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BadgeSheet(
        emoji: emoji,
        name: name,
        description: description,
        accent: accent,
      ),
    );
  }
}

class _BadgeSheet extends StatelessWidget {
  final String emoji, name, description;
  final Color accent;

  const _BadgeSheet({
    required this.emoji,
    required this.name,
    required this.description,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: accent.withValues(alpha: 0.6), width: 2.5),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 36),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // drag handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // "NEW BADGE UNLOCKED" pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.5)),
            ),
            child: Text(
              '🔓  NEW BADGE UNLOCKED',
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: accent,
                letterSpacing: 1.4,
              ),
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.3, end: 0),

          const SizedBox(height: 28),

          // badge emoji with glow
          Stack(alignment: Alignment.center, children: [
            Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.4),
                    blurRadius: 48,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
            Container(
              width: 128, height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  accent.withValues(alpha: 0.28),
                  _kCard,
                ]),
                border: Border.all(color: accent, width: 2.5),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 64)),
              ),
            ),
          ])
          .animate()
          .scale(
            begin: const Offset(0.3, 0.3),
            curve: Curves.elasticOut,
            duration: 750.ms,
          )
          .then()
          .shimmer(duration: 1400.ms, color: Colors.white24),

          const SizedBox(height: 18),

          // sparkle row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final bool isCenter = i == 2;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '✨',
                  style: TextStyle(fontSize: isCenter ? 24 : 16),
                ),
              )
                  .animate(delay: Duration(milliseconds: i * 90))
                  .scale(curve: Curves.elasticOut, duration: 500.ms)
                  .fadeIn();
            }),
          ),

          const SizedBox(height: 18),

          // badge name
          Text(
            name,
            style: GoogleFonts.fredoka(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.25, end: 0),

          const SizedBox(height: 8),

          // description
          Text(
            description,
            style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white60),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 320.ms, duration: 400.ms),

          const SizedBox(height: 32),

          // dismiss button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text(
                '🏅  Add to my collection!',
                style: GoogleFonts.fredoka(
                    fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
