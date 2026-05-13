import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'phishing_cat_messages.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';

// ─── Intro ────────────────────────────────────────────────────────────────────
class PhishingIntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const PhishingIntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(children: [
      Container(width: 110, height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [kPhishingAccent, kPhishingBg],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: kPhishingAccent.withValues(alpha: 0.6), width: 2)),
        child: const Center(child: Text('🎣', style: TextStyle(fontSize: 54))))
        .animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Phishing Detective!', textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      Text('Learn how cybercriminals send fake messages to trick you — and become an expert at spotting them! 🕵️',
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
      const SizedBox(height: 24),
      PhishingInfoCard(color: kPhishingAccent, emoji: '📖', title: "What you'll learn",
        body: 'What phishing is, how to spot fake emails and messages, red flags, what to do, and real chat simulations.'),
      const SizedBox(height: 10),
      PhishingInfoCard(color: kPhishingGreen, emoji: '⏱️', title: '~20 minutes',
        body: '7 lessons + chat simulation + quiz at the end!'),
      const SizedBox(height: 10),
      PhishingInfoCard(color: kPhishingAccent, emoji: '⭐', title: 'Earn +150 XP',
        body: 'Complete everything to earn your Phishing Detective badge!'),
      const SizedBox(height: 28),
      PhishingCatButton(
        button: PhishingNextButton(onTap: onNext, label: '▶  Start Course'),
        message: PhishingCatMessages.lessonIntro,
      ),
    ]),
  );
}

// ─── Lesson 1: What is Phishing? ─────────────────────────────────────────────
// Tap to reveal the definition card + the fishing analogy rows.
class PhishingLesson1 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson1({super.key, required this.onNext});
  @override
  State<PhishingLesson1> createState() => _PhishingLesson1State();
}

class _PhishingLesson1State extends State<PhishingLesson1> {
  static const int _total = 5; // definition card + 4 analogy rows
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
        const PhishingLessonLabel(label: 'WHAT IS PHISHING?'),
        const SizedBox(height: 16),

        if (_revealed >= 1)
          PhishingDarkCard(child: Column(children: [
            const Text('🎣', style: TextStyle(fontSize: 52)), const SizedBox(height: 10),
            Text('Phishing is when a cybercriminal sends you a fake message pretending to be someone you trust — to trick you into giving away personal information.',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.5)),
          ])).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

        if (_revealed >= 1) ...[
          const SizedBox(height: 16),
          Text('Why is it called "phishing"? 🐟',
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))
            .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 10),
        ],

        if (_revealed >= 2)
          PhishingDarkCard(child: const PhishingSimpleRow(emoji: '🎣', text: 'A fisherman throws bait hoping a fish will bite'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 3) ...[
          const SizedBox(height: 8),
          PhishingDarkCard(child: const PhishingSimpleRow(emoji: '📧', text: 'A phisher sends fake messages hoping YOU will bite'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 8),
          PhishingDarkCard(child: const PhishingSimpleRow(emoji: '🐟', text: 'The fish gets caught — you give away your password'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 5) ...[
          const SizedBox(height: 8),
          PhishingDarkCard(child: const PhishingSimpleRow(emoji: '😨', text: 'The phisher gets into your accounts'))
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext),
          message: _allRevealed ? PhishingCatMessages.lesson1Tip : 'Tap the screen! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 2: Who Do Phishers Pretend to Be? ────────────────────────────────
class PhishingLesson2 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson2({super.key, required this.onNext});
  @override
  State<PhishingLesson2> createState() => _PhishingLesson2State();
}

class _PhishingLesson2State extends State<PhishingLesson2> {
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
        const PhishingLessonLabel(label: 'WHO DO PHISHERS PRETEND TO BE?'),
        const SizedBox(height: 6),
        Text('Phishers disguise themselves as people and organisations you already trust.',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 16),

        if (_revealed >= 1)
          PhishingInfoCard(color: kPhishingAccent, emoji: '🏫', title: 'Your school',
            body: '"Your account needs verifying — click here immediately or it will be deleted."')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 10),
          PhishingInfoCard(color: const Color(0xFFFF8A65), emoji: '🎮', title: 'Game companies',
            body: '"Your Roblox/Minecraft account has been flagged. Log in now to keep your account."')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 10),
          PhishingInfoCard(color: const Color(0xFFBA68C8), emoji: '👦', title: 'Someone you know',
            body: '"Hey it\'s me — I got a new number. Can you send me the code that just came to your phone?"')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 12)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext),
          message: _allRevealed ? PhishingCatMessages.lesson2Tip : 'Tap to reveal each one! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 3: Spotting Fake Messages ────────────────────────────────────────
class PhishingLesson3 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson3({super.key, required this.onNext});
  @override
  State<PhishingLesson3> createState() => _PhishingLesson3State();
}

class _PhishingLesson3State extends State<PhishingLesson3> {
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
        const PhishingLessonLabel(label: 'SPOTTING FAKE MESSAGES'),
        const SizedBox(height: 6),
        Text('Can you tell a real message from a fake one? Let\'s compare.',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 14),

        if (_revealed >= 1)
          PhishingEmailCard(
            from: 'support@sch00l-help.com',
            subject: 'URGENT: Your account will be deleted in 24 hours!',
            body: 'Dear student, your school account has been flagged. Click the link below immediately to avoid losing access forever.',
            isReal: false,
            clue: '"sch00l-help.com" uses zeros instead of "o" — a classic fake address trick.',
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

        if (_revealed >= 2) ...[
          const SizedBox(height: 12),
          PhishingEmailCard(
            from: 'itsupport@westfieldacademy.co.uk',
            subject: 'Scheduled maintenance this weekend',
            body: 'The school portal will be offline Saturday 9am–1pm for updates. No action required from students.',
            isReal: true,
            clue: 'Official domain, no urgency, no links, no request for personal info.',
          ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 10)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext),
          message: _allRevealed ? PhishingCatMessages.lesson3Tip : 'Tap to reveal each email! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 4: Red Flags to Look For ─────────────────────────────────────────
class PhishingLesson4 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson4({super.key, required this.onNext});
  @override
  State<PhishingLesson4> createState() => _PhishingLesson4State();
}

class _PhishingLesson4State extends State<PhishingLesson4> {
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
        const PhishingLessonLabel(label: 'RED FLAGS TO LOOK FOR'),
        const SizedBox(height: 6),
        Text('These warning signs mean a message is probably a scam. 🚩',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 14),

        if (_revealed >= 1)
          PhishingRedFlagCard(flag: '⏰ Extreme urgency',
            detail: '"Act NOW or your account will be deleted!" — real organisations give you time.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 8),
          PhishingRedFlagCard(flag: '✉️ Suspicious sender address',
            detail: 'Look closely — "amaz0n.com" or "sch00l-help.com" are fake. Check the full address.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 8),
          PhishingRedFlagCard(flag: '🔑 Asking for your password',
            detail: 'No real company, school or game will ever ask for your password by email. Ever.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 8),
          PhishingRedFlagCard(flag: '🔗 Unexpected links',
            detail: 'A message with a random link you weren\'t expecting is almost always suspicious.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 10)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext),
          message: _allRevealed ? PhishingCatMessages.lesson4Tip : 'Tap to reveal each red flag! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 5: Suspicious Links ──────────────────────────────────────────────
// Tap to reveal each real vs fake link pair one at a time.
class PhishingLesson5 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson5({super.key, required this.onNext});
  @override
  State<PhishingLesson5> createState() => _PhishingLesson5State();
}

class _PhishingLesson5State extends State<PhishingLesson5> {
  static const int _total = 3; // 3 link pairs
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
        const PhishingLessonLabel(label: 'SUSPICIOUS LINKS'),
        const SizedBox(height: 6),
        Text('A dangerous link can look completely normal. Tap to compare real vs fake:',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 14),

        PhishingDarkCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('⚠️  Real vs Fake Links',
            style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 12),
          if (_revealed == 0)
            Text('Tap the screen to reveal! 👆',
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white24)),
          if (_revealed >= 1) ...[
            PhishingLinkRow(label: '✅', link: 'roblox.com/login', safe: true)
              .animate().fadeIn(duration: 250.ms),
            PhishingLinkRow(label: '❌', link: 'r0blox-free.xyz/login', safe: false)
              .animate().fadeIn(duration: 250.ms),
          ],
          if (_revealed >= 2) ...[
            const SizedBox(height: 8),
            PhishingLinkRow(label: '✅', link: 'minecraft.net/en-us', safe: true)
              .animate().fadeIn(duration: 250.ms),
            PhishingLinkRow(label: '❌', link: 'minecraft-free-items.xyz', safe: false)
              .animate().fadeIn(duration: 250.ms),
          ],
          if (_revealed >= 3) ...[
            const SizedBox(height: 8),
            PhishingLinkRow(label: '✅', link: 'bbc.co.uk/news', safe: true)
              .animate().fadeIn(duration: 250.ms),
            PhishingLinkRow(label: '❌', link: 'bbc.news-alerts.ru/click', safe: false)
              .animate().fadeIn(duration: 250.ms),
          ],
        ])),

        if (_allRevealed) ...[
          const SizedBox(height: 12)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext),
          message: _allRevealed ? PhishingCatMessages.lesson5Tip : 'Tap to reveal each pair! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}

// ─── Lesson 6: How to Check a Link Safely ────────────────────────────────────
// All 4 step cards visible. Tap each one to expand it.
class PhishingLesson6 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson6({super.key, required this.onNext});
  @override
  State<PhishingLesson6> createState() => _PhishingLesson6State();
}

class _PhishingLesson6State extends State<PhishingLesson6> {
  static const _steps = [
    ('🌐', kPhishingAccent,          'Go directly to the website',      'Type the official website address yourself in your browser instead of clicking the link.'),
    ('🔒', kPhishingGreen,           'Check for https://',              'Real websites use "https://" and show a padlock icon. No padlock = not secure.'),
    ('🔍', Color(0xFFBA68C8), 'Look for sneaky spelling tricks', '"r0blox" uses zero instead of "o". "amaz0n" fakes Amazon. Read the full address carefully.'),
    ('🙋', kPhishingAccent,          'Ask a trusted adult',             'If you\'re ever unsure — don\'t click. Show a parent or teacher first.'),
  ];

  final Set<int> _expanded = {};
  final Set<int> _everTapped = {};
  bool get _allTapped => _everTapped.length >= _steps.length;

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
      const PhishingLessonLabel(label: 'HOW TO CHECK A LINK SAFELY'),
      const SizedBox(height: 6),
      Text('Tap each step to learn how to stay safe. 🛡️',
        style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
      const SizedBox(height: 16),

      for (int i = 0; i < _steps.length; i++) ...[
        PhishingTappableStepCard(
          number: '${i + 1}',
          emoji: _steps[i].$1,
          color: _steps[i].$2,
          title: _steps[i].$3,
          body: _steps[i].$4,
          isExpanded: _expanded.contains(i),
          onTap: () => _toggle(i),
        ),
        const SizedBox(height: 10),
      ],

      if (_allTapped) ...[
        const SizedBox(height: 28),
      ],

      PhishingCatButton(
        button: PhishingNextButton(onTap: widget.onNext),
        message: _allTapped ? PhishingCatMessages.lesson6Tip : 'Tap each card to open it! 👆',
        showBubble: true,
        showButton: _allTapped,
      ),
    ]),
  );
}

// ─── Lesson 7: What To Do ────────────────────────────────────────────────────
class PhishingLesson7 extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingLesson7({super.key, required this.onNext});
  @override
  State<PhishingLesson7> createState() => _PhishingLesson7State();
}

class _PhishingLesson7State extends State<PhishingLesson7> {
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
        const PhishingLessonLabel(label: 'WHAT TO DO'),
        const SizedBox(height: 6),
        Text('If you think you\'ve received a phishing message — follow these steps:',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
        const SizedBox(height: 14),

        if (_revealed >= 1)
          PhishingStepCard(number: '1', emoji: '🛑', color: kPhishingRed,
            title: 'STOP — don\'t click anything',
            body: 'Close the message. Don\'t tap any links, download files or reply.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        if (_revealed >= 2) ...[
          const SizedBox(height: 10),
          PhishingStepCard(number: '2', emoji: '🤔', color: kPhishingAccent,
            title: 'Ask yourself: Does this make sense?',
            body: 'Did I expect this? Would my school or game company really send this?')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 3) ...[
          const SizedBox(height: 10),
          PhishingStepCard(number: '3', emoji: '🗣️', color: kPhishingAccent,
            title: 'Tell a trusted adult',
            body: 'Show the message to a parent or teacher. They can help you check if it\'s real.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 4) ...[
          const SizedBox(height: 10),
          PhishingStepCard(number: '4', emoji: '🚫', color: const Color(0xFFBA68C8),
            title: 'Report and delete',
            body: 'Use the "Report" button in your email or app, then delete the message.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
        ],
        if (_revealed >= 5) ...[
          const SizedBox(height: 10),
          PhishingStepCard(number: '5', emoji: '🔒', color: kPhishingGreen,
            title: 'Change your password if needed',
            body: 'If you accidentally entered your details — tell an adult and change your password immediately.')
            .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          const SizedBox(height: 14)
        ],

        const SizedBox(height: 20),
        PhishingCatButton(
          button: PhishingNextButton(onTap: widget.onNext, label: 'Chat Simulation 💬'),
          message: _allRevealed ? PhishingCatMessages.lesson7Tip : 'Tap to reveal each step! 👆',
          showBubble: !_promptShown || _allRevealed,
          showButton: _allRevealed,
        ),
      ]),
    ),
  );
}