// ========================================================================
// phishing_complete.dart
// ------------------------------------------------------------------------
// results screen shown after finishing the phishing lesson
// cat gives feedback, user can retry or claim their XP
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import '../../widgets/badge_unlock.dart';
import 'phishing_cat_messages.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';

class PhishingCompleteStep extends StatefulWidget {
  final VoidCallback onDone, onRetry;
  final int score, total;
  const PhishingCompleteStep({super.key, required this.onDone, required this.onRetry,
    required this.score, required this.total});
  @override
  State<PhishingCompleteStep> createState() => _PhishingCompleteStepState();
}

class _PhishingCompleteStepState extends State<PhishingCompleteStep> {
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
        lessonId: 'phishing_detective', stepsCompleted: 7, totalSteps: 7,
        stars: _stars, completed: true));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'phishing_detective', amount: 150);
      if (!ctx.mounted) return;
      await BadgeUnlock.show(ctx,
        emoji: '🕵️',
        name: 'Phishing Detective',
        description: 'You can now spot a phishing attempt before it catches you!',
        accent: kPhishingAccent,
      );
      if (!ctx.mounted) return;
      widget.onDone();
    } catch (e) { debugPrint('Error: $e'); if (ctx.mounted) widget.onDone(); }
  }

  @override
  Widget build(BuildContext context) => _stars < 3 ? _buildRetry() : _buildSuccess(context);

  Widget _buildRetry() {
    final int missed = widget.total - widget.score;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kPhishingCard,
            border: Border.all(color: kPhishingRed.withValues(alpha: 0.4), width: 2)),
          child: const Center(child: Text('📖', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Not quite there yet!',
          style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kPhishingCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPhishingAccent.withValues(alpha: 0.15))),
          child: Row(children: [
            Expanded(child: Column(children: [
              Text('${widget.score}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kPhishingGreen)),
              Text('correct', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('$missed', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kPhishingRed)),
              Text('to review', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('${widget.total}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white54)),
              Text('total', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
          ])),
        const SizedBox(height: 28),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onRetry, label: '🔄  Try Again'),
          message: _encouragement,
          accentColor: kPhishingRed,
        ),
      ]),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [Color(0xFFFFD700), kPhishingBg],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.6), width: 2)),
          child: const Center(child: Text('🏆', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Perfect Score! 🎉',
          style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text("You've completed Phishing Detective!",
          style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
        const SizedBox(height: 24),
        PhishingDarkCard(child: Column(children: [
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
            decoration: BoxDecoration(color: const Color(0xFFFFD700).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('⭐', style: TextStyle(fontSize: 22)), const SizedBox(width: 8),
              Text('+150 XP', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700,
                color: const Color(0xFFFFD700))),
            ])),
        ])),
        const SizedBox(height: 16),
        PhishingInfoCard(color: kPhishingAccent, emoji: '🕵️', title: 'Badge incoming: Phishing Detective!',
          body: 'Claim your XP below — your badge is waiting for you!'),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft,
          child: Text('WHAT YOU LEARNED',
            style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
        const SizedBox(height: 10),
        const PhishingSummaryTile(emoji: '🎣', text: 'What phishing is and why it\'s called that'),
        const PhishingSummaryTile(emoji: '🎭', text: 'Who phishers pretend to be'),
        const PhishingSummaryTile(emoji: '📧', text: 'How to spot fake emails and messages'),
        const PhishingSummaryTile(emoji: '🚩', text: 'The red flags to look for in every message'),
        const PhishingSummaryTile(emoji: '🔗', text: 'How to spot suspicious links'),
        const PhishingSummaryTile(emoji: '🛡️', text: 'How to check a link safely'),
        const PhishingSummaryTile(emoji: '✅', text: 'What to do when you get a phishing message'),
        const PhishingSummaryTile(emoji: '💬', text: '3 real-life chat simulation scenarios'),
        const SizedBox(height: 28),
        PhishingCatButton(
          button: PhishingNextButton(onTap: () => _finish(context), enabled: !claiming,
            label: claiming ? 'Claiming...' : '🎉  Claim your XP!'),
          message: PhishingCatMessages.completeMessage(3),
          accentColor: const Color(0xFFFFD700),
        ),
      ]),
    );
  }
}