import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'password_cat_messages.dart';
import 'password_theme.dart';
import 'password_widgets.dart';

// ─── Intro ────────────────────────────────────────────────────────────────────
class IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const IntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(children: [
        Container(width: 110, height: 110,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [kPasswordAccent, kPasswordBg],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.6), width: 2)),
          child: const Center(child: Text('🔐', style: TextStyle(fontSize: 54))))
          .animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Password Power!', textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 10),
        Text('Learn to create passwords so strong,\neven the sneakiest hackers can\'t crack them! 💪',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
        const SizedBox(height: 24),
        InfoCard(color: kPasswordAccent, emoji: '📖', title: 'What you\'ll learn',
          body: 'Why passwords matter, what makes them weak or strong, and how to build one that\'s really hard to guess!'),
        const SizedBox(height: 10),
        InfoCard(color: kPasswordGreen, emoji: '⏱️', title: '~10 minutes',
          body: '4 quick lessons + build your own password + a quiz at the end!'),
        const SizedBox(height: 10),
        InfoCard(color: kPasswordAccent, emoji: '⭐', title: 'Earn +200 XP',
          body: 'Complete everything to earn your Password Master badge!'),
        const SizedBox(height: 28),
        PasswordCatButton(
          button: PasswordNextButton(onTap: onNext, label: '▶  Start Lesson'),
          message: PasswordCatMessages.lessonIntro,
          accentColor: kPasswordAccent,
        ),
      ]),
    );
  }
}

// ─── Lesson 1: Why Passwords Matter ──────────────────────────────────────────
// Tap anywhere to reveal the house card + 4 scenario cards one by one.
// Cat says "Tap the screen!" once, then hides. Reappears with tip when done.
class LessonStep1 extends StatefulWidget {
  final VoidCallback onNext;
  const LessonStep1({super.key, required this.onNext});
  @override
  State<LessonStep1> createState() => _LessonStep1State();
}

class _LessonStep1State extends State<LessonStep1> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const LessonLabel(label: 'WHY PASSWORDS MATTER'),
          const SizedBox(height: 16),
          if (_revealed >= 1)
            Container(width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kPasswordAccent.withValues(alpha: 0.25))),
              child: Column(children: [
                const Text('🏠', style: TextStyle(fontSize: 52)), const SizedBox(height: 10),
                Text('Think of a password like the key to your house!', textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
              ])).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
          if (_revealed >= 1) ...[
            const SizedBox(height: 20),
            Text('What can happen without a good password?',
              style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))
              .animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 10),
          ],
          if (_revealed >= 2) ...[
            ScenarioCard(emoji: '📧', text: 'Someone reads your private messages', isBad: true)
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 8),
          ],
          if (_revealed >= 3) ...[
            ScenarioCard(emoji: '🎮', text: 'A hacker steals your game progress', isBad: true)
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 8),
          ],
          if (_revealed >= 4) ...[
            ScenarioCard(emoji: '📸', text: 'Strangers see your private photos', isBad: true)
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 8),
          ],
          if (_revealed >= 5) ...[
            ScenarioCard(emoji: '🛡️', text: 'A strong password keeps all of this safe!', isBad: false)
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 28),
          ],
          const SizedBox(height: 20),
          PasswordCatButton(
            button: PasswordNextButton(onTap: widget.onNext),
            message: _allRevealed ? PasswordCatMessages.tip(1) : 'Tap the screen! 👆',
            showBubble: !_promptShown || _allRevealed,
            showButton: _allRevealed,
          ),
        ]),
      ),
    );
  }
}

// ─── Lesson 2: Spot the Weak Passwords ───────────────────────────────────────
// Tap anywhere to reveal each weak password one at a time.
class LessonStep2 extends StatefulWidget {
  final VoidCallback onNext;
  const LessonStep2({super.key, required this.onNext});
  @override
  State<LessonStep2> createState() => _LessonStep2State();
}

class _LessonStep2State extends State<LessonStep2> {
  static const _passwords = [
    ('123456',      'Just numbers in order — way too easy!'),
    ('password',    'The #1 most guessed password of all time!'),
    ('iloveyou',    'Very common phrase — hackers know this one!'),
    ('abc123',      'Short and simple = cracked in seconds!'),
    ('yourname123', 'Using your own name makes it easy to guess!'),
  ];

  int _revealed = 0;
  bool _promptShown = false;
  bool get _allRevealed => _revealed >= _passwords.length;

  void _onTap() {
    if (_allRevealed) return;
    SoundService.playClick();
    setState(() {
      if (!_promptShown) _promptShown = true;
      _revealed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const LessonLabel(label: 'SPOT THE WEAK PASSWORDS'),
          const SizedBox(height: 16),
          Text('These are the ones hackers try FIRST. Never use them!',
            style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.4)),
          const SizedBox(height: 14),
          for (int i = 0; i < _revealed; i++) ...[
            WeakPasswordTile(password: _passwords[i].$1, reason: _passwords[i].$2)
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 20),
          PasswordCatButton(
            button: PasswordNextButton(onTap: widget.onNext),
            message: _allRevealed ? PasswordCatMessages.tip(0) : 'Tap the screen! 👆',
            showBubble: !_promptShown || _allRevealed,
            showButton: _allRevealed,
          ),
        ]),
      ),
    );
  }
}

// ─── Lesson 3: The 4 Rules of a Strong Password ───────────────────────────────
// All 4 rule cards are visible. Tap each one to expand/collapse it.
// Cat tip + Next button appear only once all 4 have been tapped open at least once.
class LessonStep3 extends StatefulWidget {
  final VoidCallback onNext;
  const LessonStep3({super.key, required this.onNext});
  @override
  State<LessonStep3> createState() => _LessonStep3State();
}

class _LessonStep3State extends State<LessonStep3> {
  static const _rules = [
    ('1', '📏', Color(0xFFFFC857), 'Make it LONG',   'At least 12 characters. Longer = much harder to crack!'),
    ('2', '🔀', Color(0xFFBA68C8), 'Mix it UP',      'Use UPPER and lower case letters together, like "SuNsHiNe".'),
    ('3', '🔢', Color(0xFFFFC857), 'Add NUMBERS',    'Throw in some numbers — but not just "123" at the end!'),
    ('4', '✨', Color(0xFF00E676), 'Use SYMBOLS',    r'Characters like ! @ # $ % make it much stronger.'),
  ];

  final Set<int> _expanded = {};
  final Set<int> _everTapped = {}; // never shrinks — used to track completion
  bool get _allExpanded => _everTapped.length >= _rules.length;

  void _toggle(int i) {
    SoundService.playClick();
    setState(() {
      _everTapped.add(i);
      if (_expanded.contains(i)) _expanded.remove(i);
      else _expanded.add(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const LessonLabel(label: 'THE 4 RULES OF A STRONG PASSWORD'),
        const SizedBox(height: 6),
        Text('Tap each rule to reveal it 👇',
          style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
        const SizedBox(height: 16),
        for (int i = 0; i < _rules.length; i++) ...[
          TappableRuleCard(
            number: _rules[i].$1, emoji: _rules[i].$2, color: _rules[i].$3,
            title: _rules[i].$4, body: _rules[i].$5,
            isExpanded: _expanded.contains(i), onTap: () => _toggle(i),
          ),
          const SizedBox(height: 10),
        ],
        if (_allExpanded) ...[
          const SizedBox(height: 8),
          Container(width: double.infinity, padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPasswordGreen.withValues(alpha: 0.4))),
            child: Column(children: [
              Text('✅  Strong Password Example',
                style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: kPasswordGreen)),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: kPasswordBg, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPasswordGreen.withValues(alpha: 0.2))),
                child: Text('Tr0pic@lFish!8529',
                  style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1))),
              const SizedBox(height: 10),
              Wrap(spacing: 6, children: [
                PasswordTag(label: 'Long', color: kPasswordAccent),
                PasswordTag(label: 'Mixed case', color: const Color(0xFFBA68C8)),
                PasswordTag(label: 'Numbers', color: kPasswordAccent),
                PasswordTag(label: 'Symbols', color: kPasswordGreen),
              ]),
            ])).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0),
          const SizedBox(height: 28),
        ],
        PasswordCatButton(
          button: PasswordNextButton(onTap: widget.onNext),
          message: _allExpanded ? PasswordCatMessages.tip(2) : 'Tap each card to reveal the rule! 👆',
          showBubble: true,
          showButton: _allExpanded,
        ),
      ]),
    );
  }
}

// ─── Lesson 4: The Passphrase Trick ──────────────────────────────────────────
// Tap anywhere to reveal each step one at a time (5 steps total).
class LessonStep4 extends StatefulWidget {
  final VoidCallback onNext;
  const LessonStep4({super.key, required this.onNext});
  @override
  State<LessonStep4> createState() => _LessonStep4State();
}

class _LessonStep4State extends State<LessonStep4> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const LessonLabel(label: 'THE PASSPHRASE TRICK'),
          const SizedBox(height: 6),
          Text('Hard to guess, but easy for YOU to remember!',
            style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
          const SizedBox(height: 16),

          if (_revealed >= 1)
            Container(width: double.infinity, padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kPasswordAccent.withValues(alpha: 0.25))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🤔  What is a passphrase?',
                  style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: kPasswordAccent)),
                const SizedBox(height: 8),
                Text('Instead of a scrambled word, you combine 3 or more RANDOM words you like. They don\'t have to make sense — that\'s the point!',
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.5)),
              ])).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),

          if (_revealed >= 2) ...[
            const SizedBox(height: 14),
            Container(padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kPasswordAccent.withValues(alpha: 0.25))),
              child: Column(children: [
                Text('Step 1 — Pick 3 random words you like:',
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54)),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const WordBubble(word: 'Fluffy', emoji: '🐱'),
                  Text(' + ', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white54)),
                  const WordBubble(word: 'Pizza', emoji: '🍕'),
                  Text(' + ', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white54)),
                  const WordBubble(word: 'Rocket', emoji: '🚀'),
                ]),
              ])).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          ],

          if (_revealed >= 3) ...[
            const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFBA68C8).withValues(alpha: 0.4))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Step 2 — Add numbers & symbols between them:',
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54)),
                const SizedBox(height: 12),
                const Center(child: Icon(Icons.arrow_downward_rounded, color: kPasswordAccent, size: 24)),
                const SizedBox(height: 10),
                Center(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: kPasswordGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPasswordGreen.withValues(alpha: 0.3))),
                  child: Text(r'Fluffy$Pizza!Rocket7',
                    style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: kPasswordGreen, letterSpacing: 0.5)))),
                const SizedBox(height: 8),
                Center(child: Text('The \$ and ! separate the words — easy to remember!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38))),
              ])).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          ],

          if (_revealed >= 4) ...[
            const SizedBox(height: 10),
            InfoCard(color: kPasswordGreen, emoji: '✅', title: 'Why it works',
              body: 'A funny image in your head — a fluffy cat eating pizza on a rocket! Easy for you, impossible for hackers.')
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 8),
            InfoCard(color: kPasswordAccent, emoji: '🔐', title: 'Super long & super strong',
              body: 'More characters = exponentially harder to crack. A passphrase is usually 20+ characters.')
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
          ],

          if (_revealed >= 5) ...[
            const SizedBox(height: 8),
            InfoCard(color: const Color(0xFFBA68C8), emoji: '🤫', title: 'Your secret',
              body: 'Nobody else would pick the same 3 random words as you — it\'s uniquely yours!')
              .animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
            const SizedBox(height: 28),
          ],

          const SizedBox(height: 20),
          PasswordCatButton(
            button: PasswordNextButton(onTap: widget.onNext, label: 'Build Your Own! 🛠️'),
            message: _allRevealed ? PasswordCatMessages.tip(3) : 'Tap to reveal each step! 👆',
            showBubble: !_promptShown || _allRevealed,
            showButton: _allRevealed,
          ),
        ]),
      ),
    );
  }
}