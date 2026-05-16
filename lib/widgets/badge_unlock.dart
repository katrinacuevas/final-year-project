// ========================================================================
// badge_unlock.dart
// ------------------------------------------------------------------------
// modal bottom sheet shown when the user earns a new milestone badge
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

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

// ----- badge sheet -----
class _BadgeSheet extends StatefulWidget {
  final String emoji, name, description;
  final Color accent;
  const _BadgeSheet({
    required this.emoji,
    required this.name,
    required this.description,
    required this.accent,
  });
  @override
  State<_BadgeSheet> createState() => _BadgeSheetState();
}

class _BadgeSheetState extends State<_BadgeSheet> with TickerProviderStateMixin {
  // two separate controllers, confetti plays once over the whole sheet,
  // trophy plays once in its own sized box
  late AnimationController _confettiCtrl;
  late AnimationController _trophyCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(vsync: this);
    _trophyCtrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _trophyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ----- main sheet content -----
        Container(
          decoration: BoxDecoration(
            color: _kBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: widget.accent.withValues(alpha: 0.6), width: 2.5),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 36),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // drag handle so the user knows they can swipe down to dismiss
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // ----- new badge unlocked pill -----
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.accent.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '🔓  NEW BADGE UNLOCKED',
                  style: GoogleFonts.fredoka(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: widget.accent, letterSpacing: 1.4,
                  ),
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.3, end: 0),

              const SizedBox(height: 16),

              // ----- trophy lottie -----
              Lottie.asset(
                'assets/animations/trophy.json',
                controller: _trophyCtrl,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                onLoaded: (comp) {
                  _trophyCtrl
                    ..duration = comp.duration
                    ..forward();
                },
              ),

              const SizedBox(height: 8),

              // ----- badge emoji with glow -----
              Stack(alignment: Alignment.center, children: [
                Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accent.withValues(alpha: 0.4),
                        blurRadius: 48, spreadRadius: 12,
                      ),
                    ],
                  ),
                ),
                // inner circle with the emoji centered
                Container(
                  width: 128, height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      widget.accent.withValues(alpha: 0.28),
                      _kCard,
                    ]),
                    border: Border.all(color: widget.accent, width: 2.5),
                  ),
                  child: Center(
                    child: Text(widget.emoji, style: const TextStyle(fontSize: 64)),
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

              // ----- sparkle row -----
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final bool isCenter = i == 2;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text('✨', style: TextStyle(fontSize: isCenter ? 24 : 16)),
                  )
                    .animate(delay: Duration(milliseconds: i * 90))
                    .scale(curve: Curves.elasticOut, duration: 500.ms)
                    .fadeIn();
                }),
              ),

              const SizedBox(height: 18),

              // ----- badge name and description -----
              Text(
                widget.name,
                style: GoogleFonts.fredoka(
                  fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.25, end: 0),

              const SizedBox(height: 8),

              Text(
                widget.description,
                style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white60),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 320.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // ----- dismiss button -----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Text(
                    '🏅  Add to my collection!',
                    style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ]),
          ),
        ),

        // ----- confetti overlay -----
        IgnorePointer(
          child: Lottie.asset(
            'assets/animations/confetti.json',
            controller: _confettiCtrl,
            fit: BoxFit.cover,
            onLoaded: (comp) {
              _confettiCtrl
                ..duration = comp.duration
                ..forward();
            },
          ),
        ),
      ],
    );
  }
}
