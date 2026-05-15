// baiting_complete.dart
// Results screen after the quiz — cat gives feedback, retry or claim XP.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import '../../widgets/badge_unlock.dart';
import 'baiting_cat_messages.dart';
import 'baiting_theme.dart';
import 'baiting_widgets.dart';

class BaitingCompleteStep extends StatefulWidget {
  final VoidCallback onDone, onRetry;
  final int score, total;
  const BaitingCompleteStep({super.key, required this.onDone, required this.onRetry,
    required this.score, required this.total});
  @override State<BaitingCompleteStep> createState() => _BaitingCompleteStepState();
}

class _BaitingCompleteStepState extends State<BaitingCompleteStep> {
  bool claiming = false;

  int get _stars {
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct == 1.0) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  Future<void> _finish(BuildContext ctx) async {
    if (claiming) return;
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'baiting_pro', stepsCompleted: 7, totalSteps: 7,
        stars: _stars, completed: true));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'baiting_pro', amount: 200);
      if (!ctx.mounted) return;
      await BadgeUnlock.show(ctx,
        emoji: '🎁',
        name: 'Baiting Pro',
        description: 'You can now spot a baiting trap before it catches you!',
        accent: kBaitAccent,
      );
      if (!ctx.mounted) return;
      widget.onDone();
    } catch (e) { debugPrint('Error: $e'); if (ctx.mounted) widget.onDone(); }
  }

  @override
  Widget build(BuildContext context) => _stars < 3 ? _buildRetry() : _buildSuccess(context);

  Widget _buildRetry() {
    final int missed = widget.total - widget.score;
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    final String encouragement = pct >= 0.6
      ? "So close! Just a couple more to go — you've got this!"
      : pct >= 0.4 ? "Good start! Review the lessons and give it another shot."
      : "Don't worry — each attempt makes you smarter and safer online!";

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kBaitCard,
            border: Border.all(color: kBaitRed.withValues(alpha: 0.4), width: 2)),
          child: const Center(child: Text('📖', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Not quite there yet!',
          style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBaitAccent.withValues(alpha: 0.15))),
          child: Row(children: [
            Expanded(child: Column(children: [
              Text('${widget.score}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kBaitGreen)),
              Text('correct', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('$missed', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: kBaitRed)),
              Text('to review', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(child: Column(children: [
              Text('${widget.total}', style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white54)),
              Text('total', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
            ])),
          ])),
        const SizedBox(height: 28),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onRetry, label: '🔄  Try Again'),
          message: encouragement,
          accentColor: kBaitRed,
        ),
      ]),
    );
  }

  Widget _buildSuccess(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
    child: Column(children: [
      Container(width: 110, height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [kBaitGold, kBaitBg],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: kBaitGold.withValues(alpha: 0.6), width: 2)),
        child: const Center(child: Text('🏆', style: TextStyle(fontSize: 54))))
        .animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Perfect Score! 🎉',
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text("You've completed Baiting Pro!",
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
      const SizedBox(height: 24),
      BaitingCard(child: Column(children: [
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
          decoration: BoxDecoration(color: kBaitGold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBaitGold.withValues(alpha: 0.4))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('⭐', style: TextStyle(fontSize: 22)), const SizedBox(width: 8),
            Text('+200 XP', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: kBaitGold)),
          ])),
      ])),
      const SizedBox(height: 16),
      BaitingInfoCard(color: kBaitAccent, emoji: '🎁', title: 'Badge incoming: Baiting Pro!',
        body: 'Claim your XP below — your badge is waiting for you!'),
      const SizedBox(height: 20),
      Align(alignment: Alignment.centerLeft,
        child: Text('WHAT YOU LEARNED',
          style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
      const SizedBox(height: 10),
      const BaitingSummaryTile(emoji: '🪤', text: 'What baiting is and how it uses greed and temptation'),
      const BaitingSummaryTile(emoji: '🧠', text: 'How baiters target what you love to hook you'),
      const BaitingSummaryTile(emoji: '💻', text: 'Online baiting examples — games, prizes, downloads'),
      const BaitingSummaryTile(emoji: '🖲️', text: 'Physical baiting — USB sticks and real-world traps'),
      const BaitingSummaryTile(emoji: '🚩', text: 'How to spot red flags before you fall for them'),
      const BaitingSummaryTile(emoji: '🔍', text: 'Real vs fake rewards — how to tell the difference'),
      const BaitingSummaryTile(emoji: '🛡️', text: 'What to do when you spot a bait'),
      const BaitingSummaryTile(emoji: '💬', text: '3 real-life chat simulation scenarios'),
      const SizedBox(height: 28),
      BaitingCatButton(
        button: BaitingNextButton(onTap: () => _finish(context), enabled: !claiming,
          label: claiming ? 'Claiming...' : '🎉  Claim your XP!'),
        message: BaitingCatMessages.completeMessage(3),
        accentColor: kBaitGold,
      ),
    ]),
  );
}