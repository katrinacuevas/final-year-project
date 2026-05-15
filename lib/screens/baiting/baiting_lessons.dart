// baiting_lessons.dart
// Intro + all 7 lesson steps for the Baiting Pro course.
// Baiting = greed and temptation (vs phishing = fear and urgency)
//
// Lesson 1 — What is Baiting?
// Lesson 2 — How Baiters Hook You (the psychology of temptation)
// Lesson 3 — Online Baiting Examples
// Lesson 4 — Real-Life Baiting (USB sticks, physical traps)
// Lesson 5 — Spot the Red Flags
// Lesson 6 — Real vs Fake Rewards
// Lesson 7 — What To Do

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'baiting_cat_messages.dart';
import 'baiting_theme.dart';
import 'baiting_widgets.dart';

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
class BaitingIntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const BaitingIntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(children: [
      Container(width: 110, height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [kBaitAccent, kBaitBg],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: kBaitAccent.withValues(alpha: 0.6), width: 2)),
        child: const Center(child: Text('🎁', style: TextStyle(fontSize: 54))))
        .animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Baiting Pro!', textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      Text('Learn how tricksters use tempting offers and freebies to trap you — and how to never fall for it! 🪤',
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
      const SizedBox(height: 24),
      BaitingInfoCard(color: kBaitCyan, emoji: '📖', title: "What you'll learn",
        body: "Spot digital traps, recognise red flags, and never take the bait!"),
      const SizedBox(height: 10),
      BaitingInfoCard(color: kBaitGreen, emoji: '⏱️', title: '~20 minutes',
        body: '7 lessons + Chat Simulation + quiz at the end!'),
      const SizedBox(height: 10),
      BaitingInfoCard(color: kBaitAccent, emoji: '⭐', title: 'Earn +200 XP',
        body: 'Complete everything to earn your Baiting Pro badge!'),
      const SizedBox(height: 28),
      BaitingCatButton(
        button: BaitingNextButton(onTap: onNext, label: '▶  Start Course'),
        message: BaitingCatMessages.lessonIntro,
      ),
    ]),
  );
}

// ─── Lesson 1: What is Baiting? ──────────────────────────────────────────────
class BaitingLesson1 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson1({super.key, required this.onNext});
  @override State<BaitingLesson1> createState() => _BaitingLesson1State();
}
class _BaitingLesson1State extends State<BaitingLesson1> {
  static const int _total = 5;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'WHAT IS BAITING?'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        if (_revealed >= 1)
          BaitingCard(child: Column(children: [
            const Text('🪤', style: TextStyle(fontSize: 52)), const SizedBox(height: 10),
            Text('A trickster offers something exciting — free stuff, prizes...',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Text('It\'s a trap to make you click something or give away your info!', textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white70, height: 1.5)),
          ])).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
        if (_revealed >= 1) ...[
          const SizedBox(height: 16),
          Text('Think of it like a fishing trap 🎣',
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))
            .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 10),
        ],
        if (_revealed >= 2)
          BaitingCard(child: const BaitingTrapRow(emoji: '🐟', text: 'A fish sees yummy bait dangling on a hook'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 3) ...[
          const SizedBox(height: 8),
          BaitingCard(child: const BaitingTrapRow(emoji: '🎮', text: 'You see "FREE game skins — click here NOW!"'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 8),
          BaitingCard(child: const BaitingTrapRow(emoji: '🪤', text: 'The fish bites and gets caught'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 5) ...[
          const SizedBox(height: 8),
          BaitingCard(child: const BaitingTrapRow(emoji: '😨', text: 'You click and your device or account gets hacked'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 30)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext),
          message: _allRevealed ? BaitingCatMessages.lesson1Tip : 'Tap the screen! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 2: How Baiters Hook You ──────────────────────────────────────────
class BaitingLesson2 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson2({super.key, required this.onNext});
  @override State<BaitingLesson2> createState() => _BaitingLesson2State();
}
class _BaitingLesson2State extends State<BaitingLesson2> {
  static const int _total = 4;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'HOW BAITERS HOOK YOU'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        Text('Baiting is different from phishing — it targets your GREED, not your fear.',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.4)),
        const SizedBox(height: 12),
        // Phishing vs Baiting comparison card
        BaitingCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('⚡ Phishing vs Baiting', style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: kBaitAccent)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kBaitRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBaitRed.withValues(alpha: 0.3))),
              child: Column(children: [
                const Text('🎣', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text('Phishing', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: kBaitRed)),
                const SizedBox(height: 4),
                Text('Uses FEAR\n"Your account will be deleted!"',
                  textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white54, height: 1.3)),
              ]))),
            const SizedBox(width: 10),
            Expanded(child: Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kBaitAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBaitAccent.withValues(alpha: 0.3))),
              child: Column(children: [
                const Text('🪤', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text('Baiting', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: kBaitAccent)),
                const SizedBox(height: 4),
                Text('Uses GREED\n"Free games — click here!"',
                  textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white54, height: 1.3)),
              ]))),
          ]),
        ])).animate().fadeIn(duration: 350.ms),
        if (_revealed >= 1) ...[
          const SizedBox(height: 14),
          BaitingInfoCard(color: kBaitAccent, emoji: '🎮', title: 'They target what you love',
            body: 'Love Fortnite? They offer free V-Bucks. Love music? Free downloads. They know exactly what to dangle!')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 2) ...[
          const SizedBox(height: 10),
          BaitingInfoCard(color: const Color(0xFFBA68C8), emoji: '⏰', title: 'They create fake urgency',
            body: '"Only 5 minutes left!" — even though the offer is about exciting things, they add a countdown to stop you thinking carefully.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 10),
          BaitingInfoCard(color: kBaitGreen, emoji: '🧠', title: 'They bypass your brain',
            body: 'Excitement switches off careful thinking — and they know it!')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 10),
          BaitingInfoCard(color: kBaitRed, emoji: '🔑', title: 'The price is your safety',
            body: 'Nothing\'s actually free — it costs your password, your details, or a virus on your device.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext),
          message: _allRevealed ? BaitingCatMessages.lesson2Tip : 'Tap to reveal each one! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 3: Online Baiting Examples ───────────────────────────────────────
class BaitingLesson3 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson3({super.key, required this.onNext});
  @override State<BaitingLesson3> createState() => _BaitingLesson3State();
}
class _BaitingLesson3State extends State<BaitingLesson3> {
  static const int _total = 4;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'ONLINE BAITING EXAMPLES'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        Text("Here's how baiters trick people online — see if you recognise any of these!",
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 12),
        if (_revealed >= 1)
          BaitingExampleCard(emoji: '🎮', color: const Color(0xFFE8D5FB),
            title: 'Free Game Items',
            baitMsg: 'Get 10,000 free V-Bucks! Click here NOW before it expires!',
            why: 'The link steals your login or puts harmful software on your device — not V-Bucks!')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 12),
          BaitingExampleCard(emoji: '🏆', color: const Color(0xFFFFF9C4),
            title: 'Fake Prize Winner',
            baitMsg: 'You\'ve been randomly selected! Claim your £500 prize now!',
            why: 'You never entered — they just want your personal details or home address.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 12),
          BaitingExampleCard(emoji: '🎵', color: const Color(0xFFB2EBF2),
            title: 'Free Music & Films',
            baitMsg: 'Download any song or movie for free — no account needed!',
            why: 'The download secretly hides harmful software inside — your device gets infected.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 12),
          BaitingExampleCard(emoji: '📱', color: const Color(0xFFDCEDC8),
            title: 'Win a Free Phone',
            baitMsg: 'Win the latest iPhone — just complete this quick survey!',
            why: 'Surveys steal your info. Nobody gives away phones to random strangers!')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext),
          message: _allRevealed ? BaitingCatMessages.lesson3Tip : 'Tap to reveal each example! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 4: Real-Life Baiting ─────────────────────────────────────────────
class BaitingLesson4 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson4({super.key, required this.onNext});
  @override State<BaitingLesson4> createState() => _BaitingLesson4State();
}
class _BaitingLesson4State extends State<BaitingLesson4> {
  static const int _total = 3;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'REAL-LIFE BAITING'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        Text("Baiting doesn't just happen online — it can happen in real life too!",
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 12),
        if (_revealed >= 1)
          BaitingCard(child: Column(children: [
            const Text('🖲️', style: TextStyle(fontSize: 52)), const SizedBox(height: 12),
            Text('The USB Stick Trick', textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 8),
            Text('A hacker leaves a USB stick on the floor with a tempting label. Someone picks it up and plugs it in... and the trap is sprung! 💥',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.5)),
            const SizedBox(height: 12),
            const BaitingTrapRow(emoji: '💻', text: 'Their computer gets infected instantly'),
            const BaitingTrapRow(emoji: '🔓', text: 'The hacker can access all their files'),
            const BaitingTrapRow(emoji: '📷', text: 'Even the camera could be turned on secretly'),
          ])).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 14),
          Text('Other physical traps:', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))
            .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 10),
          BaitingInfoCard(color: Colors.orange, emoji: '📀', title: 'Free CDs or QR Codes',
            body: 'A free disc or leaflet with a QR code that leads to a dangerous website when you scan it.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 8),
          BaitingInfoCard(color: Colors.purple, emoji: '🎁', title: 'Suspicious "Prize" Packages',
            body: '"You\'ve won! Pick it up here!" — used to steal your details or lure you somewhere unsafe.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext),
          message: _allRevealed ? BaitingCatMessages.lesson4Tip : 'Tap to reveal each trap! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 5: Spot the Red Flags ────────────────────────────────────────────
class BaitingLesson5 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson5({super.key, required this.onNext});
  @override State<BaitingLesson5> createState() => _BaitingLesson5State();
}
class _BaitingLesson5State extends State<BaitingLesson5> {
  static const _flags = [
    ('⏰ Countdown timers',         '"Only 5 minutes left!" — rushing you stops you from thinking clearly.'),
    ('🆓 Too good to be true',      'Free phones, free money, free premium games — nobody gives these to strangers.'),
    ('🔗 Suspicious links',         'Strange URLs like "fr33-v-bucks.xyz" instead of official game websites.'),
    ('📝 Asking for personal info', '"Just fill in your name, school, and address to claim!" — real prizes don\'t need all this.'),
    ('🎰 "You\'ve been selected!"', 'You can\'t win something you never entered. This is almost always fake.'),
    ('😮 Creates excitement',       'Baiters want you to act fast without thinking. Big emotions = big mistakes.'),
  ];
  final Set<int> _expanded = {};
  final Set<int> _everTapped = {};
  bool get _allTapped => _everTapped.length >= _flags.length;
  void _toggle(int i) {
    SoundService.playClick();
    setState(() {
      _everTapped.add(i);
      if (_expanded.contains(i)) _expanded.remove(i);
      else _expanded.add(i);
    });
  }
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BaitingLessonLabel(label: 'SPOT THE RED FLAGS'),
      const SizedBox(height: 6),
      Text('Tap each flag to reveal the detail. 🚩',
        style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
      const SizedBox(height: 16),
      for (int i = 0; i < _flags.length; i++) ...[
        BaitingTappableCard(
          number: '${i + 1}', emoji: '🚩',
          color: kBaitRed, title: _flags[i].$1, body: _flags[i].$2,
          isExpanded: _expanded.contains(i), onTap: () => _toggle(i),
        ),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 30),
      BaitingCatButton(
        button: BaitingNextButton(onTap: widget.onNext),
        message: _allTapped ? BaitingCatMessages.lesson5Tip : 'Tap each red flag to reveal it! 👆',
        showBubble: true,
        showButton: _allTapped,
      ),
    ]),
  );
}

// ─── Lesson 6: Real vs Fake Rewards ──────────────────────────────────────────
class BaitingLesson6 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson6({super.key, required this.onNext});
  @override State<BaitingLesson6> createState() => _BaitingLesson6State();
}
class _BaitingLesson6State extends State<BaitingLesson6> {
  static const int _total = 2;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'REAL VS FAKE REWARDS'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        Text("Not everything is a trap — here's how to tell the difference:",
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 12),
        if (_revealed >= 1)
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kBaitGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBaitGreen.withValues(alpha: 0.35))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('✅ Real Rewards', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: kBaitGreen)),
              const SizedBox(height: 10),
              const BaitingCompareRow(emoji: '🌐', text: 'Come from official, well-known websites'),
              const BaitingCompareRow(emoji: '📧', text: 'Sent to email you actually registered with'),
              const BaitingCompareRow(emoji: '⏳', text: 'No extreme time pressure — they give you days'),
              const BaitingCompareRow(emoji: '🔒', text: 'Only ask for info you\'d expect (e.g. delivery address)'),
              const BaitingCompareRow(emoji: '📞', text: 'You can verify by calling the official company'),
            ])).animate().fadeIn(duration: 350.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kBaitRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBaitRed.withValues(alpha: 0.35))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('❌ Fake Bait', style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: kBaitRed)),
              const SizedBox(height: 10),
              const BaitingCompareRow(emoji: '🔗', text: 'Comes from strange, unofficial links'),
              const BaitingCompareRow(emoji: '📨', text: 'Sent randomly — you never signed up for anything'),
              const BaitingCompareRow(emoji: '⏰', text: 'Extreme urgency — "5 minutes left!"'),
              const BaitingCompareRow(emoji: '📋', text: 'Wants your school, address, and passwords'),
              const BaitingCompareRow(emoji: '🚫', text: 'No official contact number to verify with'),
            ])).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext),
          message: _allRevealed ? BaitingCatMessages.lesson6Tip : 'Tap to reveal each side! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 7: What To Do ────────────────────────────────────────────────────
class BaitingLesson7 extends StatefulWidget {
  final VoidCallback onNext;
  const BaitingLesson7({super.key, required this.onNext});
  @override State<BaitingLesson7> createState() => _BaitingLesson7State();
}
class _BaitingLesson7State extends State<BaitingLesson7> {
  static const int _total = 5;
  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _total;
  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() { if (!_promptShown) _promptShown = true; _revealed++; });
  }
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: _onTap,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const BaitingLessonLabel(label: 'WHAT TO DO'),
        const SizedBox(height: 8),
        _RevealProgress(revealed: _revealed, total: _total, color: kBaitAccent),
        const SizedBox(height: 12),
        Text("If you think you've spotted a bait — follow these steps:",
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 10),
        if (_revealed >= 1)
          BaitingStepCard(number: '1', emoji: '🛑', color: kBaitRed,
            title: 'STOP — close the tab or put down the device',
            body: 'Don\'t click anything else. Remove yourself from the situation straight away.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 10),
          BaitingStepCard(number: '2', emoji: '🤔', color: kBaitAccent,
            title: 'Ask: Why would a stranger give me this?',
            body: 'Did I enter a competition? Is this an official website? Would a real company do this?')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 10),
          BaitingStepCard(number: '3', emoji: '🗣️', color: const Color(0xFFBA68C8),
            title: 'Tell a trusted adult',
            body: 'Show a parent, carer, or teacher. They can check if it\'s real and report it if not.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 10),
          BaitingStepCard(number: '4', emoji: '🚫', color: kBaitCyan,
            title: 'Block and report',
            body: 'If someone sent you a bait message, block them and use the report button in the app.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 5) ...[
          const SizedBox(height: 10),
          BaitingStepCard(number: '5', emoji: '📵', color: kBaitGreen,
            title: 'Never go back',
            body: 'Even if you\'re curious — don\'t revisit the link or message. The bait is still there.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],
        const SizedBox(height: 20),
        BaitingCatButton(
          button: BaitingNextButton(onTap: widget.onNext, label: 'Chat Simulation 💬'),
          message: _allRevealed ? BaitingCatMessages.lesson7Tip : 'Tap to reveal each step! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}