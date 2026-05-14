// pretexting_lessons.dart
// Intro + 6 lessons for the Pretexting Detective course.
//
// Lesson 1 — What is Pretexting?        (intro concept + story example)
// Lesson 2 — Why Does It Work?          (3 reasons: trust / urgency / details)
// Lesson 3 — Who Do They Pretend To Be? (4 fake ID cards)
// Lesson 4 — Sneaky Online Tricks       (fake profiles, emails, how to check)
// Lesson 5 — Trust Your Gut!            (4 warning feelings)
// Lesson 6 — The PAUSE Rule             (P-A-U-S-E breakdown + final tips)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'pretexting_cat_messages.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';

// ─── Progress Dots ────────────────────────────────────────────────────────────
class _RevealProgress extends StatelessWidget {
  final int revealed;
  final int total;
  final Color color;
  const _RevealProgress({required this.revealed, required this.total, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(total, (i) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: i < revealed ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: i < revealed ? color : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    )),
  );
}

// ─── Intro ────────────────────────────────────────────────────────────────────
class PretextingIntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const PretextingIntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [kPretextAccent, kPretextBg],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                  color: kPretextAccent.withValues(alpha: 0.6), width: 2),
            ),
            child: const Center(
                child: Text('🎭', style: TextStyle(fontSize: 54))),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text('Pretexting Detective!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(
              'Learn how sneaky tricksters pretend to be someone else — and how to see right through their disguise! 🕵️',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                  fontSize: 15, color: Colors.white54, height: 1.5)),
          const SizedBox(height: 24),
          PretextingInfoCard(
            color: kPretextCyan,
            emoji: '📖',
            title: "What you'll learn",
            body: "What pretexting is, why it works, the disguises people use, sneaky online tricks, and how to trust your gut.",
          ),
          const SizedBox(height: 10),
          PretextingInfoCard(
            color: kPretextGreen,
            emoji: '⏱️',
            title: '~20 minutes',
            body: '6 lessons + Chat Simulation + quiz at the end!',
          ),
          const SizedBox(height: 10),
          PretextingInfoCard(
            color: kPretextAccent,
            emoji: '⭐',
            title: 'Earn up to +180 XP',
            body: 'Complete everything to earn your Pretexting Detective badge!',
          ),
          const SizedBox(height: 28),
          PretextingCatButton(
            button: PretextingNextButton(onTap: onNext, label: '▶  Start Course'),
            message: PretextingCatMessages.lessonIntro,
          ),
        ]),
      );
}

// ─── Lesson 1: What is Pretexting? ───────────────────────────────────────────
class PretextingLesson1 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson1({super.key, required this.onNext});
  @override
  State<PretextingLesson1> createState() => _PretextingLesson1State();
}

class _PretextingLesson1State extends State<PretextingLesson1> {
  static const int _total = 2;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PretextingLessonLabel(label: 'WHAT IS PRETEXTING?'),
            const SizedBox(height: 8),
            _RevealProgress(revealed: _revealed, total: _total, color: kPretextAccent),
            const SizedBox(height: 12),

            // Reveal 1: Core concept card
            if (_revealed >= 1)
              PretextingCard(
                child: Column(children: [
                  const Text('🎭', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 10),
                  Text(
                      'Pretexting is when someone makes up a fake story — a "made-up reason" — and pretends to be someone they\'re not, to trick you into sharing your secrets.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5)),
                ]),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

            if (_revealed >= 1) ...[
              const SizedBox(height: 16),
              Text('Here\'s what it looks like 🎬',
                  style: GoogleFonts.fredoka(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 10),
            ],

            // Reveal 2: Story panel
            if (_revealed >= 2)
              PretextingStoryPanel(
                steps: const [
                  PretextingStoryStep(
                    emoji: '📞',
                    speaker: 'Stranger',
                    text: '"Hi! I\'m Mr Davies, the school IT teacher. I need your login details to fix your account!"',
                  ),
                  PretextingStoryStep(
                    emoji: '😮',
                    speaker: 'You',
                    text: '"Oh! The IT teacher? Okay, my username is..."',
                  ),
                  PretextingStoryStep(
                    emoji: '😈',
                    speaker: 'The truth!',
                    text: 'They were NEVER the IT teacher. They made up the story to steal your login!',
                    isDanger: true,
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 2) const SizedBox(height: 12),

            const SizedBox(height: 20),
            PretextingCatButton(
              button: PretextingNextButton(onTap: widget.onNext),
              message: _allRevealed
                  ? PretextingCatMessages.lesson1Tip
                  : 'Tap the screen to reveal! 👆',
              showBubble: !_promptShown || _allRevealed,
              showButton: _allRevealed,
            ),
          ]),
        ),
      );
}

// ─── Lesson 2: Why Does It Work? ─────────────────────────────────────────────
class PretextingLesson2 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson2({super.key, required this.onNext});
  @override
  State<PretextingLesson2> createState() => _PretextingLesson2State();
}

class _PretextingLesson2State extends State<PretextingLesson2> {
  static const int _total = 3;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PretextingLessonLabel(label: 'WHY DOES IT WORK?'),
            const SizedBox(height: 8),
            _RevealProgress(revealed: _revealed, total: _total, color: kPretextAccent),
            const SizedBox(height: 12),
            Text('Pretexters are sneaky! They use 3 clever tricks to make you believe their fake story.',
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white54, height: 1.4)),
            const SizedBox(height: 16),

            // Reveal 1: Trust authority
            if (_revealed >= 1)
              PretextingInfoCard(
                color: kPretextPurple,
                emoji: '🤝',
                title: 'We trust grown-ups in charge',
                body: 'Teachers, IT staff, doctors, police — we\'re taught to listen to them. Sneaky people pretend to BE these important people!',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 1) const SizedBox(height: 10),

            // Reveal 2: Urgency
            if (_revealed >= 2)
              PretextingInfoCard(
                color: kPretextCyan,
                emoji: '⚡',
                title: 'They make it feel URGENT',
                body: '"This needs to happen RIGHT NOW!" — rushing you stops you from stopping to think. That\'s exactly what they want!',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 2) const SizedBox(height: 10),

            // Reveal 3: They know a bit about you
            if (_revealed >= 3) ...[
              PretextingInfoCard(
                color: Colors.orange,
                emoji: '🧠',
                title: 'They know a little bit about you',
                body: 'Knowing your school name or teacher\'s name makes the fake story sound more believable. But it\'s still completely made up!',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 20),
            PretextingCatButton(
              button: PretextingNextButton(onTap: widget.onNext),
              message: _allRevealed
                  ? PretextingCatMessages.lesson2Tip
                  : 'Tap to reveal each trick! 👆',
              showBubble: !_promptShown || _allRevealed,
              showButton: _allRevealed,
            ),
          ]),
        ),
      );
}

// ─── Lesson 3: Who Do They Pretend To Be? ────────────────────────────────────
class PretextingLesson3 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson3({super.key, required this.onNext});
  @override
  State<PretextingLesson3> createState() => _PretextingLesson3State();
}

class _PretextingLesson3State extends State<PretextingLesson3> {
  static const int _total = 4;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PretextingLessonLabel(label: 'WHO DO THEY PRETEND TO BE?'),
            const SizedBox(height: 8),
            _RevealProgress(revealed: _revealed, total: _total, color: kPretextAccent),
            const SizedBox(height: 12),
            Text('Pretexters put on LOTS of disguises. Tap to reveal each one!',
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white38)),
            const SizedBox(height: 16),

            // Reveal 1: Fake IT Support
            if (_revealed >= 1)
              PretextingFakeIDCard(
                emoji: '🧑‍💻',
                role: 'Fake IT / Tech Support',
                color: const Color(0xFFDCEDC8),
                script: 'Your account has a virus — send me your password so I can fix it.',
                clue: 'Real IT staff NEVER need your password. They can reset it themselves without asking you!',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 1) const SizedBox(height: 12),

            // Reveal 2: Fake Police
            if (_revealed >= 2)
              PretextingFakeIDCard(
                emoji: '👮',
                role: 'Fake Police / Authority',
                color: const Color(0xFFBBDEFB),
                script: 'This is the police. We need your home address immediately for our investigation.',
                clue: 'Real police never contact children directly online or by text to ask for personal details.',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 2) const SizedBox(height: 12),

            if (_revealed >= 2 && _revealed < _total)
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kPretextAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kPretextAccent.withValues(alpha: 0.25)),
                ),
                child: Row(children: [
                  const Text('😸', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Great work so far! Keep tapping to learn more! 👆',
                    style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
                ]),
              ).animate().fadeIn(duration: 400.ms),

            // Reveal 3: Fake Competition
            if (_revealed >= 3)
              PretextingFakeIDCard(
                emoji: '🏆',
                role: 'Fake Competition Person',
                color: const Color(0xFFFFF9C4),
                script: 'Congratulations! You\'ve won a prize! I just need your parent\'s bank details to send the money.',
                clue: 'Real competitions NEVER ask for bank details over the phone or in a message. It\'s always fake!',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),

            if (_revealed >= 3) const SizedBox(height: 12),

            // Reveal 4: Fake Friend
            if (_revealed >= 4) ...[
              PretextingFakeIDCard(
                emoji: '👫',
                role: 'Fake Friend / Classmate',
                color: const Color(0xFFF0EBFF),
                script: 'Hey! It\'s me from school! I lost my phone — can you send me your address? I want to post your birthday card!',
                clue: 'Real friends don\'t suddenly ask for your address out of nowhere! Verify by calling them on a real number.',
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 20),
            PretextingCatButton(
              button: PretextingNextButton(onTap: widget.onNext),
              message: _allRevealed
                  ? PretextingCatMessages.lesson3Tip
                  : 'Tap to reveal each disguise! 👆',
              showBubble: !_promptShown || _allRevealed,
              showButton: _allRevealed,
            ),
          ]),
        ),
      );
}

// ─── Lesson 4: Sneaky Online Tricks ──────────────────────────────────────────
class PretextingLesson4 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson4({super.key, required this.onNext});
  @override
  State<PretextingLesson4> createState() => _PretextingLesson4State();
}

class _PretextingLesson4State extends State<PretextingLesson4> {
  static const int _total = 4;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PretextingLessonLabel(label: 'SNEAKY ONLINE TRICKS'),
            const SizedBox(height: 8),
            _RevealProgress(revealed: _revealed, total: _total, color: kPretextAccent),
            const SizedBox(height: 12),
            Text('Online, pretexters have even MORE ways to fool you. Tap to see them!',
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white38)),
            const SizedBox(height: 16),

            // Reveal 1: Fake social media profile
            if (_revealed >= 1)
              PretextingCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🖼️ Fake Social Media Profiles',
                      style: GoogleFonts.fredoka(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPretextAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: kPretextAccent.withValues(alpha: 0.3),
                          width: 1.2),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kPretextAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: kPretextAccent.withValues(alpha: 0.3)),
                        ),
                        child: const Center(
                            child: Text('👧',
                                style: TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Sophie_Year8 ✓',
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Colors.white)),
                            Text('Goes to Westfield Academy 🏫',
                                style: GoogleFonts.fredoka(
                                    fontSize: 11, color: Colors.white54)),
                            Text('Loves Minecraft & football ⚽',
                                style: GoogleFonts.fredoka(
                                    fontSize: 11, color: Colors.white54)),
                          ])),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  _BulletWarning(text: 'This profile was made in just a few minutes!'),
                  _BulletWarning(text: 'The profile photo is stolen from someone else'),
                  _BulletWarning(text: 'The school name was guessed from YOUR profile'),
                  _BulletWarning(text: 'The ✓ tick means NOTHING — anyone can add it'),
                ]),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

            if (_revealed >= 1) const SizedBox(height: 14),

            // Reveal 2: Fake email (bad one)
            if (_revealed >= 2) ...[
              Text('📧 Fake Emails That Look Official',
                  style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 10),
              PretextingEmailMockup(
                from: 'support@sch00l-help.com',
                subject: 'Important: Your account needs updating NOW',
                body: 'Dear student, click the link below to verify your account within 24 hours or it will be deleted.',
                isReal: false,
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              const SizedBox(height: 8),
            ],

            if (_revealed >= 2 && _revealed < _total)
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kPretextAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kPretextAccent.withValues(alpha: 0.25)),
                ),
                child: Row(children: [
                  const Text('😸', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Great work so far! Keep tapping to learn more! 👆',
                    style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
                ]),
              ).animate().fadeIn(duration: 400.ms),

            // Reveal 3: Real email comparison
            if (_revealed >= 3) ...[
              PretextingEmailMockup(
                from: 'itsupport@westfieldacademy.co.uk',
                subject: 'Scheduled maintenance this weekend',
                body: 'The school portal will be offline Saturday 9am–1pm for updates. No action needed from you.',
                isReal: true,
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              const SizedBox(height: 14),
            ],

            // Reveal 4: How to check
            if (_revealed >= 4) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPretextGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: kPretextGreen.withValues(alpha: 0.35)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🔐 How to check if it\'s real:',
                      style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kPretextGreen)),
                  const SizedBox(height: 10),
                  _CheckRow(emoji: '👀', text: 'Look at the FULL email address — spot any weird letters or numbers?'),
                  _CheckRow(emoji: '👨‍👩‍👧', text: 'Ask a trusted grown-up to look at it with you'),
                  _CheckRow(emoji: '🌐', text: 'Go to the official website yourself — never click the link in the message!'),
                  _CheckRow(emoji: '🤔', text: 'Ask: would my real school actually send this?'),
                ]),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 20),
            PretextingCatButton(
              button: PretextingNextButton(onTap: widget.onNext),
              message: _allRevealed
                  ? PretextingCatMessages.lesson4Tip
                  : 'Tap to reveal each trick! 👆',
              showBubble: !_promptShown || _allRevealed,
              showButton: _allRevealed,
            ),
          ]),
        ),
      );
}

class _BulletWarning extends StatelessWidget {
  final String text;
  const _BulletWarning({required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: kPretextRed, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white54, height: 1.4))),
        ]),
      );
}

class _CheckRow extends StatelessWidget {
  final String emoji, text;
  const _CheckRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white70, height: 1.4))),
        ]),
      );
}

// ─── Lesson 5: Trust Your Gut! ───────────────────────────────────────────────
class PretextingLesson5 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson5({super.key, required this.onNext});
  @override
  State<PretextingLesson5> createState() => _PretextingLesson5State();
}

class _PretextingLesson5State extends State<PretextingLesson5> {
  static const _feelings = [
    (
      '⏰',
      '"This feels really rushed!"',
      '"Do it NOW! You only have 5 minutes!" — Real, genuine requests ALWAYS give you time to think and check with a grown-up.'
    ),
    (
      '🤔',
      '"Why do they need THIS from ME?"',
      'Your school already has your details. Your parents\' bank already knows the account number. Why would they ask YOU again?'
    ),
    (
      '😟',
      '"Something doesn\'t add up..."',
      'Wrong name, weird wording, strange timing — small things that feel off are signs the story might be made up.'
    ),
    (
      '🫣',
      '"I\'d feel embarrassed telling a parent"',
      'If you\'d feel awkward telling a grown-up about the conversation — that\'s a BIG sign something is wrong!'
    ),
  ];

  final Set<int> _expanded = {};
  final Set<int> _everTapped = {};
  bool get _allTapped => _everTapped.length >= _feelings.length;

  void _toggle(int i) {
    SoundService.playClick();
    setState(() {
      _everTapped.add(i);
      if (_expanded.contains(i)) {
        _expanded.remove(i);
      } else {
        _expanded.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PretextingLessonLabel(label: 'TRUST YOUR GUT!'),
          const SizedBox(height: 6),
          Text('Your belly feeling is one of your best superpowers! 🦸',
              style: GoogleFonts.fredoka(
                  fontSize: 14, color: Colors.white54, height: 1.4)),
          const SizedBox(height: 16),

          // Intro card
          PretextingCard(
            child: Column(children: [
              const Text('🤨', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text('That funny feeling inside is there for a reason!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                  'Even if you can\'t explain WHY something feels off — that feeling matters! Pretexters are really good at sounding convincing, but your gut can still notice the signs.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white70, height: 1.5)),
            ]),
          ).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 20),
          Text('Tap each feeling to find out why it matters 👇',
              style: GoogleFonts.fredoka(
                  fontSize: 13, color: Colors.white38)),
          const SizedBox(height: 12),

          for (int i = 0; i < _feelings.length; i++) ...[
            PretextingTappableCard(
              emoji: _feelings[i].$1,
              title: _feelings[i].$2,
              body: _feelings[i].$3,
              color: kPretextAccent,
              isExpanded: _expanded.contains(i),
              onTap: () => _toggle(i),
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 20),
          PretextingCatButton(
            button: PretextingNextButton(
                onTap: widget.onNext, label: 'The PAUSE Rule →'),
            message: _allTapped
                ? PretextingCatMessages.lesson5Tip
                : 'Tap each feeling to reveal it! 👆',
            showBubble: true,
            showButton: _allTapped,
          ),
        ]),
      );
}

// ─── Lesson 6: The PAUSE Rule ─────────────────────────────────────────────────
class PretextingLesson6 extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingLesson6({super.key, required this.onNext});
  @override
  State<PretextingLesson6> createState() => _PretextingLesson6State();
}

class _PretextingLesson6State extends State<PretextingLesson6> {
  static const int _total = 5;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  static const _steps = [
    ('P', 'Pause', '🛑', kPretextRed,      'Stop what you\'re doing RIGHT NOW. Don\'t click, don\'t type, don\'t say anything yet.'),
    ('A', 'Ask',   '🤔', kPretextCyan,     'Ask yourself: does this actually make sense? Would my real school / IT team / friend really do this?'),
    ('U', 'Understand', '🧠', Colors.orange, 'Think about WHY they want this info from you. What would they do with it?'),
    ('S', 'Seek help', '🗣️', kPretextAccent, 'Tell a trusted grown-up BEFORE doing anything. Show them the message or explain what happened.'),
    ('E', 'Exit', '🚪', kPretextGreen,     'Leave the conversation. Close the tab. Put down the phone. You\'ve done the right thing!'),
  ];

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PretextingLessonLabel(label: 'THE PAUSE RULE'),
            const SizedBox(height: 8),
            _RevealProgress(revealed: _revealed, total: _total, color: kPretextAccent),
            const SizedBox(height: 12),
            Text('Your secret weapon against pretexting! Tap to reveal each step.',
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white38)),
            const SizedBox(height: 16),

            // Intro banner
            PretextingCard(
              child: Column(children: [
                const Text('🛑', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text('When something feels suspicious — PAUSE!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text('Five simple steps that keep you safe every single time:',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                        fontSize: 13, color: Colors.white54, height: 1.4)),
              ]),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 16),

            // Tap-to-reveal PAUSE steps
            for (int i = 0; i < _steps.length; i++) ...[
              if (_revealed > i) ...[
                _PauseStepCard(
                  letter: _steps[i].$1,
                  word: _steps[i].$2,
                  emoji: _steps[i].$3,
                  color: _steps[i].$4,
                  detail: _steps[i].$5,
                ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
                const SizedBox(height: 10),
              ],
              if (i == 2 && _revealed > i && _revealed < _total)
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: kPretextAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kPretextAccent.withValues(alpha: 0.25)),
                  ),
                  child: Row(children: [
                    const Text('😸', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Great work so far! Keep tapping to learn more! 👆',
                      style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
                  ]),
                ).animate().fadeIn(duration: 400.ms),
            ],

            const SizedBox(height: 20),
            PretextingCatButton(
              button: PretextingNextButton(
                  onTap: widget.onNext, label: 'Chat Simulation 💬'),
              message: _allRevealed
                  ? PretextingCatMessages.lesson6Tip
                  : 'Tap to reveal each step! 👆',
              showBubble: !_promptShown || _allRevealed,
              showButton: _allRevealed,
            ),
          ]),
        ),
      );
}

class _PauseStepCard extends StatelessWidget {
  final String letter, word, emoji, detail;
  final Color color;
  const _PauseStepCard({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.color,
    required this.detail,
  });
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: color.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                        child: Text(letter,
                            style: GoogleFonts.fredoka(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 13))),
                  ),
                  const SizedBox(width: 8),
                  Text(word,
                      style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ]),
                const SizedBox(height: 6),
                Text(detail,
                    style: GoogleFonts.fredoka(
                        fontSize: 12,
                        color: Colors.white54,
                        height: 1.45)),
              ])),
        ]),
      );
}
