import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import '../../services/sound_service.dart';

const Color _kAccent = Color(0xFFBA68C8);
const Color _kBg     = Color(0xFF0D1117);
const Color _kCard   = Color(0xFF161B2E);
const Color _kCyan   = Color(0xFF00D1FF);
const Color _kGreen  = Color(0xFF00E676);
const Color _kRed    = Color(0xFFFF5252);
const Color _kPurple = Color(0xFFCE93D8);

class PretextingScreen extends StatefulWidget {
  const PretextingScreen({super.key});
  @override
  State<PretextingScreen> createState() => _PretextingScreenState();
}

class _PretextingScreenState extends State<PretextingScreen> {
  int _currentStep = 0;
  static const int _totalLessons = 4;
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
    final bool isComplete = _currentStep == 7;
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
                  const Text('🎭', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Text(
                    showProgress ? 'LESSON $_currentStep OF $_totalLessons' : 'PRETEXTING',
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
      case 5: return _FinalChallenge(key: const ValueKey(5), onComplete: _goNext);
      case 6: return _QuizStep(key: const ValueKey(6), onComplete: (s,t) { setState(() { _quizScore = s; _quizTotal = t; _currentStep++; }); });
      case 7: return _CompleteStep(key: const ValueKey(7), score: _quizScore, total: _quizTotal, onRetry: () => setState(() => _currentStep = 6), onDone: () => Navigator.pop(context));
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
        child: const Center(child: Text('🎭', style: TextStyle(fontSize: 54))),
      ).animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Pretexting', textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      Text('Learn how tricksters pretend to be someone else to fool you — and how to see through their disguise! 🕵️',
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
      const SizedBox(height: 24),
      _InfoCard(color: _kCyan, emoji: '📖', title: "What you'll learn",
        body: "What pretexting is, how people fake identities online, how to spot impersonation, and how to trust your instincts when something feels off."),
      const SizedBox(height: 10),
      _InfoCard(color: _kGreen, emoji: '⏱️', title: '~18 minutes',
        body: '4 lessons + Final Challenge (chat simulation) + quiz!'),
      const SizedBox(height: 10),
      _InfoCard(color: _kAccent, emoji: '⭐', title: 'Earn up to +180 XP',
        body: 'Complete everything to earn your Pretexting Detective badge!'),
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
      _WhiteCard(child: Column(children: [
        const Text('🎭', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 12),
        Text('What is Pretexting?', textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 10),
        Text('Pretexting is when a trickster invents a fake story — called a "pretext" — and pretends to be someone they\'re not, to get you to share information or do something you wouldn\'t normally do.',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white70, height: 1.5)),
      ])),
      const SizedBox(height: 20),
      Text('A real example 🎬',
        style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 12),
      _StoryPanel(steps: const [
        _StoryStep(emoji: '📞', speaker: 'Trickster',
          text: '"Hi, I\'m calling from your school IT department. We\'re upgrading the system and need your login details."'),
        _StoryStep(emoji: '😮', speaker: 'You',
          text: '"Oh! The school IT team? Sure, my username is..."'),
        _StoryStep(emoji: '😈', speaker: 'Reality',
          text: 'It was never the school. They made up the story to steal your login.'),
      ]),
      const SizedBox(height: 20),
      Text('Why does it work?',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _InfoCard(color: _kPurple, emoji: '🤝', title: 'We trust authority figures',
        body: 'Teachers, IT staff, doctors, police — we\'re taught to trust them. Pretexters pretend to be these people.'),
      const SizedBox(height: 8),
      _InfoCard(color: _kCyan, emoji: '⚡', title: 'They create urgency',
        body: '"This needs to happen right now!" — rushing you stops you from stopping to think.'),
      const SizedBox(height: 8),
      _InfoCard(color: Colors.orange, emoji: '🧠', title: 'They know a little about you',
        body: 'Knowing your school name or teacher\'s name makes the fake story more believable.'),
      const SizedBox(height: 16),
      _TipBox(text: 'Anyone can CLAIM to be anyone online or on the phone. Always verify before sharing anything.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _StoryStep {
  final String emoji, speaker, text;
  const _StoryStep({required this.emoji, required this.speaker, required this.text});
}

class _StoryPanel extends StatelessWidget {
  final List<_StoryStep> steps;
  const _StoryPanel({required this.steps});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
    ),
    child: Column(
      children: steps.asMap().entries.map((e) {
        final s = e.value;
        final isLast = e.key == steps.length - 1;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 38, height: 38,
                decoration: BoxDecoration(
                  color: isLast ? _kRed.withValues(alpha: 0.15) : _kAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isLast ? _kRed.withValues(alpha: 0.4) : _kAccent.withValues(alpha: 0.3)),
                ),
                child: Center(child: Text(s.emoji, style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.speaker,
                  style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700,
                    color: isLast ? _kRed : _kAccent)),
                const SizedBox(height: 3),
                Text(s.text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4)),
              ])),
            ]),
          ),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.only(left: 33),
              child: Icon(Icons.arrow_downward, color: Color(0xFF2A3A55), size: 16),
            ),
        ]);
      }).toList(),
    ),
  );
}

class _Lesson2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson2({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Fake Identities 🪪',
        style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Pretexters put on many disguises. Here\'s who they pretend to be:',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _FakeIDCard(emoji: '👮', role: 'Fake Police / Authority',
        color: const Color(0xFFBBDEFB),
        script: '"This is the police. We\'re investigating an incident at your school. We need your home address immediately."',
        clue: 'Real police never contact children directly online or by text to ask for personal details.'),
      const SizedBox(height: 12),
      _FakeIDCard(emoji: '🧑‍💻', role: 'Fake IT / Tech Support',
        color: const Color(0xFFDCEDC8),
        script: '"I\'m from the school IT team. Your account has a virus — send me your password so I can fix it."',
        clue: 'Real IT staff never need your password. They can reset it themselves.'),
      const SizedBox(height: 12),
      _FakeIDCard(emoji: '🏆', role: 'Fake Competition Organiser',
        color: const Color(0xFFFFF9C4),
        script: '"Congratulations! I\'m calling about your prize. I just need your parent\'s bank details to transfer the winnings."',
        clue: 'Real competitions never ask for bank details over the phone or via a message.'),
      const SizedBox(height: 12),
      _FakeIDCard(emoji: '👫', role: 'Fake Friend / Classmate',
        color: const Color(0xFFF0EBFF),
        script: '"Hey, it\'s me from school! I lost my phone — can you tell me your address? I want to send your birthday card."',
        clue: 'Real friends don\'t suddenly ask for your address out of nowhere. Verify by calling them directly.'),
      const SizedBox(height: 16),
      _TipBox(text: 'The more official or familiar someone sounds, the more suspicious you should be if they\'re asking for personal information.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _FakeIDCard extends StatelessWidget {
  final String emoji, role, script, clue;
  final Color color;
  const _FakeIDCard({required this.emoji, required this.role, required this.script, required this.clue, required this.color});
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
          Text(role, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kAccent.withValues(alpha: 0.3), width: 1.2),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🎭 ', style: TextStyle(fontSize: 14)),
              Expanded(child: Text('"$script"',
                style: GoogleFonts.fredoka(fontSize: 13, color: _kPurple, fontStyle: FontStyle.italic, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🔍 ', style: TextStyle(fontSize: 14)),
            Expanded(child: Text(clue,
              style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4))),
          ]),
        ]),
      ),
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
      Text('Impersonation Online 💻',
        style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Online, pretexters have even more ways to fake who they are:',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🖼️ Fake Social Media Profiles',
          style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _kAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kAccent.withValues(alpha: 0.3), width: 1.2),
          ),
          child: Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(
                color: _kAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
              ),
              child: const Center(child: Text('👧', style: TextStyle(fontSize: 26)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sophie_Year8 ✓',
                style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
              Text('Goes to Westfield Academy 🏫',
                style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54)),
              Text('Loves Minecraft & football ⚽',
                style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54)),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
        _BulletPoint(text: 'This profile looks real — but it was made in minutes'),
        _BulletPoint(text: 'The photo is stolen from someone else\'s account'),
        _BulletPoint(text: 'The school name was guessed from your own profile'),
        _BulletPoint(text: 'The "✓" tick means nothing — anyone can add it'),
      ])),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('📧 Fake Emails That Look Official',
          style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 12),
        _EmailMockup(
          from: 'support@sch00l-help.com',
          subject: 'Important: Your school account needs updating',
          body: 'Dear student, please click the link below to verify your account within 24 hours or it will be deactivated.',
          isReal: false,
        ),
        const SizedBox(height: 10),
        _EmailMockup(
          from: 'itsupport@westfieldacademy.co.uk',
          subject: 'Scheduled maintenance this weekend',
          body: 'Please note the school portal will be offline Saturday 9am–1pm for scheduled updates. No action required.',
          isReal: true,
        ),
        const SizedBox(height: 10),
        _TipBox(text: 'Always check the full email address — "sch00l-help.com" uses zeros instead of the letter o to trick you!'),
      ])),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kGreen.withValues(alpha: 0.35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('🔐 How to verify if someone is real:',
            style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: _kGreen)),
          const SizedBox(height: 10),
          _VerifyRow(emoji: '📞', text: 'Call the real organisation using a number from their official website'),
          _VerifyRow(emoji: '👨‍👩‍👧', text: 'Ask a trusted adult to check the message with you'),
          _VerifyRow(emoji: '🌐', text: 'Visit the official website directly — don\'t click the link in the message'),
          _VerifyRow(emoji: '🤔', text: 'Ask yourself: Would the real organisation actually send this?'),
        ]),
      ),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(top: 6),
        width: 6, height: 6,
        decoration: BoxDecoration(color: _kRed, shape: BoxShape.circle),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
    ]),
  );
}

class _EmailMockup extends StatelessWidget {
  final String from, subject, body;
  final bool isReal;
  const _EmailMockup({required this.from, required this.subject, required this.body, required this.isReal});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isReal ? _kGreen.withValues(alpha: 0.08) : _kRed.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isReal ? _kGreen.withValues(alpha: 0.4) : _kRed.withValues(alpha: 0.4),
        width: 1.5,
      ),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(isReal ? Icons.check_circle : Icons.warning,
          color: isReal ? _kGreen : _kRed, size: 14),
        const SizedBox(width: 5),
        Text(isReal ? 'Looks legitimate ✅' : 'Suspicious ❌',
          style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700,
            color: isReal ? _kGreen : _kRed)),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Text('From: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
        Expanded(child: Text(from,
          style: GoogleFonts.fredoka(fontSize: 11,
            color: isReal ? Colors.white70 : _kRed,
            fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 3),
      Row(children: [
        Text('Subject: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
        Expanded(child: Text(subject,
          style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white70))),
      ]),
      const SizedBox(height: 6),
      Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
    ]),
  );
}

class _VerifyRow extends StatelessWidget {
  final String emoji, text;
  const _VerifyRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
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
      Text('Trust Your Instincts 🧠',
        style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text('Your gut feeling is one of your best defences against pretexting.',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 20),
      _WhiteCard(child: Column(children: [
        const Text('🤨', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 10),
        Text('That funny feeling is there for a reason', textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text('If something feels a bit off — even if you can\'t explain why — that feeling is important. Pretexters are very good at sounding convincing, but your instincts can still notice the signs.',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.5)),
      ])),
      const SizedBox(height: 20),
      Text('Warning feelings to listen to:',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 12),
      _InstinctCard(emoji: '😬', feeling: 'This feels rushed',
        detail: '"They keep saying I need to do it NOW." Real, legitimate requests always give you time to think and check.'),
      const SizedBox(height: 10),
      _InstinctCard(emoji: '🤔', feeling: 'Why do they need this from me?',
        detail: 'Your school already has your details. Your bank already knows your account number. Why would they ask again?'),
      const SizedBox(height: 10),
      _InstinctCard(emoji: '😟', feeling: 'Something doesn\'t add up',
        detail: 'Small inconsistencies — wrong name, slightly odd wording, strange timing — are signs a story might be fake.'),
      const SizedBox(height: 10),
      _InstinctCard(emoji: '🫣', feeling: 'I\'d feel embarrassed telling a parent',
        detail: 'If you\'d feel uncomfortable telling a trusted adult about the conversation — that\'s a big sign something is wrong.'),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kAccent.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('The PAUSE rule 🛑',
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: _kPurple)),
          const SizedBox(height: 10),
          _PauseRow(letter: 'P', word: 'Pause', desc: 'Stop what you\'re doing'),
          _PauseRow(letter: 'A', word: 'Ask', desc: 'Ask yourself if this makes sense'),
          _PauseRow(letter: 'U', word: 'Understand', desc: 'Think about why they want this info'),
          _PauseRow(letter: 'S', word: 'Seek help', desc: 'Tell a trusted adult before doing anything'),
          _PauseRow(letter: 'E', word: 'Exit', desc: 'Leave the conversation if something feels wrong'),
        ]),
      ),
      const SizedBox(height: 16),
      _TipBox(text: 'It\'s ALWAYS okay to say "I\'ll check with a parent first." A real person with good intentions will be happy to wait.'),
      const SizedBox(height: 28),
      _NextBtn(onTap: onNext, label: 'Final Challenge 🎭'),
    ]),
  );
}

class _InstinctCard extends StatelessWidget {
  final String emoji, feeling, detail;
  const _InstinctCard({required this.emoji, required this.feeling, required this.detail});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _kCard, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kAccent.withValues(alpha: 0.25), width: 1.2),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(
          color: _kAccent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('"$feeling"',
          style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: _kPurple)),
        const SizedBox(height: 3),
        Text(detail, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
      ])),
    ]),
  );
}

class _PauseRow extends StatelessWidget {
  final String letter, word, desc;
  const _PauseRow({required this.letter, required this.word, required this.desc});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Container(width: 28, height: 28,
        decoration: BoxDecoration(
          color: _kAccent.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: _kAccent.withValues(alpha: 0.5)),
        ),
        child: Center(child: Text(letter,
          style: GoogleFonts.fredoka(color: _kPurple, fontWeight: FontWeight.w700, fontSize: 13)))),
      const SizedBox(width: 10),
      Text('$word — ', style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
      Expanded(child: Text(desc, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54))),
    ]),
  );
}

class _FinalChallenge extends StatefulWidget {
  final VoidCallback onComplete;
  const _FinalChallenge({super.key, required this.onComplete});
  @override
  State<_FinalChallenge> createState() => _FinalChallengeState();
}

class _FinalChallengeState extends State<_FinalChallenge> {
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
      'title': 'The "IT Teacher"',
      'roomName': 'MrDavies_ITSupport',
      'roomAvatar': '🖥️',
      'messages': [
        {'from': 'stranger', 'text': 'Hi! I\'m Mr Davies, the new IT cover teacher. I\'m doing an account audit today 🖥️', 'delay': 700},
        {'from': 'you',      'text': 'Oh… okay?',                                                                            'delay': 1200},
        {'from': 'stranger', 'text': 'I just need to verify your school login. Can you tell me your username and password? It\'ll only take a second!', 'delay': 1400},
        {'from': 'stranger', 'text': 'Don\'t worry, it\'s completely routine — I just need to confirm everything is set up right for you 😊', 'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': [
        'Sure, my username is jamie123 and my password is...',
        'I\'ll give you my username but not my password',
        'I don\'t share my login with anyone — I\'ll check with my real teacher first',
      ],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '😨', 'title': 'That\'s very dangerous!',
          'points': ['Real teachers and IT staff NEVER need your password', 'This person could now log into your account and change everything', 'Always verify someone\'s identity before sharing any login details']},
        {'safe': false, 'emoji': '😬', 'title': 'Safer — but still risky!',
          'points': ['Your username can still be misused on its own', 'A real IT teacher would not ask for this via a message', 'The safest answer is always to check with a trusted adult first']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Excellent! You spotted the pretext! 🎉',
          'points': ['IT staff never need your password — they have admin tools', 'You correctly decided to verify through a trusted adult', 'This is exactly what the PAUSE rule looks like in action!']},
      ],
    },
    {
      'title': 'The "Old Friend"',
      'roomName': 'Mia_PrimarySchool',
      'roomAvatar': '👧',
      'messages': [
        {'from': 'stranger', 'text': 'Heyyy! It\'s Mia from your old primary school 😄 Do you remember me??', 'delay': 700},
        {'from': 'you',      'text': 'Oh hey! I think I remember you?',                                         'delay': 1200},
        {'from': 'stranger', 'text': 'Yes! We were in the same class! I moved away. I\'ve been trying to find everyone. Can I add you on Instagram?', 'delay': 1400},
        {'from': 'stranger', 'text': 'Also — do you still live near the park on Maple Road? That\'s where you used to live right? I want to send you a card!', 'delay': 1300},
      ],
      'question': 'How do you respond?',
      'choices': [
        'Yes I\'m on Instagram! And yes I still live near Maple Road 😊',
        'I\'ll add you on Instagram but I\'m not giving out my address',
        'I don\'t recognise you — I\'m not sharing anything until I\'ve checked with a parent',
      ],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'That\'s a lot of personal info to share!',
          'points': ['You confirmed your home address to a stranger — this is very unsafe', 'Pretexters build trust first, then extract information step by step', 'You can\'t verify someone is who they say they are based on a message']},
        {'safe': false, 'emoji': '😬', 'title': 'Good instinct on the address — but stay cautious!',
          'points': ['Adding an unverified stranger on social media still carries risk', 'They could use your Instagram to gather more info about you', 'Check with a parent before adding anyone you don\'t fully remember']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Perfect response! Safety first! 🎉',
          'points': ['You didn\'t confirm your address or share personal details', 'Checking with a parent is always the right call when unsure', 'Even if it really was an old friend — they\'d understand you being careful!']},
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
      widget.onComplete();
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
          Text('Final Challenge 🎭',
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
              final bool isYou = m['from'] == 'you';
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
                  style: GoogleFonts.fredoka(fontSize: 10, fontWeight: FontWeight.w600,
                    color: widget.isYou ? _kCyan.withValues(alpha: 0.6) : _kRed.withValues(alpha: 0.7))),
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
                    color: widget.isYou ? _kCyan.withValues(alpha: 0.3) : _kAccent.withValues(alpha: 0.2),
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
          border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
          AnimatedBuilder(
            animation: _dotAnims[i],
            builder: (_, _) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7, height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kAccent.withValues(alpha: 0.3 + 0.6 * _dotAnims[i].value),
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
                style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: _kPurple)))),
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
    {'emoji': '🎭', 'question': 'What is "pretexting"?',
      'options': ['Sending fake emails', 'Inventing a fake story and pretending to be someone else to get information', 'Installing a virus on a computer', 'Pretending to be ill to skip school'],
      'correct': 1, 'explanation': 'Pretexting means creating a false scenario and identity to trick someone into sharing information.'},
    {'emoji': '🧑‍💻', 'question': 'An online message says it\'s from your school\'s IT department and asks for your password. What should you do?',
      'options': ['Send your password — it\'s the IT team!', 'Send only your username, not your password', 'Refuse and tell a trusted adult — IT staff never need your password', 'Ignore it and hope they go away'],
      'correct': 2, 'explanation': 'Real IT staff have tools to fix accounts without needing your password. Never share it.'},
    {'emoji': '🔍', 'question': 'How can you tell if an email address is suspicious?',
      'options': ['It has your name in it', 'It uses tricks like "sch00l.com" (zeros instead of "o") to look official', 'It was sent in the morning', 'It uses capital letters'],
      'correct': 1, 'explanation': 'Pretexters use slight misspellings like "0" instead of "o" to make fake addresses look real at first glance.'},
    {'emoji': '🤔', 'question': 'Someone online claims to be an old friend and asks for your home address to send a card. What do you do?',
      'options': ['Give them your address — it\'s just a card!', 'Give your street name but not house number', 'Don\'t share anything and check with a trusted adult first', 'Ask them to send a gift instead'],
      'correct': 2, 'explanation': 'Even if it seems innocent, you cannot verify who someone is online. Never share your address without checking with a trusted adult.'},
    {'emoji': '🛑', 'question': 'What does the "P" in the PAUSE rule stand for?',
      'options': ['Password', 'Pause', 'Police', 'Privacy'],
      'correct': 1, 'explanation': 'P = Pause. Stop what you\'re doing before acting on any suspicious request.'},
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
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
            child: Text('${_qi + 1} / ${_questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: _kAccent, fontSize: 13))),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: (_qi + 1) / _questions.length, minHeight: 8,
            backgroundColor: _kAccent.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(_kAccent))),
        const SizedBox(height: 20),
        _WhiteCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          Text(q['question'] as String, textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
        const SizedBox(height: 20),
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
              bg = _kGreen.withValues(alpha: 0.1); border = _kGreen.withValues(alpha: 0.5); tc = _kGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: _kGreen);
            } else if (isSelected) {
              bg = _kRed.withValues(alpha: 0.1); border = _kRed.withValues(alpha: 0.5); tc = _kRed;
              trailing = const Icon(Icons.cancel_rounded, color: _kRed);
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
                        color: _answered && isCorrect ? _kGreen : _kPurple)))),
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
    if (_stars == 3) return 180;
    if (_stars == 2) return (180 * 0.7).round();
    return (180 * 0.4).round();
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
    if (_stars == 3) return "You've completed Pretexting!";
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
      await RetryDialog.show(context, lessonId: 'pretexting', score: widget.score, total: widget.total, onRetry: widget.onRetry);
      return;
    }
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'pretexting', stepsCompleted: 5, totalSteps: 5,
        stars: _stars, completed: true));
      if (!mounted) return;
      await XpAward.show(context, lessonId: 'pretexting', amount: 180);
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
      _InfoCard(color: _kAccent, emoji: '🎭', title: 'Badge Unlocked: Pretexting Detective!',
        body: 'You can now see through fake identities and invented stories!'),
      const SizedBox(height: 20),
      Align(alignment: Alignment.centerLeft,
        child: Text('WHAT YOU LEARNED', style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
      const SizedBox(height: 10),
      const _SummaryRow(emoji: '🎭', text: 'What pretexting is and how it works'),
      const _SummaryRow(emoji: '🪪', text: 'Common fake identities pretexters use'),
      const _SummaryRow(emoji: '💻', text: 'How impersonation works online and via email'),
      const _SummaryRow(emoji: '🧠', text: 'How to trust your instincts with the PAUSE rule'),
      const _SummaryRow(emoji: '🎬', text: 'Two real-life scenario challenges'),
      const SizedBox(height: 28),
      _NextBtn(
        onTap: () => _finish(context),
        enabled: _stars < 3 ? true : !claiming,
        label: _stars < 3 ? '🔄  Try Again' : (claiming ? 'Claiming...' : '🎉  Claim your XP!'),
      ),
    ]),
  );
}

class _SummaryRow extends StatelessWidget {
  final String emoji, text;
  const _SummaryRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54))),
      const Icon(Icons.check_circle_rounded, color: _kGreen, size: 18),
    ]),
  );
}