import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import '../screens/daily/daily_challenge_screen.dart';

class DailyChallengeCard extends StatefulWidget {
  const DailyChallengeCard({super.key});
  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard>
    with SingleTickerProviderStateMixin {
  int _done = 0;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

  void _loadProgress() {
    final p = UserService.instance.getProgress('daily_challenge');
    setState(() => _done = p?.stepsCompleted ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_done >= 3) return const SizedBox.shrink();
    const Color accent = Color(0xFFFFC857);

    return GestureDetector(
      onTap: () async {
        SoundService.playClick();
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyChallengeScreen()));
        _loadProgress();
      },
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.5),
            boxShadow: [BoxShadow(
              color: accent.withValues(alpha: 0.12 * _pulseAnim.value),
              blurRadius: 24, spreadRadius: 2)],
          ),
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header badges
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withValues(alpha: 0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.bolt_rounded, color: accent, size: 12),
                  const SizedBox(width: 4),
                  Text('DAILY CHALLENGE',
                    style: GoogleFonts.fredoka(color: accent, fontSize: 11,
                      fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                ]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4)),
                ),
                child: Text('✨ +75 XP',
                  style: GoogleFonts.fredoka(color: const Color(0xFF00E676),
                    fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 16),

            // Icon + title + description
            Row(children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFC857), Color(0xFF0D1117)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: accent.withValues(alpha: 0.6), width: 1.5),
                ),
                child: const Center(child: Text('🎯', style: TextStyle(fontSize: 30))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  _done == 0 ? "Today's 3 Challenges" : 'Keep Going! ($_done/3 done)',
                  style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'Spot fake messages, dodge bait traps, and sort safe from risky!',
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
              ])),
            ]),

            // Progress bar if partially done
            if (_done > 0) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _done / 3,
                  minHeight: 6,
                  backgroundColor: accent.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
            ],

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  SoundService.playClick();
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyChallengeScreen()));
                  _loadProgress();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: const Color(0xFF0D1117),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(
                  _done == 0 ? 'Play Now →' : 'Continue →',
                  style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
