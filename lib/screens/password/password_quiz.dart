import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/difficulty_level.dart';
import '../../services/sound_service.dart';
import 'password_theme.dart';
import 'password_widgets.dart';

class QuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  final DifficultyLevel difficulty;
  const QuizStep({super.key, required this.onComplete, this.difficulty = DifficultyLevel.easy});
  @override
  State<QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<QuizStep> {
  int questionIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  int _score = 0;
  late final List<Map<String, dynamic>> _questions;

  static const List<Map<String, dynamic>> _easyQuestions = [
    {'question': 'Which of these is the STRONGEST password?', 'emoji': '🤔',
      'options': ['fluffy123', 'password', 'Tr0pic@lFish!2024', '12345678'], 'correct': 2,
      'explanation': 'A strong password mixes uppercase, lowercase, numbers AND symbols. "Tr0pic@lFish!2024" has all of these and is long enough to be very hard to crack!'},
    {'question': 'What is the MINIMUM length a strong password should be?', 'emoji': '📏',
      'options': ['4 characters', '8 characters', '12 characters', '6 characters'], 'correct': 2,
      'explanation': 'A password should be at least 12 characters long. Longer passwords take much longer to crack — every extra character makes it exponentially harder for hackers!'},
    {'question': 'Why is "yourname123" a weak password?', 'emoji': '🤨',
      'options': ['It\'s too long', 'It uses your name — easy to guess!', 'It has numbers', 'It\'s hard to remember'], 'correct': 1,
      'explanation': 'Hackers always try names first because people use them so often. Never use your own name, pet\'s name, or birthday in a password — they\'re the first things guessed!'},
    {'question': 'Which symbol makes your password stronger?', 'emoji': '✨',
      'options': ['A space', '@ or ! or #', 'Only letters', 'A smiley face'], 'correct': 1,
      'explanation': 'Special symbols like @, !, # and \$ make passwords much harder to crack. Adding even one symbol dramatically increases the number of possible combinations!'},
    {'question': 'A passphrase uses... ?', 'emoji': '🧠',
      'options': ['One short word', 'Your birthday', 'Random words joined together', 'Just numbers'], 'correct': 2,
      'explanation': 'A passphrase joins random words together — like "PurpleTurtle!BounceCloud" — making something long, strong, AND easy to remember. Much better than a short random password!'},
  ];

  static const List<Map<String, dynamic>> _mediumQuestions = [
    {'question': 'You use the same strong password for 5 different accounts. Why is this still a problem?', 'emoji': '🔁',
      'options': ['It is not a problem — a strong password works everywhere', 'If one site is hacked, attackers can try your password on all your other accounts', 'It is harder to remember the same password repeatedly', 'Strong passwords expire faster when reused'],
      'correct': 1,
      'explanation': 'This is called "credential stuffing" — hackers take leaked passwords and try them on other sites. Even a perfect password fails if the same one unlocks everything. Use unique passwords for each account!'},
    {'question': 'Which password would be hardest for a hacker to crack?', 'emoji': '🏆',
      'options': ['P@ssw0rd2024', 'PurpleElephantBouncingCloud!', 'Tr0pic@l', '12345678!'],
      'correct': 1,
      'explanation': '"PurpleElephantBouncingCloud!" is 27 characters long with no predictable pattern. Length beats complexity — "P@ssw0rd" substitutions are so common that attackers specifically check for them!'},
    {'question': 'You need to remember a strong password for school without writing it down. Which is safest?', 'emoji': '🧠',
      'options': ['Use your name and birthday so it\'s memorable', 'Create a passphrase from a silly sentence only you would think of', 'Use a shorter simpler password so you remember it easily', 'Write it on a sticky note under your keyboard'],
      'correct': 1,
      'explanation': 'A silly personal sentence ("MyDogHates3Mondays!") is both memorable AND strong. Birthdays and names are guessable, and a note under the keyboard is the first place people look!'},
    {'question': 'A website says your 15-character password isn\'t strong enough. Why might this be?', 'emoji': '⚠️',
      'options': ['Websites are always wrong about password strength', 'It might only use one type of character — like all lowercase — making it easier to crack despite the length', '15 characters is always weak', 'The website has a bug'],
      'correct': 1,
      'explanation': '"aaaaaaaaaaaaaaa" is 15 characters but trivial to crack. Length AND variety matter — mixing uppercase, lowercase, numbers and symbols makes a password exponentially stronger.'},
    {'question': 'Is using a password manager to store all your passwords a good idea?', 'emoji': '🔐',
      'options': ['No — if someone hacks the manager they get everything', 'Yes — it lets you use strong unique passwords everywhere without memorising them all', 'No — password managers are always expensive', 'Yes — it means you only ever need one password'],
      'correct': 1,
      'explanation': 'A trusted password manager is one of the best security tools available. The risk of a hacker cracking the manager is much lower than the near-certainty of weak or reused passwords being cracked.'},
  ];

  static const List<Map<String, dynamic>> _hardQuestions = [
    {'question': 'A hacker uses a "dictionary attack" — trying every word and common substitution. Which password is MOST resistant?', 'emoji': '📖',
      'options': ['Tr0ub4dor&3 (letter-number substitutions)', 'FluffyCloud!Sunrise (unpredictable real words)', 'P@ssw0rd2024 (common word + numbers)', 'qwerty123! (keyboard pattern)'],
      'correct': 1,
      'explanation': '"FluffyCloud!Sunrise" wins — it is long, uses real words in an unpredictable combination, and has a symbol. Letter substitutions like "0 for o" are now standard in dictionary attacks, making "Tr0ub4dor" weaker than it seems.'},
    {'question': 'Your school forces you to change your password every 30 days. Why can this actually make things LESS secure?', 'emoji': '📅',
      'options': ['Changing passwords always makes them weaker', 'Frequent forced changes lead to predictable patterns like "Password1, Password2" or writing passwords down', 'Passwords get deleted after 30 days', 'The school gets to see the new password'],
      'correct': 1,
      'explanation': 'Forced frequent changes cause "password fatigue" — people start using predictable patterns or writing passwords down, which is far more dangerous. Experts now recommend changing only when a breach is suspected.'},
    {'question': 'Two-factor authentication (2FA) sends a code to your phone. Which scenario is STILL vulnerable?', 'emoji': '📲',
      'options': ['Someone knows your password but not your phone number', 'A fake login page captures your password AND 2FA code simultaneously and uses them in real time', 'Someone borrows your phone briefly', 'The 2FA code expires after 30 seconds'],
      'correct': 1,
      'explanation': 'Real-time phishing attacks capture your 2FA code the moment you enter it and use it instantly on the real site. 2FA is still important, but it\'s not invincible against sophisticated attacks.'},
    {'question': 'Which password is actually STRONGEST at 12 characters?', 'emoji': '💪',
      'options': ['Password1234 (common word + numbers)', 'xK7#mP2@nQ9! (random mix of all character types)', 'ilovemycat12 (phrase + numbers)', 'QWERTYUIOP12 (keyboard row + numbers)'],
      'correct': 1,
      'explanation': '"xK7#mP2@nQ9!" uses all four character types with no recognisable pattern — maximising the number of combinations a hacker would need to try.'},
    {'question': 'A website stores your password as plain text instead of encrypted. You use a unique strong password there. What is the risk?', 'emoji': '🗄️',
      'options': ['No risk — your password is strong', 'If their database is hacked, your exact password is exposed and attackers can try it on other sites immediately', 'Your password might be deleted', 'The website might charge you more'],
      'correct': 1,
      'explanation': 'Even perfect passwords can be exposed if a website stores them insecurely. This is exactly why using unique passwords per site matters — even if one site leaks your password, your other accounts remain safe.'},
  ];

  @override
  void initState() {
    super.initState();
    _questions = _getQuestions();
  }

  List<Map<String, dynamic>> _getQuestions() {
    switch (widget.difficulty) {
      case DifficultyLevel.easy:   return _easyQuestions;
      case DifficultyLevel.medium: return _mediumQuestions;
      case DifficultyLevel.hard:   return _hardQuestions;
    }
  }

  void selectAnswer(int index) {
    if (answered) return;
    final int correct = _questions[questionIndex]['correct'] as int;
    if (index == correct) {
      SoundService.playCatHappy();
    } else {
      SoundService.playCatIncorrect();
    }
    setState(() { selectedAnswer = index; answered = true; if (index == correct) _score++; });
  }

  void nextQuestion() {
    SoundService.playClick();
    if (questionIndex < _questions.length - 1) {
      setState(() { questionIndex++; selectedAnswer = null; answered = false; });
    } else {
      widget.onComplete(_score, _questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[questionIndex];
    final List<String> options = List<String>.from(q['options'] as List);
    final int correct = q['correct'] as int;

    return Stack(
      children: [
      SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quiz Time! 🎯',
            style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: kPasswordGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPasswordGreen.withValues(alpha: 0.4))),
            child: Text('${questionIndex + 1} / ${_questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kPasswordGreen, fontSize: 13))),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.difficulty.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.difficulty.color.withValues(alpha: 0.4)),
            ),
            child: Text('${widget.difficulty.emoji} ${widget.difficulty.label} Mode',
              style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w600,
                color: widget.difficulty.color)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (questionIndex + 1) / _questions.length, minHeight: 6,
            backgroundColor: kPasswordAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(kPasswordAccent))),
        const SizedBox(height: 20),

        // Question card
        Container(width: double.infinity, padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.2))),
          child: Column(children: [
            Text(q['emoji'] as String, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(q['question'] as String, textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ])),
        const SizedBox(height: 16),

        // Answer options
        ...options.asMap().entries.map((entry) {
          final i = entry.key;
          final opt = entry.value;
          final bool isCorrect  = i == correct;
          final bool isSelected = i == selectedAnswer;
          Color borderColor = kPasswordAccent.withValues(alpha: 0.15);
          Color bgColor    = kPasswordCard;
          Color textColor  = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorrect) {
              bgColor = kPasswordGreen.withValues(alpha: 0.12);
              borderColor = kPasswordGreen.withValues(alpha: 0.6);
              textColor = kPasswordGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: kPasswordGreen, size: 20);
            } else if (isSelected) {
              bgColor = kPasswordRed.withValues(alpha: 0.12);
              borderColor = kPasswordRed.withValues(alpha: 0.6);
              textColor = kPasswordRed;
              trailing = const Icon(Icons.cancel_rounded, color: kPasswordRed, size: 20);
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => selectAnswer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5)),
                child: Row(children: [
                  Container(width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: answered && isCorrect
                        ? kPasswordGreen.withValues(alpha: 0.2)
                        : kPasswordAccent.withValues(alpha: 0.08),
                      border: Border.all(color: answered && isCorrect
                        ? kPasswordGreen : kPasswordAccent.withValues(alpha: 0.3))),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13,
                        color: answered && isCorrect ? kPasswordGreen : kPasswordAccent.withValues(alpha: 0.7))))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt, style: GoogleFonts.fredoka(
                    fontSize: 14, fontWeight: FontWeight.w600, color: textColor))),
                  if (trailing != null) trailing,
                ]),
              ),
            ),
          );
        }),

        if (answered) const SizedBox(height: 200),
      ]),
    ),
      if (answered) ...[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.black.withValues(alpha: 0.25)),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: PasswordCatButton(
            button: PasswordNextButton(
              onTap: nextQuestion,
              label: questionIndex < _questions.length - 1 ? 'Next Question →' : 'See Results! 🏆',
            ),
            message: '${selectedAnswer == correct ? "Purrfect! ✅" : "Not quite! 😿"} ${q['explanation'] as String}',
            accentColor: selectedAnswer == correct ? kPasswordGreen : kPasswordRed,
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),
        ),
      ],
    ],
    );
  }
}
