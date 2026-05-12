import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import 'password_cat_messages.dart';
import 'password_theme.dart';
import 'password_widgets.dart';

class CompleteStep extends StatefulWidget {
  final VoidCallback onDone, onRetry;
  final int score, total;
  const CompleteStep({
    super.key,
    required this.onDone,
    required this.onRetry,
    required this.score,
    required this.total,
  });
  @override
  State<CompleteStep> createState() => _CompleteStepState();
}

class _CompleteStepState extends State<CompleteStep> {
  bool claiming = false;

  int get _stars {
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct == 1.0) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  String get _encouragement {
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct >= 0.6) return "So close! Just a couple more to go — you've got this!";
    if (pct >= 0.4) return "Good start! Review the lessons and give it another shot.";
    return "Don't worry — each attempt makes you smarter and safer online!";
  }

  Future<void> _finish(BuildContext ctx) async {
    if (claiming) return;
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'password_power', stepsCompleted: 6, totalSteps: 6,
        stars: _stars, completed: true));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'password_power', amount: 200);
      if (!ctx.mounted) return;
      widget.onDone();
    } catch (e) {
      debugPrint('Error: $e');
      if (ctx.mounted) widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _stars < 3 ? _buildRetry() : _buildSuccess(context);
  }

  // ── Not enough stars — show score and retry ─────────────────────────────────
  Widget _buildRetry() {
    final int missed = widget.total - widget.score;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kPasswordCard,
            border: Border.all(color: kPasswordRed.withValues(alpha: 0.4), width: 2)),
          child: const Center(child: Text('📖', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Not quite there yet!',
          style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.15))),
          child: Row(children: [
            Expanded(child: Column(children: [
              Text('${widget.score}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kPasswordGreen)),
              Text('correct', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('$missed', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kPasswordRed)),
              Text('to review', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('${widget.total}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white54)),
              Text('total', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
          ])),
        const SizedBox(height: 28),
        PasswordCatButton(
          button: PasswordNextButton(onTap: widget.onRetry, label: '🔄  Try Again'),
          message: _encouragement,
          accentColor: kPasswordRed,
        ),
      ]),
    );
  }

  // ── Perfect score — full celebration ────────────────────────────────────────
  Widget _buildSuccess(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), kPasswordBg],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.6), width: 2)),
          child: const Center(child: Text('🏆', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Perfect Score! 🎉',
          style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text("You've completed Password Power!",
          style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
        const SizedBox(height: 24),

        // Stars + XP
        Container(width: double.infinity, padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.15))),
          child: Column(children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('⭐', style: TextStyle(fontSize: 30)), SizedBox(width: 4),
              Text('⭐', style: TextStyle(fontSize: 30)), SizedBox(width: 4),
              Text('⭐', style: TextStyle(fontSize: 30)),
            ]),
            const SizedBox(height: 8),
            Text('3 Stars — Amazing!',
              style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('⭐', style: TextStyle(fontSize: 22)), const SizedBox(width: 8),
                Text('+200 XP', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFD700))),
              ])),
          ])),
        const SizedBox(height: 16),
        InfoCard(color: kPasswordAccent, emoji: '🏅', title: 'Badge Unlocked: Password Master!',
          body: "You know how to build a password that even hackers can't crack — AND you made one yourself!"),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft,
          child: Text('WHAT YOU LEARNED',
            style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
        const SizedBox(height: 10),
        const SummaryTile(emoji: '🏠', text: 'Why passwords protect your online life'),
        const SummaryTile(emoji: '😬', text: 'How to spot a weak, hackable password'),
        const SummaryTile(emoji: '💪', text: 'The 4 rules of a strong password'),
        const SummaryTile(emoji: '🧠', text: 'The passphrase trick'),
        const SummaryTile(emoji: '🛠️', text: 'Built your very own strong password!'),
        const SizedBox(height: 28),
        PasswordCatButton(
          button: PasswordNextButton(
            onTap: () => _finish(context),
            enabled: !claiming,
            label: claiming ? 'Claiming...' : '🎉  Claim your XP!',
          ),
          message: PasswordCatMessages.completeMessage(3),
          accentColor: const Color(0xFFFFD700),
        ),
      ]),
    );
  }
}