import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import '../../services/sound_service.dart';

const Color _kAccent = Color(0xFFFF8A65);
const Color _kBg     = Color(0xFF0D1117);
const Color _kCard   = Color(0xFF161B2E);
const Color _kCyan   = Color(0xFF00D1FF);
const Color _kGreen  = Color(0xFF00E676);
const Color _kRed    = Color(0xFFFF5252);

class BaitingScreen extends StatefulWidget {
  const BaitingScreen({super.key});
  @override
  State<BaitingScreen> createState() => _BaitingScreenState();
}

class _BaitingScreenState extends State<BaitingScreen> {
  int _currentStep = 0;
  static const int _totalLessons = 6;
  int _quizScore = 0;
  int _quizTotal = 0;

  void _goNext() => setState(() => _currentStep++);
  void _goBack() {
    if (_currentStep > 0) setState(() => _currentStep--);
    else Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = _currentStep >= 1 && _currentStep <= _totalLessons;
    final bool isComplete = _currentStep == 9;
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              if (!isComplete)
                GestureDetector(
                  onTap: () { SoundService.playClick(); _goBack(); },
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: _kCard, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kCyan.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: _kCyan, size: 20),
                  ),
                ).animate().scale(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _kAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kAccent.withValues(alpha: 0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🎁', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Text(
                    showProgress ? 'LESSON $_currentStep OF $_totalLessons' : 'BAITING PRO',
                    style: GoogleFonts.fredoka(color: _kAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ]),
              ),
            ]),
          ),
          if (showProgress)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _LessonProgressBar(current: _currentStep, total: _totalLessons),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _buildStep(),
            ),
          ),
        ])),
      ]),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0: return _IntroStep(key: const ValueKey(0), onNext: _goNext);
      case 1: return _Lesson1(key: const ValueKey(1), onNext: _goNext);
      case 2: return _Lesson2(key: const ValueKey(2), onNext: _goNext);
      case 3: return _Lesson3(key: const ValueKey(3), onNext: _goNext);
      case 4: return _Lesson4(key: const ValueKey(4), onNext: _goNext);
      case 5: return _Lesson5(key: const ValueKey(5), onNext: _goNext);
      case 6: return _Lesson6(key: const ValueKey(6), onNext: _goNext);
      case 7: return _ChatSimActivity(key: const ValueKey(7), onNext: _goNext);
      case 8: return _QuizStep(key: const ValueKey(8), onComplete: (s,t) { setState(() { _quizScore = s; _quizTotal = t; _currentStep++; }); });
      case 9: return _CompleteStep(key: const ValueKey(9), score: _quizScore, total: _quizTotal, onRetry: () => setState(() => _currentStep = 8), onDone: () => Navigator.pop(context));
      default: return const SizedBox();
    }
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kCyan.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LessonProgressBar extends StatelessWidget {
  final int current, total;
  const _LessonProgressBar({required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('PROGRESS', style: GoogleFonts.fredoka(fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
      Text('$current / $total', style: GoogleFonts.fredoka(fontSize: 11, color: _kAccent, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: current / total, minHeight: 7,
        backgroundColor: _kAccent.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(current == total ? _kGreen : _kAccent),
      ),
    ),
  ]);
}

class _NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextBtn({required this.onTap, this.label = 'Next →', this.enabled = true});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? () { SoundService.playClick(); onTap(); } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kAccent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: _kCard,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: Text(label, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
    ),
  );
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _kAccent.withValues(alpha: 0.15)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: child,
  );
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const _InfoCard({required this.color, required this.emoji, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 26)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
      ])),
    ]),
  );
}

class _TipBox extends StatelessWidget {
  final String text;
  const _TipBox({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _kAccent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
    ),
    child: Row(children: [
      const Text('💡', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

class _LessonLabel extends StatelessWidget {
  final String label;
  const _LessonLabel({required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.chevron_right_rounded, color: _kAccent, size: 16),
    const SizedBox(width: 4),
    Text(label, style: GoogleFonts.fredoka(color: _kAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
  ]);
}

class _RedFlagCard extends StatelessWidget {
  final String flag, detail;
  const _RedFlagCard({required this.flag, required this.detail});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kRed.withValues(alpha: 0.3), width: 1.2),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: _kRed)),
      const SizedBox(height: 5),
      Text(detail, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
    ]),
  );
}

class _StepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const _StepCard({required this.number, required this.emoji, required this.title, required this.body, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.25)),
    ),
    child: Row(children: [
      Container(width: 46, height: 46,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 2),
        Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
      ])),
      Container(width: 26, height: 26,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5))),
        child: Center(child: Text(number,
          style: GoogleFonts.fredoka(color: color, fontWeight: FontWeight.w700, fontSize: 12)))),
    ]),
  );
}

class _SummaryTile extends StatelessWidget {
  final String emoji, text;
  const _SummaryTile({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
      const Icon(Icons.check_circle_rounded, color: _kGreen, size: 18),
    ]),
  );
}

class _TrapRow extends StatelessWidget {
  final String emoji, text;
  const _TrapRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

class _CompareRow extends StatelessWidget {
  final String emoji, text;
  const _CompareRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.3))),
    ]),
  );
}

class _IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(children: [
      Container(
        width: 110, height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [_kAccent, _kBg],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: _kAccent.withValues(alpha: 0.6), width: 2),
        ),
        child: const Center(child: Text('🎁', style: TextStyle(fontSize: 54))),
      ).animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Baiting Pro!', textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      Text('Learn how tricksters use tempting offers and freebies to trap you — and how to never fall for it! 🪤',
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
      const SizedBox(height: 24),
      _InfoCard(color: _kCyan, emoji: '📖', title: "What you'll learn",
        body: "What baiting is, how it works online and in real life, how to spot red flags, and what to do if you see a trap."),
      const SizedBox(height: 10),
      _InfoCard(color: _kGreen, emoji: '⏱️', title: '~20 minutes',
        body: '6 lessons + Chat Simulation + quiz at the end!'),
      const SizedBox(height: 10),
      _InfoCard(color: _kAccent, emoji: '⭐', title: 'Earn +200 XP',
        body: 'Complete everything to earn your Baiting Pro badge!'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext, label: '▶  Start Course'),
    ]),
  );
}

class _Lesson1 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson1({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'WHAT IS BAITING?'),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(children: [
        const Text('🪤', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 10),
        Text('Baiting is when a trickster offers you something tempting — like free games, gifts, or prizes — to get you to do something dangerous, like clicking a bad link or giving away personal info.',
          textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white70, height: 1.5)),
      ])),
      const SizedBox(height: 16),
      Text('Think of it like a fishing trap 🎣',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _WhiteCard(child: const Column(children: [
        _TrapRow(emoji: '🐟', text: 'A fish sees yummy bait dangling on a hook'),
        _TrapRow(emoji: '🎮', text: 'You see "FREE game skins — click here NOW!"'),
        _TrapRow(emoji: '🪤', text: 'The fish bites and gets caught'),
        _TrapRow(emoji: '😨', text: 'You click and your device gets hacked'),
      ])),
      const SizedBox(height: 12),
      _TipBox(text: 'Baiters know what you like — games, music, free stuff — and use it against you. Always stop and think before you click!'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _Lesson2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson2({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'BAITING ONLINE'),
      const SizedBox(height: 6),
      Text("Here's how baiters trick people online:", style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _BaitExampleCard(emoji: '🎮', color: const Color(0xFFE8D5FB),
        title: 'Free Game Items',
        baitMsg: '"Get 10,000 free V-Bucks! Click here NOW before it expires!"',
        why: 'Hackers know kids love in-game currency. The link installs malware on your device.'),
      const SizedBox(height: 12),
      _BaitExampleCard(emoji: '🎵', color: const Color(0xFFB2EBF2),
        title: 'Free Music & Films',
        baitMsg: '"Download any song or movie for free — no account needed!"',
        why: 'Illegal download sites bundle harmful software with the file you download.'),
      const SizedBox(height: 12),
      _BaitExampleCard(emoji: '🏆', color: const Color(0xFFFFF9C4),
        title: 'Fake Competitions',
        baitMsg: '"You\'ve been randomly selected! Claim your £500 prize now!"',
        why: 'You never entered a competition. They just want your personal details.'),
      const SizedBox(height: 12),
      _BaitExampleCard(emoji: '📱', color: const Color(0xFFDCEDC8),
        title: 'Free Phone / Gadgets',
        baitMsg: '"Win the latest iPhone — just complete this survey!"',
        why: 'Surveys steal your info. Nobody gives away free phones to random strangers.'),
      const SizedBox(height: 12),
      _TipBox(text: 'If a website promises something amazing for free with no catch — the free thing IS the catch.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _BaitExampleCard extends StatelessWidget {
  final String emoji, title, baitMsg, why;
  final Color color;
  const _BaitExampleCard({required this.emoji, required this.title, required this.baitMsg, required this.why, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.3))),
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
      Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _kRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _kRed.withValues(alpha: 0.4), width: 1.2)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🚨 ', style: TextStyle(fontSize: 14)),
            Expanded(child: Text('"$baitMsg"',
              style: GoogleFonts.fredoka(fontSize: 13, color: _kRed, fontStyle: FontStyle.italic, height: 1.4))),
          ])),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('⚠️ ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(why, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4))),
        ]),
      ])),
    ]),
  );
}

class _Lesson3 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson3({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'BAITING IN REAL LIFE'),
      const SizedBox(height: 6),
      Text("Baiting doesn't just happen online!", style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(children: [
        const Text('🖲️', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 12),
        Text('The USB Stick Trick', textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text('A hacker leaves a USB stick on the floor labelled "FREE GAMES" or "SECRET FILES". Someone picks it up and plugs it into their computer...',
          textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white70, height: 1.5)),
        const SizedBox(height: 12),
        const _TrapRow(emoji: '💻', text: 'Their computer gets infected instantly'),
        const _TrapRow(emoji: '🔓', text: 'The hacker can access all their files'),
        const _TrapRow(emoji: '📷', text: 'Even the camera could be turned on secretly'),
      ])),
      const SizedBox(height: 16),
      Text('Other real-life baiting tricks:', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _InfoCard(color: Colors.orange, emoji: '📀', title: 'Free CDs or Leaflets',
        body: 'A free disc or flyer with a QR code that leads to a dangerous website.'),
      const SizedBox(height: 8),
      _InfoCard(color: Colors.purple, emoji: '🎁', title: 'Suspicious "prize" packages',
        body: '"You\'ve won a prize — pick it up at this address!" Used to collect your details or lure you somewhere unsafe.'),
      const SizedBox(height: 12),
      _TipBox(text: 'NEVER plug in a USB stick you found — even if it looks exciting. Give it to a trusted adult straight away.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _Lesson4 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson4({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'SPOT THE RED FLAGS'),
      const SizedBox(height: 6),
      Text('These warning signs mean something is probably a trap:', style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _RedFlagCard(flag: '⏰ Countdown timers', detail: '"Only 5 minutes left!" — rushing you stops you from thinking clearly.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🆓 Too good to be true', detail: 'Free phones, free money, free premium games — nobody gives these away to strangers.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🔗 Suspicious links', detail: 'Strange URLs like "fr33-v-bucks.xyz" instead of official game websites.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '📝 Asking for personal info', detail: '"Just fill in your name, school, and address to claim!" — real prizes don\'t need all this.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🎰 "You\'ve been selected!"', detail: 'You can\'t win something you never entered. This is almost always fake.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '😮 Creates excitement or panic', detail: 'Baiters want you to act fast without thinking. Big emotions = big mistakes.'),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kGreen.withValues(alpha: 0.35))),
        child: Row(children: [
          const Text('🛑', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Text('When you spot a red flag — STOP. Don\'t click, don\'t share, don\'t reply. Tell a trusted adult.',
            style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: _kGreen, height: 1.4))),
        ])),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _Lesson5 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson5({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'WHAT TO DO'),
      const SizedBox(height: 6),
      Text("If you think you've spotted a bait — follow these steps:", style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _StepCard(number: '1', emoji: '🛑', color: _kRed,
        title: 'STOP what you\'re doing', body: 'Close the tab, put down the device. Don\'t click anything else.'),
      const SizedBox(height: 10),
      _StepCard(number: '2', emoji: '🤔', color: _kAccent,
        title: 'Ask yourself: Does this make sense?', body: 'Did I enter a competition? Is this an official website? Would a real company do this?'),
      const SizedBox(height: 10),
      _StepCard(number: '3', emoji: '🗣️', color: const Color(0xFFBA68C8),
        title: 'Tell a trusted adult', body: 'Show a parent, carer, or teacher. They can help check if it\'s real or report it.'),
      const SizedBox(height: 10),
      _StepCard(number: '4', emoji: '🚫', color: _kCyan,
        title: 'Block and report', body: 'If someone sent you a bait message online, block them and use the report button.'),
      const SizedBox(height: 10),
      _StepCard(number: '5', emoji: '📵', color: _kGreen,
        title: 'Never go back', body: 'Even if you\'re curious — don\'t revisit the link or message. The bait is still there.'),
      const SizedBox(height: 12),
      _TipBox(text: 'If you already clicked something by mistake — tell an adult straight away. The faster they know, the quicker they can help protect your device.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _Lesson6 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson6({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'REAL VS FAKE REWARDS'),
      const SizedBox(height: 6),
      Text("Not everything is a trap — here's how to tell the difference:", style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kGreen.withValues(alpha: 0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('✅ Real Rewards', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: _kGreen)),
          const SizedBox(height: 10),
          const _CompareRow(emoji: '🌐', text: 'Come from official, well-known websites'),
          const _CompareRow(emoji: '📧', text: 'Sent to email addresses you registered with'),
          const _CompareRow(emoji: '⏳', text: 'No extreme time pressure — they give you days'),
          const _CompareRow(emoji: '🔒', text: 'Only ask for info you\'d expect (e.g. delivery address)'),
          const _CompareRow(emoji: '📞', text: 'You can verify by calling the official company'),
        ])),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _kRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kRed.withValues(alpha: 0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('❌ Fake Bait', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: _kRed)),
          const SizedBox(height: 10),
          const _CompareRow(emoji: '🔗', text: 'Comes from strange, unofficial links'),
          const _CompareRow(emoji: '📨', text: 'Sent randomly to anyone — you never signed up'),
          const _CompareRow(emoji: '⏰', text: 'Extreme urgency — "5 minutes left!"'),
          const _CompareRow(emoji: '📋', text: 'Wants your school, address, and passwords'),
          const _CompareRow(emoji: '🚫', text: 'No official contact number to verify with'),
        ])),
      const SizedBox(height: 12),
      _TipBox(text: 'When in doubt — don\'t act alone. A trusted adult can help you figure out if something is real in seconds.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext, label: 'Chat Simulation 💬'),
    ]),
  );
}

class _ChatSimActivity extends StatefulWidget {
  final VoidCallback onNext;
  const _ChatSimActivity({super.key, required this.onNext});
  @override
  State<_ChatSimActivity> createState() => _ChatSimActivityState();
}

class _ChatSimActivityState extends State<_ChatSimActivity> {
  int scenarioIndex = 0;
  int visibleMsgCount = 0;
  int? choice;
  bool showFeedback = false;
  bool isTyping = false;
  bool choicePhase = false;
  Timer? _msgTimer;
  final ScrollController _scrollCtrl = ScrollController();

  final List<Map<String, dynamic>> scenarios = [
    {
      'title': 'Free V-Bucks DM',
      'roomName': 'FortnitePro_X99',
      'roomAvatar': '🎮',
      'messages': [
        {'from': 'stranger', 'text': 'Yo!! I know a way to get FREE V-Bucks 💎 Want 10,000 for nothing?', 'delay': 700},
        {'from': 'you',      'text': 'Wait… seriously?? 😮',                                                'delay': 1200},
        {'from': 'stranger', 'text': 'Yeah just go to fr33-v-bucks.xyz and log in — it sends them straight away!', 'delay': 1400},
        {'from': 'stranger', 'text': 'Hurry tho!! The link only works for another 8 minutes ⏰',             'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': ['Quick — log in before the link expires!', 'Ask them to show me proof first', 'This is bait — I\'m NOT clicking that link'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'That\'s a baiting trap!',
          'points': ['"fr33-v-bucks.xyz" is NOT an official Fortnite website', 'Logging in gives the scammer your username and password', 'Free V-Buck glitches don\'t exist — it\'s always a scam']},
        {'safe': false, 'emoji': '😬', 'title': 'Better instinct — but still risky!',
          'points': ['Screenshots and "proof" can easily be faked', 'Staying in the chat lets the baiter keep trying', 'The safest move is to exit the chat and tell a trusted adult']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Great detective work! 🎉',
          'points': ['You spotted "fr33-v-bucks.xyz" — a fake, dodgy URL', 'You weren\'t tricked by the countdown pressure tactic', 'You can also report this account to protect other players!']},
      ],
    },
    {
      'title': 'The Prize Winner Message',
      'roomName': 'PrizeZone_Official',
      'roomAvatar': '🏆',
      'messages': [
        {'from': 'stranger', 'text': 'Congratulations!! 🎉 You\'ve been randomly selected to win a FREE PlayStation 5!', 'delay': 700},
        {'from': 'you',      'text': 'Really?? I never entered anything though… 😕',                                       'delay': 1300},
        {'from': 'stranger', 'text': 'No entry needed — you were auto-selected! Just fill in your details at win-prizes-now.com', 'delay': 1400},
        {'from': 'stranger', 'text': 'Offer expires at midnight tonight — don\'t miss out!! 🕛',                               'delay': 1200},
      ],
      'question': 'What should you do?',
      'choices': ['Fill in my details quickly — a free PS5!', 'Ask my parents before doing anything', 'Ignore it — this is classic bait'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '😨', 'title': 'That\'s exactly what the baiter wants!',
          'points': ['You never entered a competition — you can\'t win one you didn\'t enter', '"win-prizes-now.com" is not a real official website', 'Your personal details would be stolen immediately']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Really good thinking! 🎉',
          'points': ['Asking a parent is always a smart move with unexpected prizes', 'A trusted adult can help spot the scam quickly', 'Two sets of eyes are better than one!']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Spot on! 🎉',
          'points': ['You can\'t win something you never entered — instant red flag', 'The midnight deadline is a classic urgency pressure trick', 'Reporting the account helps protect others too!']},
      ],
    },
    {
      'title': 'The USB Stick Find',
      'roomName': 'SchoolFriend_Liam',
      'roomAvatar': '🧑',
      'messages': [
        {'from': 'stranger', 'text': 'Oi!! I found this USB on the floor outside school — it says "FUNNY VIDEOS" on it 😂', 'delay': 700},
        {'from': 'you',      'text': 'Haha no way, what\'s on it?? 👀',                                                       'delay': 1200},
        {'from': 'stranger', 'text': 'Dunno yet — should we plug it into the computer in the library and see?',               'delay': 1400},
        {'from': 'stranger', 'text': 'Come on it\'ll be funny 😂 nobody will know!',                                          'delay': 1100},
      ],
      'question': 'What do you do?',
      'choices': ['Yeah go for it — sounds funny!', 'Give it to a teacher without plugging it in', 'Tell them why it\'s a bad idea and not to plug it in'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'That\'s a real baiting technique!',
          'points': ['Hackers leave USB sticks labelled with tempting names on purpose', 'Plugging it in can instantly infect the computer with malware', 'The hacker could then access everything on that device']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Good call! 🎉',
          'points': ['Giving it to a teacher means a trusted adult can handle it safely', 'They can report it and dispose of it properly', 'You protected yourself and everyone who uses that computer!']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Great response! 🎉',
          'points': ['You recognised this as a baiting trap — well done!', 'Warning your friend stops them from making a dangerous mistake', 'Together you can take it to a teacher instead']},
      ],
    },
  ];

  Map<String, dynamic> get scenario => scenarios[scenarioIndex];
  List get msgs => scenario['messages'] as List;
  bool get isLastScenario => scenarioIndex == scenarios.length - 1;

  @override
  void initState() {
    super.initState();
    _startScenario();
  }

  @override
  void dispose() {
    _msgTimer?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _startScenario() {
    setState(() {
      visibleMsgCount = 0;
      isTyping = false;
      choicePhase = false;
      choice = null;
      showFeedback = false;
    });
    _scheduleNextMessage();
  }

  void _scheduleNextMessage() {
    if (visibleMsgCount >= msgs.length) {
      setState(() => choicePhase = true);
      return;
    }
    final msg = msgs[visibleMsgCount] as Map;
    final String text = msg['text'] as String;
    final int delay = msg['delay'] as int;
    final bool isStranger = msg['from'] == 'stranger';
    final int typeDuration = isStranger ? text.length * 28 : 0;

    if (isStranger) {
      setState(() => isTyping = true);
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() { isTyping = false; visibleMsgCount++; });
        _scrollToBottom();
        _msgTimer = Timer(Duration(milliseconds: typeDuration + 120), () {
          if (!mounted) return;
          _scheduleNextMessage();
        });
      });
    } else {
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() => visibleMsgCount++);
        _scrollToBottom();
        _msgTimer = Timer(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          _scheduleNextMessage();
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _selectChoice(int index) {
    SoundService.playClick();
    setState(() { choice = index; showFeedback = true; });
  }

  void _nextScenario() {
    SoundService.playClick();
    _msgTimer?.cancel();
    if (isLastScenario) {
      widget.onNext();
    } else {
      setState(() => scenarioIndex++);
      _startScenario();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fb = showFeedback
        ? (scenario['feedback'] as List)[choice!] as Map<String, dynamic>
        : null;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Chat Simulation 💬',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withValues(alpha: 0.4)),
            ),
            child: Text('${scenarioIndex + 1} / ${scenarios.length}',
              style: GoogleFonts.fredoka(color: _kAccent, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ]),
      ),
      const SizedBox(height: 10),
      _ChatRoomHeader(
        roomName: scenario['roomName'] as String,
        avatar: scenario['roomAvatar'] as String,
        title: scenario['title'] as String,
      ),
      Expanded(
        child: ListView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          children: [
            ...(msgs.sublist(0, visibleMsgCount) as List).map((m) {
              final bool isYou = (m as Map)['from'] == 'you';
              return _AnimatedChatBubble(
                key: ValueKey('${scenarioIndex}_${msgs.indexOf(m)}'),
                text: m['text'] as String,
                isYou: isYou,
                senderName: isYou ? 'You' : scenario['roomName'] as String,
                scrollCtrl: _scrollCtrl,
              );
            }),
            if (isTyping) _TypingIndicator(key: ValueKey('typing_$scenarioIndex')),
            if (choicePhase && !showFeedback) ...[
              const SizedBox(height: 8),
              _ChoicePrompt(
                question: scenario['question'] as String,
                choices: scenario['choices'] as List,
                onSelect: _selectChoice,
              ),
            ],
            if (showFeedback && fb != null) ...[
              const SizedBox(height: 8),
              _FeedbackCard(fb: fb),
              const SizedBox(height: 16),
              _NextBtn(
                onTap: _nextScenario,
                label: isLastScenario ? 'Quiz Time! 🎯' : 'Next Scenario →',
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ]);
  }
}

class _ChatRoomHeader extends StatelessWidget {
  final String roomName, avatar, title;
  const _ChatRoomHeader({required this.roomName, required this.avatar, required this.title});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
    ),
    child: Row(children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: _kAccent.withValues(alpha: 0.1),
          border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
        child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(roomName, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _kRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _kRed.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: _kRed)),
          const SizedBox(width: 5),
          Text('LIVE', style: GoogleFonts.fredoka(fontSize: 10, fontWeight: FontWeight.w700, color: _kRed)),
        ]),
      ),
    ]),
  );
}

class _AnimatedChatBubble extends StatefulWidget {
  final String text, senderName;
  final bool isYou;
  final ScrollController scrollCtrl;
  const _AnimatedChatBubble({super.key, required this.text, required this.isYou, required this.senderName, required this.scrollCtrl});
  @override
  State<_AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<_AnimatedChatBubble> with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  String _displayed = '';
  Timer? _typeTimer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _fade  = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(widget.isYou ? 0.12 : -0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
    _startTyping();
  }

  void _startTyping() {
    if (widget.isYou) {
      setState(() => _displayed = widget.text);
      return;
    }
    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_charIndex >= widget.text.length) { t.cancel(); return; }
      _charIndex++;
      setState(() => _displayed = widget.text.substring(0, _charIndex));
      if (_charIndex % 5 == 0 && widget.scrollCtrl.hasClients) {
        widget.scrollCtrl.animateTo(
          widget.scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _typeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String label = widget.isYou
        ? 'You'
        : (widget.senderName.length > 22 ? '${widget.senderName.substring(0, 22)}...' : widget.senderName);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 8,
            left: widget.isYou ? 50 : 0,
            right: widget.isYou ? 0 : 50,
          ),
          child: Column(
            crossAxisAlignment: widget.isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 4, right: 4),
                child: Text(label,
                  style: GoogleFonts.fredoka(
                    fontSize: 10,
                    color: widget.isYou ? _kCyan.withValues(alpha: 0.6) : _kRed.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: widget.isYou ? _kCyan.withValues(alpha: 0.1) : _kCard,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(widget.isYou ? 18 : 4),
                    bottomRight: Radius.circular(widget.isYou ? 4 : 18),
                  ),
                  border: Border.all(
                    color: widget.isYou ? _kCyan.withValues(alpha: 0.3) : _kRed.withValues(alpha: 0.2),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Stack(children: [
                  Text(widget.text,
                    style: GoogleFonts.fredoka(fontSize: 14, color: Colors.transparent, height: 1.45)),
                  Text(_displayed,
                    style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, height: 1.45)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({super.key});
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _dotAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
    _dotAnims = List.generate(3, (i) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut)),
    ));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, right: 50),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _kCard, borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18),
          ),
          border: Border.all(color: _kRed.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
          AnimatedBuilder(
            animation: _dotAnims[i],
            builder: (_, __) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7, height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kRed.withValues(alpha: 0.3 + 0.6 * _dotAnims[i].value),
              ),
            ),
          ),
        )),
      ),
    ]),
  );
}

class _ChoicePrompt extends StatelessWidget {
  final String question;
  final List choices;
  final ValueChanged<int> onSelect;
  const _ChoicePrompt({required this.question, required this.choices, required this.onSelect});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _kAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Text('🤔', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(question,
          style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
      ]),
    ),
    ...choices.asMap().entries.map((e) =>
      GestureDetector(
        onTap: () => onSelect(e.key),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _kCard, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kAccent.withValues(alpha: 0.2), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            Container(width: 26, height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: _kAccent.withValues(alpha: 0.1),
                border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
              child: Center(child: Text(['A','B','C'][e.key],
                style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: _kAccent)))),
            const SizedBox(width: 12),
            Expanded(child: Text(e.value as String,
              style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))),
          ]),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: e.key * 100)).slideX(begin: 0.05),
    ),
  ]);
}

class _FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> fb;
  const _FeedbackCard({required this.fb});
  @override
  Widget build(BuildContext context) {
    final bool safe = fb['safe'] as bool;
    final Color c = safe ? _kGreen : _kRed;
    final Color bg = safe ? _kGreen.withValues(alpha: 0.08) : _kRed.withValues(alpha: 0.08);
    final Color border = safe ? _kGreen.withValues(alpha: 0.35) : _kRed.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(fb['emoji'] as String, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(fb['title'] as String,
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: c))),
        ]),
        const SizedBox(height: 10),
        ...(fb['points'] as List).map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(safe ? Icons.check_circle_rounded : Icons.cancel_rounded, color: c, size: 15),
            const SizedBox(width: 8),
            Expanded(child: Text(p as String,
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
          ]),
        )),
      ]),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

class _QuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const _QuizStep({super.key, required this.onComplete});
  @override
  State<_QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<_QuizStep> {
  int _qi = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {'emoji': '🤔', 'question': 'What is "baiting" in cybersecurity?',
      'options': ['Fishing in real life', 'Using tempting offers to trick you into something dangerous', 'A type of computer virus', 'Sending too many emails'],
      'correct': 1, 'explanation': 'Baiting uses tempting things (free items, prizes) to make you click bad links or share personal info.'},
    {'emoji': '🖲️', 'question': 'You find a USB stick on the floor labelled "FREE GAMES". What do you do?',
      'options': ['Plug it in straight away!', 'Give it to a trusted adult without plugging it in', 'Try it on a friend\'s computer instead', 'Look at it and throw it away'],
      'correct': 1, 'explanation': 'Never plug in unknown USB sticks. Give it to a trusted adult — it could contain malware.'},
    {'emoji': '⏰', 'question': 'A message says "Claim your FREE prize in the next 5 minutes or it\'s gone!" What is the countdown designed to do?',
      'options': ['Help you win faster', 'Stop you from thinking clearly', 'Show the prize is real', 'Give you extra time'],
      'correct': 1, 'explanation': 'Countdown timers rush you into acting without thinking — that\'s exactly what baiters want.'},
    {'emoji': '🔗', 'question': 'Which of these links looks suspicious?',
      'options': ['minecraft.net/download', 'fr33-v-bucks.xyz/claim', 'bbc.co.uk/news', 'google.com'],
      'correct': 1, 'explanation': '"fr33-v-bucks.xyz" is not an official website. Real game items always come from official sites.'},
    {'emoji': '✅', 'question': 'Which of these is a sign that a reward is REAL and not bait?',
      'options': ['It came from a random message you weren\'t expecting', 'It links to an official website you recognise', 'It has a 10-minute countdown timer', 'It asks for your school name and address'],
      'correct': 1, 'explanation': 'Real rewards come from official websites you recognise, with no extreme pressure or unexpected info requests.'},
    {'emoji': '😨', 'question': 'You accidentally clicked a suspicious link. What should you do FIRST?',
      'options': ['Keep browsing and hope nothing happens', 'Tell a trusted adult straight away', 'Click more links to see what it does', 'Delete your browser history and forget about it'],
      'correct': 1, 'explanation': 'Tell a trusted adult immediately — the faster they know, the quicker they can protect your device.'},
  ];

  void _next() {
    SoundService.playClick();
    if (_qi < _questions.length - 1) {
      setState(() { _qi++; _selected = null; _answered = false; });
    } else {
      widget.onComplete(_score, _questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_qi];
    final opts = List<String>.from(q['options'] as List);
    final int correct = q['correct'] as int;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quiz Time! 🎯', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: _kAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
            child: Text('${_qi + 1} / ${_questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: _kAccent, fontSize: 13))),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: (_qi + 1) / _questions.length, minHeight: 6,
            backgroundColor: _kAccent.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_kAccent))),
        const SizedBox(height: 20),
        _WhiteCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(q['question'] as String, textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
        const SizedBox(height: 16),
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final bool isCorrect = i == correct;
          final bool isSelected = i == _selected;
          Color bg = _kCard;
          Color border = _kAccent.withValues(alpha: 0.15);
          Color tc = Colors.white;
          Widget? trailing;
          if (_answered) {
            if (isCorrect) {
              bg = _kGreen.withValues(alpha: 0.1);
              border = _kGreen.withValues(alpha: 0.5);
              tc = _kGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: _kGreen, size: 20);
            } else if (isSelected) {
              bg = _kRed.withValues(alpha: 0.1);
              border = _kRed.withValues(alpha: 0.5);
              tc = _kRed;
              trailing = const Icon(Icons.cancel_rounded, color: _kRed, size: 20);
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: _answered ? null : () { SoundService.playClick(); setState(() { _selected = i; _answered = true; if (i == correct) _score++; }); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))]),
                child: Row(children: [
                  Container(width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: _answered && isCorrect ? _kGreen.withValues(alpha: 0.15) : _kAccent.withValues(alpha: 0.08),
                      border: Border.all(color: _answered && isCorrect ? _kGreen : _kAccent.withValues(alpha: 0.3))),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13,
                        color: _answered && isCorrect ? _kGreen : _kAccent.withValues(alpha: 0.8))))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: tc))),
                  if (trailing != null) trailing,
                ]),
              ),
            ),
          );
        }),
        if (_answered) ...[
          _TipBox(text: q['explanation'] as String),
          const SizedBox(height: 16),
          _NextBtn(onTap: _next, label: _qi < _questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
        ],
      ]),
    );
  }
}

class _CompleteStep extends StatefulWidget {
  final VoidCallback onDone;
  final VoidCallback onRetry;
  final int score;
  final int total;
  const _CompleteStep({super.key, required this.onDone, required this.onRetry, required this.score, required this.total});
  @override
  State<_CompleteStep> createState() => _CompleteStepState();
}

class _CompleteStepState extends State<_CompleteStep> {
  bool claiming = false;

  int get _stars {
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct == 1.0) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  int get _awardedXp {
    if (_stars == 3) return 200;
    if (_stars == 2) return (200 * 0.7).round();
    return (200 * 0.4).round();
  }

  String get _emoji {
    if (_stars == 3) return '🏆';
    if (_stars == 2) return '🎉';
    return '💪';
  }

  String get _title {
    if (_stars == 3) return 'Perfect Score!';
    if (_stars == 2) return 'Great Effort!';
    return 'Good Try!';
  }

  String get _subtitle {
    if (_stars == 3) return "You've completed Baiting Pro!";
    if (_stars == 2) return 'You got ${widget.score} out of ${widget.total} — solid work!';
    return 'You got ${widget.score} out of ${widget.total} — review the lessons and try again!';
  }

  String get _encouragement {
    if (_stars == 3) return 'You nailed every question! 🌟';
    if (_stars == 2) return 'Almost there — revisit the tricky bits to get full marks!';
    return "Don't give up — each attempt makes you smarter and safer online!";
  }

  Future<void> _finish(BuildContext context) async {
    if (claiming) return;
    if (_stars < 3) {
      await RetryDialog.show(context, lessonId: 'baiting_pro', score: widget.score, total: widget.total, onRetry: widget.onRetry);
      return;
    }
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'baiting_pro', stepsCompleted: 6, totalSteps: 6,
        stars: _stars, completed: true));
      if (!mounted) return;
      await XpAward.show(context, lessonId: 'baiting_pro', amount: 200);
      widget.onDone();
    } catch (e) { debugPrint('Error: $e'); widget.onDone(); }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
    child: Column(children: [
      Container(
        width: 110, height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [_stars == 3 ? const Color(0xFFFFD700) : _stars == 2 ? _kAccent : _kCard, _kBg],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: (_stars == 3 ? const Color(0xFFFFD700) : _stars == 2 ? _kAccent : Colors.white24).withValues(alpha: 0.6), width: 2),
        ),
        child: Center(child: Text(_emoji, style: const TextStyle(fontSize: 54))),
      ).animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text(_title, style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text(_subtitle, textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
      const SizedBox(height: 20),
      _WhiteCard(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              i < _stars ? '⭐' : '☆',
              style: TextStyle(fontSize: 32, color: i < _stars ? const Color(0xFFFFD700) : Colors.white12),
            ),
          ),
        )),
        const SizedBox(height: 10),
        Text(
          _stars == 3 ? '3 Stars — Amazing!' : _stars == 2 ? '2 Stars — Well Done!' : '1 Star — Keep Practising!',
          style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('+$_awardedXp XP', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
          ])),

      ])),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _stars >= 2 ? _kGreen.withValues(alpha: 0.07) : _kAccent.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _stars >= 2 ? _kGreen.withValues(alpha: 0.3) : _kAccent.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Text(_stars >= 2 ? '🌟' : '📖', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(_encouragement,
            style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
        ]),
      ),
      const SizedBox(height: 16),
      _InfoCard(color: _kAccent, emoji: '🎁', title: 'Badge Unlocked: Baiting Pro!',
        body: 'You can now spot a baiting trap before it catches you!'),
      const SizedBox(height: 20),
      Align(alignment: Alignment.centerLeft,
        child: Text('WHAT YOU LEARNED', style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
      const SizedBox(height: 10),
      const _SummaryTile(emoji: '🪤', text: 'What baiting is and how it works'),
      const _SummaryTile(emoji: '💻', text: 'Online baiting examples'),
      const _SummaryTile(emoji: '🖲️', text: 'Physical baiting: USB sticks and real-world traps'),
      const _SummaryTile(emoji: '🚩', text: 'How to spot red flags'),
      const _SummaryTile(emoji: '🛡️', text: 'What to do when you spot a bait'),
      const _SummaryTile(emoji: '🔍', text: 'Real vs fake rewards'),
      const _SummaryTile(emoji: '💬', text: '3 real-life chat simulation scenarios'),
      const SizedBox(height: 28),
      _NextBtn(
        onTap: () => _finish(context),
        enabled: _stars < 3 ? true : !claiming,
        label: _stars < 3 ? '🔄  Try Again' : (claiming ? 'Claiming...' : '🎉  Claim your XP!'),
      ),
    ]),
  );
}