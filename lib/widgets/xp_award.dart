import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';

const Color _kBg    = Color(0xFF0D1117);
const Color _kCard  = Color(0xFF161B2E);
const Color _kGreen = Color(0xFF00E676);
const Color _kRed   = Color(0xFFFF5252);

// ── Shared accent lookup ───────────────────────────────────────────────────────
Color _accentForLesson(String lessonId) {
  switch (lessonId) {
    case 'password_power':     return const Color(0xFFFFC857);
    case 'phishing_detective': return const Color(0xFF4FC3F7);
    case 'baiting_pro':        return const Color(0xFFFF8A65);
    case 'pretexting':         return const Color(0xFFBA68C8);
    default:                   return const Color(0xFF00D1FF);
  }
}

// ── XP Award (perfect score) ──────────────────────────────────────────────────
class XpAward {
  static Future<void> show(
    BuildContext context, {
    required String lessonId,
    required int amount,
    Color? accentColor,
  }) async {
    final Color accent = accentColor ?? _accentForLesson(lessonId);
    final result = await UserService.instance.addXp(lessonId, amount);
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _XpSheet(
        amount: amount,
        accent: accent,
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

// ── Retry Dialog (not perfect score) ─────────────────────────────────────────
class RetryDialog {
  static Future<void> show(
    BuildContext context, {
    required String lessonId,
    required int score,
    required int total,
    required VoidCallback onRetry,
    Color? accentColor,
  }) async {
    final Color accent = accentColor ?? _accentForLesson(lessonId);
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _RetrySheet(
        score: score,
        total: total,
        accent: accent,
        onRetry: onRetry,
      ),
    );
  }
}

// ── Retry Sheet UI ────────────────────────────────────────────────────────────
class _RetrySheet extends StatelessWidget {
  final int score, total;
  final Color accent;
  final VoidCallback onRetry;
  const _RetrySheet({required this.score, required this.total, required this.accent, required this.onRetry});

  String get _message {
    final pct = total == 0 ? 0.0 : score / total;
    if (pct >= 0.6) return "So close! Just a couple more to go — you've got this!";
    if (pct >= 0.4) return "Good start! Review the lessons and give it another shot.";
    return "Don't worry — each attempt makes you smarter and safer online!";
  }

  @override
  Widget build(BuildContext context) {
    final int missed = total - score;
    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: _kRed.withValues(alpha: 0.35), width: 1.5)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Drag handle
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: _kCard,
              border: Border.all(color: _kRed.withValues(alpha: 0.4), width: 2),
            ),
            child: const Center(child: Text('📖', style: TextStyle(fontSize: 40))),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 16),

          Text('Not quite there yet!',
            style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 6),
          Text(_message,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.5)),

          const SizedBox(height: 20),

          // Score breakdown card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kCard, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Expanded(child: Column(children: [
                Text('$score',
                  style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w700, color: _kGreen)),
                Text('correct', style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
              ])),
              Container(width: 1, height: 40, color: Colors.white12),
              Expanded(child: Column(children: [
                Text('$missed',
                  style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w700, color: _kRed)),
                Text('to review', style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
              ])),
              Container(width: 1, height: 40, color: Colors.white12),
              Expanded(child: Column(children: [
                Text('$total',
                  style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white54)),
                Text('total', style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
              ])),
            ]),
          ),
          const SizedBox(height: 12),

          // Tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.25)),
            ),
            child: Row(children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Text(
                'You need to get every question right to complete the lesson and earn your XP.',
                style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 20),

          // Try Again button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { Navigator.pop(context); onRetry(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: accent, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text('🔄  Try Again',
                style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── XP Sheet UI ───────────────────────────────────────────────────────────────
class _XpSheet extends StatefulWidget {
  final int amount;
  final Color accent;
  final bool alreadyAwarded, levelledUp;
  final int newLevel, newXp, xpCeiling;
  final double xpProgress;
  const _XpSheet({
    required this.amount, required this.accent, required this.alreadyAwarded,
    required this.levelledUp, required this.newLevel, required this.newXp,
    required this.xpCeiling, required this.xpProgress,
  });
  @override
  State<_XpSheet> createState() => _XpSheetState();
}

class _XpSheetState extends State<_XpSheet> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = Tween<double>(begin: 0, end: widget.xpProgress)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accent;
    final Color barColor = widget.levelledUp ? _kGreen : accent;

    return Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: accent.withValues(alpha: 0.35), width: 1.5)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),

          if (widget.levelledUp) ...[
            const Text('🎉', style: TextStyle(fontSize: 48)).animate().scale(curve: Curves.elasticOut),
            const SizedBox(height: 10),
            Text('Level Up!', style: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.w700, color: _kGreen)),
            const SizedBox(height: 4),
            Text("You're now Level ${widget.newLevel}!",
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 4),
            Text("Keep going — you're on a roll! 🚀",
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
          ] else if (widget.alreadyAwarded) ...[
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1), shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.4), width: 2),
              ),
              child: const Center(child: Text('✅', style: TextStyle(fontSize: 30))),
            ).animate().scale(curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text('XP already earned!',
              style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Text('You can replay lessons for practice —\nbut XP is only awarded once.',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38, height: 1.5)),
          ] else ...[
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [accent, _kBg], begin: Alignment.topLeft, end: Alignment.bottomRight),
                border: Border.all(color: accent.withValues(alpha: 0.6), width: 2),
              ),
              child: const Center(child: Text('⭐', style: TextStyle(fontSize: 40))),
            ).animate().scale(curve: Curves.elasticOut),
            const SizedBox(height: 14),
            Text('+${widget.amount} XP Earned!',
              style: GoogleFonts.fredoka(fontSize: 26, fontWeight: FontWeight.w700, color: accent)),
            const SizedBox(height: 4),
            Text('Amazing work — keep it up! 🚀',
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
          ],

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kCard, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: barColor.withValues(alpha: 0.4)),
                  ),
                  child: Text('Level ${widget.newLevel}',
                    style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: barColor)),
                ),
                Text('${widget.newXp} / ${widget.xpCeiling} XP',
                  style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
              ]),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _barAnim,
                builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _barAnim.value, minHeight: 10,
                    backgroundColor: barColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text('Back to Dashboard',
                style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }
}