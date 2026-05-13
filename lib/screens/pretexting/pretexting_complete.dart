// pretexting_complete.dart
// Results screen after the quiz — cat gives feedback, retry or claim XP.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import 'pretexting_cat_messages.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';

class PretextingCompleteStep extends StatefulWidget {
  final VoidCallback onDone, onRetry;
  final int score, total;
  const PretextingCompleteStep({
    super.key,
    required this.onDone,
    required this.onRetry,
    required this.score,
    required this.total,
  });
  @override
  State<PretextingCompleteStep> createState() =>
      _PretextingCompleteStepState();
}

class _PretextingCompleteStepState extends State<PretextingCompleteStep> {
  bool claiming = false;

  int get _stars {
    final pct =
        widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct == 1.0) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  Future<void> _finish(BuildContext ctx) async {
    if (claiming) return;
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'pretexting',
        stepsCompleted: 5,
        totalSteps: 5,
        stars: _stars,
        completed: true,
      ));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'pretexting', amount: 180);
      if (!ctx.mounted) return;
      widget.onDone();
    } catch (e) {
      debugPrint('Error: $e');
      if (ctx.mounted) widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) =>
      _stars < 3 ? _buildRetry() : _buildSuccess(context);

  Widget _buildRetry() {
    final int missed = widget.total - widget.score;
    final pct =
        widget.total == 0 ? 0.0 : widget.score / widget.total;
    final String encouragement = pct >= 0.6
        ? "So close! Just a couple more to go — you've got this! 💪"
        : pct >= 0.4
            ? "Good start! Review the lessons and give it another shot."
            : "Don't worry — every try makes you smarter and safer online!";

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPretextCard,
            border: Border.all(
                color: kPretextRed.withValues(alpha: 0.4), width: 2),
          ),
          child: const Center(
              child: Text('📖', style: TextStyle(fontSize: 54))),
        ).animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Not quite there yet!',
            style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPretextCard,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: kPretextAccent.withValues(alpha: 0.15)),
          ),
          child: Row(children: [
            Expanded(
                child: Column(children: [
              Text('${widget.score}',
                  style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: kPretextGreen)),
              Text('correct',
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(
                child: Column(children: [
              Text('$missed',
                  style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: kPretextRed)),
              Text('to review',
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white38)),
            ])),
            Container(width: 1, height: 44, color: Colors.white12),
            Expanded(
                child: Column(children: [
              Text('${widget.total}',
                  style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54)),
              Text('total',
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white38)),
            ])),
          ]),
        ),
        const SizedBox(height: 28),
        PretextingCatButton(
          button: PretextingNextButton(
              onTap: widget.onRetry, label: '🔄  Try Again'),
          message: encouragement,
          accentColor: kPretextRed,
        ),
      ]),
    );
  }

  Widget _buildSuccess(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [kPretextGold, kPretextBg],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                  color: kPretextGold.withValues(alpha: 0.6), width: 2),
            ),
            child: const Center(
                child: Text('🏆', style: TextStyle(fontSize: 54))),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text('Perfect Score! 🎉',
              style: GoogleFonts.fredoka(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text("You've completed Pretexting Detective!",
              style: GoogleFonts.fredoka(
                  fontSize: 15, color: Colors.white54)),
          const SizedBox(height: 24),
          PretextingCard(
            child: Column(children: [
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⭐', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 4),
                    Text('⭐', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 4),
                    Text('⭐', style: TextStyle(fontSize: 30)),
                  ]),
              const SizedBox(height: 8),
              Text('3 Stars — Amazing!',
                  style: GoogleFonts.fredoka(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: kPretextGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: kPretextGold.withValues(alpha: 0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('⭐', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text('+180 XP',
                      style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kPretextGold)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          PretextingInfoCard(
            color: kPretextAccent,
            emoji: '🎭',
            title: 'Badge Unlocked: Pretexting Detective!',
            body: 'You can now see through fake stories and fake identities!',
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('WHAT YOU LEARNED',
                style: GoogleFonts.fredoka(
                    fontSize: 11,
                    color: Colors.white38,
                    letterSpacing: 1.2)),
          ),
          const SizedBox(height: 10),
          const PretextingSummaryTile(
              emoji: '🎭',
              text: 'What pretexting is and how made-up stories work'),
          const PretextingSummaryTile(
              emoji: '🪪',
              text: 'The disguises pretexters use (IT, police, friends...)'),
          const PretextingSummaryTile(
              emoji: '💻',
              text: 'Fake profiles and sneaky email address tricks'),
          const PretextingSummaryTile(
              emoji: '🧠',
              text: 'Trusting your gut and the PAUSE rule'),
          const PretextingSummaryTile(
              emoji: '💬',
              text: '2 real-life chat simulation challenges'),
          const SizedBox(height: 28),
          PretextingCatButton(
            button: PretextingNextButton(
              onTap: () => _finish(context),
              enabled: !claiming,
              label: claiming ? 'Claiming...' : '🎉  Claim your XP!',
            ),
            message: PretextingCatMessages.completeMessage(3),
            accentColor: kPretextGold,
          ),
        ]),
      );
}
