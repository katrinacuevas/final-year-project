// ========================================================================
// xp_award.dart
// ------------------------------------------------------------------------
// modal bottom sheet triggered after a lesson is completed
// calls UserService.addXp() then shows the amount earned, the updated
// XP progress bar, and a level-up celebration if the user ranked up
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:final_year_project/services/user_service.dart';
import 'cat_mascot.dart';
import 'cat_messages.dart';

const Color _kBg    = Color(0xFF0D1117);
const Color _kCard  = Color(0xFF161B2E);
const Color _kGreen = Color(0xFF00E676);

// ----- accent colour -----
// maps lesson IDs to their colours so the sheet matches the lesson's theme
Color _accentForLesson(String lessonId) {
  switch (lessonId) {
    case 'password_power':     return const Color(0xFFFFC857);
    case 'phishing_detective': return const Color(0xFF4FC3F7);
    case 'baiting_pro':        return const Color(0xFFFF8A65);
    case 'pretexting':         return const Color(0xFFBA68C8);
    default:                   return const Color(0xFF00D1FF);
  }
}

// ----- xp award -----
class XpAward {
  static Future<void> show(BuildContext context, {required String lessonId, required int amount, Color? accentColor}) async {
    final Color accent = accentColor ?? _accentForLesson(lessonId);
    final result = await UserService.instance.addXp(lessonId, amount);
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context, isDismissible: true, backgroundColor: Colors.transparent,
      builder: (_) => _XpSheet(
        amount: amount,
        accent: accent,
        // result is null when the user has already earned XP for this lesson
        alreadyAwarded: result == null,
        levelledUp: result?.levelledUp ?? false,
        newLevel: result?.newLevel ?? UserService.instance.level,
        newXp: result?.newXp ?? UserService.instance.xp,
        xpCeiling: UserService.instance.xpNeededForNextLevel,
        xpProgress: UserService.instance.xpProgress,
      ),
    );
  }
}

// ----- xp sheet -----
class _XpSheet extends StatefulWidget {
  final int amount;
  final Color accent;
  final bool alreadyAwarded, levelledUp;
  final int newLevel, newXp, xpCeiling;
  final double xpProgress;

  const _XpSheet({
    required this.amount,
    required this.accent,
    required this.alreadyAwarded,
    required this.levelledUp,
    required this.newLevel,
    required this.newXp,
    required this.xpCeiling,
    required this.xpProgress,
  });

  @override
  State<_XpSheet> createState() => _XpSheetState();
}

class _XpSheetState extends State<_XpSheet> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _barAnim;
  late AnimationController _confettiCtrl;
  late AnimationController _trophyCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = Tween<double>(begin: 0, end: widget.xpProgress)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _confettiCtrl = AnimationController(vsync: this);
    _trophyCtrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _confettiCtrl.dispose();
    _trophyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accent;
    // bar goes green on level up to match the level-up celebration colour
    final Color barColor = widget.levelledUp ? _kGreen : accent;

    // ----- cat dialogue -----
    final String catMessage = widget.levelledUp
        ? CatMessages.levelUp(widget.newLevel)
        : widget.alreadyAwarded
            ? CatMessages.xpAlreadyEarned()
            : CatMessages.xpEarned(widget.amount);
    final CatMood catMood = widget.levelledUp
        ? CatMood.excited
        : widget.alreadyAwarded
            ? CatMood.cheeky
            : CatMood.proud;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _kBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: accent.withValues(alpha: 0.35), width: 1.5)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // drag handle
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ----- cat mascot with message -----
              CatMascot(
                message: catMessage,
                accentColor: widget.levelledUp ? _kGreen : accent,
                mood: catMood,
                size: 90,
              ),
              const SizedBox(height: 20),

              // ----- level up celebration -----
              if (widget.levelledUp) ...[
                Lottie.asset(
                  'assets/animations/trophy.json',
                  controller: _trophyCtrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  onLoaded: (comp) {
                    _trophyCtrl
                      ..duration = comp.duration
                      ..forward();
                  },
                ),
                // star row 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                      Animate(
                        effects: [
                          ScaleEffect(delay: Duration(milliseconds: i * 80), curve: Curves.elasticOut, duration: 500.ms),
                          FadeEffect(delay: Duration(milliseconds: i * 80)),
                          MoveEffect(delay: Duration(milliseconds: i * 80), begin: const Offset(0, 20), end: Offset.zero),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('⭐', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _kGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _kGreen.withValues(alpha: 0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🎉', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Text('Level ${widget.newLevel}!',
                      style: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.w700, color: _kGreen)),
                  ]),
                ).animate().scale(curve: Curves.elasticOut),
              ]
              // ----- standard xp pill -----
              else if (!widget.alreadyAwarded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('⭐', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Text('+${widget.amount} XP',
                      style: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
                  ]),
                ).animate().scale(curve: Curves.elasticOut, duration: 600.ms).then().shimmer(duration: 1200.ms, color: Colors.white30),

              const SizedBox(height: 20),

              // ----- xp progress bar card -----
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _kCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.2)),
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: barColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: barColor.withValues(alpha: 0.4)),
                      ),
                      child: Text('Level ${widget.newLevel}',
                        style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: barColor)),
                    ),
                    Text('${widget.newXp} / ${widget.xpCeiling} XP',
                      style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
                  ]),
                  const SizedBox(height: 10),
                  // bar animates from 0 to the current progress so it fills up visually
                  AnimatedBuilder(
                    animation: _barAnim,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _barAnim.value,
                        minHeight: 10,
                        backgroundColor: barColor.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // ----- dismiss button -----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Text('Awesome! Let\'s go! 🚀',
                    style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),

        // ----- confetti overlay -----
        if (widget.levelledUp)
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
