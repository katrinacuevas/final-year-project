import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../widgets/xp_award.dart';
import '../widgets/password_cat_messages.dart';
import '../services/sound_service.dart';

const Color _kAccent = Color(0xFFFFC857);
const Color _kBg = Color(0xFF0D1117);
const Color _kCard = Color(0xFF161B2E);
const Color _kGreen = Color(0xFF00E676);
const Color _kRed = Color(0xFFFF5252);

class PasswordPowerScreen extends StatefulWidget {
  const PasswordPowerScreen({super.key});

  @override
  State<PasswordPowerScreen> createState() => _PasswordPowerScreenState();
}

class _PasswordPowerScreenState extends State<PasswordPowerScreen> {
  int currentStep = 0;
  static const int totalSteps = 6;
  int _quizScore = 0;
  int _quizTotal = 0;

  void goNext() => setState(() => currentStep++);

  void goBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = currentStep >= 1 && currentStep <= totalSteps;
    final bool isComplete = currentStep == totalSteps + 1;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      if (!isComplete)
                        GestureDetector(
                          onTap: () {
                            SoundService.playClick();
                            goBack();
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _kCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: _kAccent.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.arrow_back_rounded,
                                color: _kAccent, size: 20),
                          ),
                        ).animate().scale(),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _kAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _kAccent.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔐',
                                style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                              showProgress
                                  ? 'LESSON $currentStep OF $totalSteps'
                                  : 'PASSWORD POWER',
                              style: GoogleFonts.fredoka(
                                color: _kAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showProgress)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: _LessonProgressBar(
                        current: currentStep, total: totalSteps),
                  ),
                const SizedBox(height: 4),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.08, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: animation, curve: Curves.easeOutCubic)),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: _buildStep(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _IntroStep(key: const ValueKey(0), onNext: goNext);
      case 1:
        return _LessonStep1(key: const ValueKey(1), onNext: goNext);
      case 2:
        return _LessonStep2(key: const ValueKey(2), onNext: goNext);
      case 3:
        return _LessonStep3(key: const ValueKey(3), onNext: goNext);
      case 4:
        return _LessonStep4(key: const ValueKey(4), onNext: goNext);
      case 5:
        return _QuizStep(key: const ValueKey(5), onComplete: (s,t) { setState(() { _quizScore = s; _quizTotal = t; currentStep++; }); });
      case 6:
        return _BuildPasswordStep(
          key: const ValueKey(6),
          onComplete: () async {
            await UserService.instance.saveProgress(
              const LessonProgress(
                lessonId: 'password_power',
                stepsCompleted: 6,
                totalSteps: 6,
                stars: 3,
                completed: true,
              ),
            );
            if (mounted) setState(() => currentStep = 7);
          },
        );
      case 7:
        return _CompleteStep(
          key: const ValueKey(7),
          score: _quizScore,
          total: _quizTotal,
          onRetry: () => setState(() => currentStep = 5),
          onDone: () => Navigator.pop(context),
        );
      default:
        return const SizedBox();
    }
  }
}

// ─── Intro ──────────────────────────────────────────────────────────────────

class _IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [_kAccent, _kBg],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: _kAccent.withValues(alpha: 0.6), width: 2),
            ),
            child: const Center(
              child: Text('🔐', style: TextStyle(fontSize: 54)),
            ),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text('Password Power!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(
            'Learn to create passwords so strong,\neven the sneakiest hackers can\'t crack them! 💪',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
                fontSize: 15, color: Colors.white54, height: 1.5),
          ),
          const SizedBox(height: 16),
          _CatTipBox(message: PasswordCatMessages.lessonIntro, accentColor: _kAccent),
          const SizedBox(height: 24),
          _InfoCard(
            color: _kAccent,
            emoji: '📖',
            title: 'What you\'ll learn',
            body: 'Why passwords matter, what makes them weak or strong, and how to build one that\'s really hard to guess!',
          ),
          const SizedBox(height: 10),
          _InfoCard(
            color: _kGreen,
            emoji: '⏱️',
            title: '~10 minutes',
            body: '4 quick lessons + a quiz + build your very own password at the end!',
          ),
          const SizedBox(height: 10),
          _InfoCard(
            color: _kAccent,
            emoji: '⭐',
            title: 'Earn +200 XP',
            body: 'Complete everything to earn your Password Master badge!',
          ),
          const SizedBox(height: 28),
          _NextButton(onTap: onNext, label: '▶  Start Lesson'),
        ],
      ),
    );
  }
}

// ─── Lesson 1 — Why passwords matter ────────────────────────────────────────

class _LessonStep1 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LessonLabel(label: 'WHY PASSWORDS MATTER'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.25)),
            ),
            child: Column(children: [
              const Text('🏠', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 10),
              Text(
                'Think of a password like the key to your house!',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Text('What can happen without a good password?',
              style: GoogleFonts.fredoka(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 10),
          _ScenarioCard(emoji: '📧', text: 'Someone reads your private messages', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '🎮', text: 'A hacker steals your game progress', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '📸', text: 'Strangers see your private photos', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '🛡️', text: 'A strong password keeps all of this safe!', isBad: false),
          const SizedBox(height: 28),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

// ─── Lesson 2 — Weak passwords ───────────────────────────────────────────────

class _LessonStep2 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LessonLabel(label: 'SPOT THE WEAK PASSWORDS'),
          const SizedBox(height: 16),
          Text('These are the ones hackers try FIRST. Never use them!',
              style: GoogleFonts.fredoka(
                  fontSize: 14, color: Colors.white54, height: 1.4)),
          const SizedBox(height: 14),
          _WeakPasswordTile(password: '123456', reason: 'Just numbers in order — way too easy!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'password', reason: 'The #1 most guessed password of all time!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'iloveyou', reason: 'Very common phrase — hackers know this one!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'abc123', reason: 'Short and simple = cracked in seconds!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'yourname123', reason: 'Using your own name makes it easy to guess!'),
          const SizedBox(height: 16),
          _CatTipBox(message: PasswordCatMessages.tips[0]),
          const SizedBox(height: 28),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

// ─── Lesson 3 — Strong password rules ────────────────────────────────────────

class _LessonStep3 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LessonLabel(label: 'THE 4 RULES OF A STRONG PASSWORD'),
          const SizedBox(height: 16),
          _RuleCard(number: '1', emoji: '📏', color: _kAccent, title: 'Make it LONG',
              body: 'At least 12 characters. Longer = much harder to crack!'),
          const SizedBox(height: 10),
          _RuleCard(number: '2', emoji: '🔀', color: const Color(0xFFBA68C8), title: 'Mix it UP',
              body: 'Use UPPER and lower case letters together, like "SuNsHiNe".'),
          const SizedBox(height: 10),
          _RuleCard(number: '3', emoji: '🔢', color: _kAccent, title: 'Add NUMBERS',
              body: 'Throw in some numbers — but not just "123" at the end!'),
          const SizedBox(height: 10),
          _RuleCard(number: '4', emoji: '✨', color: _kGreen, title: 'Use SYMBOLS',
              body: 'Characters like ! @ # \$ % make it much stronger.'),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kGreen.withValues(alpha: 0.4)),
            ),
            child: Column(children: [
              Text('✅  Strong Password Example',
                  style: GoogleFonts.fredoka(
                      fontSize: 13, fontWeight: FontWeight.w600, color: _kGreen)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kGreen.withValues(alpha: 0.2)),
                ),
                child: Text('Tr0pic@lFish!2024',
                    style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  _Tag(label: 'Long', color: _kAccent),
                  _Tag(label: 'Mixed case', color: const Color(0xFFBA68C8)),
                  _Tag(label: 'Numbers', color: _kAccent),
                  _Tag(label: 'Symbols', color: _kGreen),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 28),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

// ─── Lesson 4 — Passphrase trick ─────────────────────────────────────────────

class _LessonStep4 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep4({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LessonLabel(label: 'THE PASSPHRASE TRICK'),
          const SizedBox(height: 6),
          Text('Hard to guess, but easy for YOU to remember!',
              style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.25)),
            ),
            child: Column(children: [
              Text('Pick 3 random words you like:',
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white54)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _WordBubble(word: 'Fluffy', emoji: '🐱'),
                  Text(' + ',
                      style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white54)),
                  _WordBubble(word: 'Pizza', emoji: '🍕'),
                  Text(' + ',
                      style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white54)),
                  _WordBubble(word: 'Rocket', emoji: '🚀'),
                ],
              ),
              const SizedBox(height: 14),
              const Icon(Icons.arrow_downward_rounded, color: _kAccent, size: 24),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _kGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kGreen.withValues(alpha: 0.3)),
                ),
                child: Text('Fluffy\$Pizza!Rocket7',
                    style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _kGreen,
                        letterSpacing: 0.5)),
              ),
              const SizedBox(height: 8),
              Text('Add numbers & symbols between the words ✨',
                  style: GoogleFonts.fredoka(
                      fontSize: 12, color: Colors.white38)),
            ]),
          ),
          const SizedBox(height: 16),
          _InfoCard(color: _kGreen, emoji: '✅', title: 'Easy to remember',
              body: 'A funny image in your head — a fluffy cat eating pizza on a rocket!'),
          const SizedBox(height: 8),
          _InfoCard(color: _kAccent, emoji: '🔐', title: 'Very long',
              body: 'More characters = exponentially harder to crack.'),
          const SizedBox(height: 8),
          _InfoCard(color: _kAccent, emoji: '🤫', title: 'Your secret',
              body: 'Nobody else would pick the same 3 random words as you!'),
          const SizedBox(height: 28),
          _NextButton(onTap: onNext, label: 'Take the Quiz! 🎯'),
        ],
      ),
    );
  }
}

// ─── Quiz ────────────────────────────────────────────────────────────────────

class _QuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const _QuizStep({super.key, required this.onComplete});

  @override
  State<_QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<_QuizStep> {
  int questionIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  int _score = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which of these is the STRONGEST password?',
      'emoji': '🤔',
      'options': ['fluffy123', 'password', 'Tr0pic@lFish!2024', '12345678'],
      'correct': 2,
      'explanation': 'Tr0pic@lFish!2024 is long, has mixed case, numbers AND symbols — all 4 rules!',
    },
    {
      'question': 'What is the MINIMUM length a strong password should be?',
      'emoji': '📏',
      'options': ['4 characters', '8 characters', '12 characters', '6 characters'],
      'correct': 2,
      'explanation': 'At least 12 characters! The longer the better.',
    },
    {
      'question': 'Why is "yourname123" a weak password?',
      'emoji': '🤨',
      'options': ['It\'s too long', 'It uses your name — easy to guess!', 'It has numbers', 'It\'s hard to remember'],
      'correct': 1,
      'explanation': 'Using your own name makes it very easy for people who know you to guess it!',
    },
    {
      'question': 'Which symbol makes your password stronger?',
      'emoji': '✨',
      'options': ['A space', '@ or ! or #', 'Only letters', 'A smiley face'],
      'correct': 1,
      'explanation': 'Special symbols like @ ! # \$ make passwords much harder to crack!',
    },
    {
      'question': 'A passphrase uses... ?',
      'emoji': '🧠',
      'options': ['One short word', 'Your birthday', 'Random words joined together', 'Just numbers'],
      'correct': 2,
      'explanation': 'Combining random words like Fluffy+Pizza+Rocket makes a memorable but super strong password!',
    },
  ];

  void selectAnswer(int index) {
    if (answered) return;
    SoundService.playClick();
    final int correct = questions[questionIndex]['correct'] as int;
    setState(() {
      selectedAnswer = index;
      answered = true;
      if (index == correct) _score++;
    });
  }

  void nextQuestion() {
    SoundService.playClick();
    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      widget.onComplete(_score, questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[questionIndex];
    final List<String> options = List<String>.from(q['options'] as List);
    final int correct = q['correct'] as int;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quiz Time! 🎯',
                  style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _kGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kGreen.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${questionIndex + 1} / ${questions.length}',
                  style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.w700,
                      color: _kGreen,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (questionIndex + 1) / questions.length,
              minHeight: 6,
              backgroundColor: _kAccent.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(_kAccent),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
            ),
            child: Column(children: [
              Text(q['emoji'] as String, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 12),
              Text(q['question'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
          ),
          const SizedBox(height: 16),
          ...options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final bool isCorrect = i == correct;
            final bool isSelected = i == selectedAnswer;

            Color borderColor = _kAccent.withValues(alpha: 0.15);
            Color bgColor = _kCard;
            Color textColor = Colors.white70;
            Widget? trailing;

            if (answered) {
              if (isCorrect) {
                bgColor = _kGreen.withValues(alpha: 0.12);
                borderColor = _kGreen.withValues(alpha: 0.6);
                textColor = _kGreen;
                trailing = const Icon(Icons.check_circle_rounded, color: _kGreen, size: 20);
              } else if (isSelected) {
                bgColor = _kRed.withValues(alpha: 0.12);
                borderColor = _kRed.withValues(alpha: 0.6);
                textColor = _kRed;
                trailing = const Icon(Icons.cancel_rounded, color: _kRed, size: 20);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => selectAnswer(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: answered && isCorrect
                            ? _kGreen.withValues(alpha: 0.2)
                            : _kAccent.withValues(alpha: 0.08),
                        border: Border.all(
                          color: answered && isCorrect
                              ? _kGreen
                              : _kAccent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          ['A', 'B', 'C', 'D'][i],
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: answered && isCorrect
                                ? _kGreen
                                : _kAccent.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(opt,
                          style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor)),
                    ),
                    ?trailing,
                  ]),
                ),
              ),
            );
          }),
          if (answered) ...[
            const SizedBox(height: 4),
            _CatTipBox(
              message: PasswordCatMessages.quizFeedback(
                questionIndex,
                selectedAnswer == correct,
              ),
              accentColor: selectedAnswer == correct ? _kGreen : _kRed,
            ),
            const SizedBox(height: 16),
            _NextButton(
              onTap: nextQuestion,
              label: questionIndex < questions.length - 1
                  ? 'Next Question →'
                  : 'Build Your Own! 🛠️',
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Build Password ───────────────────────────────────────────────────────────

class _BuildPasswordStep extends StatefulWidget {
  final VoidCallback onComplete;
  const _BuildPasswordStep({super.key, required this.onComplete});

  @override
  State<_BuildPasswordStep> createState() => _BuildPasswordStepState();
}

class _BuildPasswordStepState extends State<_BuildPasswordStep> {
  final TextEditingController controller = TextEditingController();
  bool obscure = true;

  bool get hasLength => controller.text.length >= 12;
  bool get hasUpper => controller.text.contains(RegExp(r'[A-Z]'));
  bool get hasLower => controller.text.contains(RegExp(r'[a-z]'));
  bool get hasNumber => controller.text.contains(RegExp(r'[0-9]'));
  bool get hasSymbol => controller.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;~/`]'));

  int get score => [hasLength, hasUpper, hasLower, hasNumber, hasSymbol].where((b) => b).length;
  bool get canProceed => score >= 5;

  String get strengthLabel {
    if (controller.text.isEmpty) return 'Start typing...';
    if (score <= 1) return 'Very Weak 😬';
    if (score == 2) return 'Weak 😕';
    if (score == 3) return 'Getting Better 🙂';
    if (score == 4) return 'Strong 💪';
    return 'Super Strong! 🔥';
  }

  Color get strengthColor {
    if (controller.text.isEmpty) return Colors.white12;
    if (score <= 1) return _kRed;
    if (score == 2) return const Color(0xFFFF8A65);
    if (score == 3) return _kAccent;
    if (score == 4) return _kGreen;
    return _kGreen;
  }

  String get _buildCatMessage {
    if (!hasLength) return PasswordCatMessages.buildHints['length']!;
    if (!hasUpper)  return PasswordCatMessages.buildHints['upper']!;
    if (!hasLower)  return PasswordCatMessages.buildHints['lower']!;
    if (!hasNumber) return PasswordCatMessages.buildHints['number']!;
    if (!hasSymbol) return PasswordCatMessages.buildHints['symbol']!;
    return PasswordCatMessages.buildHints['strong']!;
  }

  String get hint {
    if (!hasLength) return 'Too short — aim for at least 12 characters. Try adding more words!';
    if (!hasUpper) return 'Add some UPPERCASE letters — try capitalising the start of each word.';
    if (!hasLower) return 'Add some lowercase letters — mix them with your capitals.';
    if (!hasNumber) return 'Throw in a number or two — like replacing "o" with "0".';
    if (!hasSymbol) return 'Nearly there! Add a symbol like ! @ # or \$ to make it super strong.';
    return "Keep going — you're almost there!";
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LessonLabel(label: 'BUILD YOUR OWN PASSWORD'),
          const SizedBox(height: 6),
          Text(
            'Use everything you\'ve learned! It needs to pass at least 4 rules.',
            style: GoogleFonts.fredoka(
                fontSize: 14, color: Colors.white54, height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type your password:',
                    style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54)),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  onChanged: (v) => setState(() {}),
                  style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g. Fluffy\$Pizza!Rocket7',
                    hintStyle: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: Colors.white24,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0),
                    filled: true,
                    fillColor: _kBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: _kAccent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: Colors.white38),
                      onPressed: () =>
                          setState(() => obscure = !obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Strength:',
                        style: GoogleFonts.fredoka(
                            fontSize: 12, color: Colors.white38)),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: strengthColor),
                      child: Text(strengthLabel),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: controller.text.isEmpty ? 0 : score / 5,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(strengthColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _kAccent.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rules checklist:',
                    style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54)),
                const SizedBox(height: 12),
                _CheckRow(label: 'At least 12 characters long', passed: hasLength),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has UPPERCASE letters', passed: hasUpper),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has lowercase letters', passed: hasLower),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has numbers (0–9)', passed: hasNumber),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has symbols (! @ # \$ % etc.)', passed: hasSymbol),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (!canProceed && controller.text.isNotEmpty)
            _CatTipBox(message: _buildCatMessage, accentColor: strengthColor),
          if (canProceed)
            _CatTipBox(
              message: PasswordCatMessages.buildHints['strong']!,
              accentColor: _kGreen,
            ),
          const SizedBox(height: 20),
          _NextButton(
            onTap: widget.onComplete,
            enabled: canProceed,
            label: 'Finish! 🏆',
          ),
          if (!canProceed)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text('Complete at least 4 rules to finish',
                    style: GoogleFonts.fredoka(
                        fontSize: 12, color: Colors.white24)),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Complete ─────────────────────────────────────────────────────────────────

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

  String get _encouragement {
    final pct = widget.total == 0 ? 0.0 : widget.score / widget.total;
    if (pct >= 0.6) return "So close! Just a couple more to go — you've got this!";
    if (pct >= 0.4) return "Good start! Review the lessons and give it another shot.";
    return "Don't worry — each attempt makes you smarter and safer online!";
  }

    Future<void> finish(BuildContext ctx) async {
    if (claiming) return;
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'password_power', stepsCompleted: 6, totalSteps: 6,
        stars: _stars, completed: true));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'password_power', amount: 200);
      widget.onDone();
    } catch (e) { debugPrint('Error: $e'); widget.onDone(); }
  }

  @override
  Widget build(BuildContext context) {
    if (_stars < 3) {
      // ── Retry view ────────────────────────────────────────────────────────
      final int missed = widget.total - widget.score;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(children: [
          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: _kCard,
              border: Border.all(color: _kRed.withValues(alpha: 0.4), width: 2),
            ),
            child: const Center(child: Text('📖', style: TextStyle(fontSize: 54))),
          ).animate().scale(curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text('Not quite there yet!',
            style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          _CatTipBox(message: _encouragement, accentColor: _kRed),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kCard, borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withValues(alpha: 0.15)),
            ),
            child: Row(children: [
              Expanded(child: Column(children: [
                Text('${widget.score}',
                  style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: _kGreen)),
                Text('correct', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
              ])),
              Container(width: 1, height: 44, color: Colors.white12),
              Expanded(child: Column(children: [
                Text('$missed',
                  style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: _kRed)),
                Text('to review', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
              ])),
              Container(width: 1, height: 44, color: Colors.white12),
              Expanded(child: Column(children: [
                Text('${widget.total}',
                  style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white54)),
                Text('total', style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white38)),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          _CatTipBox(
            message: 'You need to get every question right to complete the lesson and earn your XP.',
            accentColor: _kRed,
          ),
          const SizedBox(height: 28),
          _NextButton(onTap: widget.onRetry, label: '🔄  Try Again'),
        ]),
      );
    }

    // ── Success view ────────────────────────────────────────────────────────
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(children: [
        Container(
          width: 110, height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), _kBg],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            border: Border.all(color: Color(0xFFFFD700).withValues(alpha: 0.6), width: 2),
          ),
          child: const Center(child: Text('🏆', style: TextStyle(fontSize: 54))),
        ).animate().scale(curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text('Perfect Score! 🎉',
          style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text("You've completed this lesson!",
          style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _kCard, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kAccent.withValues(alpha: 0.15)),
          ),
          child: Column(children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('⭐', style: TextStyle(fontSize: 30)),
            SizedBox(width: 4),
            Text('⭐', style: TextStyle(fontSize: 30)),
            SizedBox(width: 4),
            Text('⭐', style: TextStyle(fontSize: 30)),
          ]),
          const SizedBox(height: 8),
          Text('3 Stars — Amazing!',
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFFFD700).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFFFD700).withValues(alpha: 0.4)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('⭐', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text('+200 XP',
                style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
            ])),
        ])),
        const SizedBox(height: 16),
        _InfoCard(color: _kAccent, emoji: '🏅', title: 'Badge Unlocked: Password Master!',
          body: "You know how to build a password that even hackers can't crack — AND you made one yourself!"),
        const SizedBox(height: 20),
        Align(alignment: Alignment.centerLeft,
          child: Text('WHAT YOU LEARNED',
            style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
        const SizedBox(height: 10),
      _SummaryTile(emoji: '🏠', text: 'Why passwords protect your online life'),
      _SummaryTile(emoji: '😬', text: 'How to spot a weak, hackable password'),
      _SummaryTile(emoji: '💪', text: 'The 4 rules of a strong password'),
      _SummaryTile(emoji: '🧠', text: 'The passphrase trick'),
      _SummaryTile(emoji: '🛠️', text: 'Built your very own strong password!'),
        const SizedBox(height: 28),
        _CatTipBox(
          message: PasswordCatMessages.completeMessage(3),
          accentColor: const Color(0xFFFFD700),
        ),
        const SizedBox(height: 16),
        _NextButton(onTap: () => finish(context), enabled: !claiming,
          label: claiming ? 'Claiming...' : '🎉  Claim your XP!'),
      ]),
    );
  }
}


class _CatTipBox extends StatelessWidget {
  final String message;
  final Color accentColor;
  const _CatTipBox({required this.message, this.accentColor = const Color(0xFFFFC857)});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
            boxShadow: [
              BoxShadow(color: accentColor.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 3)),
            ],
          ),
          child: Text(
            message,
            style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500),
          ),
        ),
        // Cat sits below bubble, aligned left
        SizedBox(
          width: 72,
          height: 72,
          child: Lottie.asset('assets/animations/cat.json', repeat: true, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

class _LessonProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const _LessonProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('PROGRESS',
              style: GoogleFonts.fredoka(
                  fontSize: 10,
                  color: Colors.white38,
                  letterSpacing: 1.0)),
          Text('$current / $total',
              style: GoogleFonts.fredoka(
                  fontSize: 11,
                  color: _kAccent,
                  fontWeight: FontWeight.w600)),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: current / total,
          minHeight: 7,
          backgroundColor: _kAccent.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
              current == total ? _kGreen : _kAccent),
        ),
      ),
    ]);
  }
}

class _LessonLabel extends StatelessWidget {
  final String label;
  const _LessonLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.chevron_right_rounded, color: _kAccent, size: 16),
      const SizedBox(width: 4),
      Text(label,
          style: GoogleFonts.fredoka(
              color: _kAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2)),
    ]);
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextButton(
      {required this.onTap,
      this.label = 'Next →',
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                SoundService.playClick();
                onTap();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kAccent,
          foregroundColor: _kBg,
          disabledBackgroundColor: _kCard,
          disabledForegroundColor: Colors.white24,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Text(label,
            style: GoogleFonts.fredoka(
                fontSize: 18, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const _InfoCard(
      {required this.color,
      required this.emoji,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 3),
            Text(body,
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white54, height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String emoji, text;
  final bool isBad;
  const _ScenarioCard(
      {required this.emoji, required this.text, required this.isBad});

  @override
  Widget build(BuildContext context) {
    final Color c = isBad ? _kRed : _kGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: GoogleFonts.fredoka(
                  fontSize: 13, fontWeight: FontWeight.w600, color: c)),
        ),
        Icon(isBad ? Icons.cancel_rounded : Icons.check_circle_rounded,
            color: c, size: 20),
      ]),
    );
  }
}

class _WeakPasswordTile extends StatelessWidget {
  final String password, reason;
  const _WeakPasswordTile({required this.password, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kRed.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _kRed.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kRed.withValues(alpha: 0.3)),
          ),
          child: Text(password,
              style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _kRed,
                  letterSpacing: 0.5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(reason,
              style: GoogleFonts.fredoka(
                  fontSize: 12, color: Colors.white54)),
        ),
        const Text('❌', style: TextStyle(fontSize: 16)),
      ]),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const _RuleCard(
      {required this.number,
      required this.emoji,
      required this.title,
      required this.body,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 2),
            Text(body,
                style: GoogleFonts.fredoka(
                    fontSize: 12, color: Colors.white54, height: 1.4)),
          ]),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Center(
            child: Text(number,
                style: GoogleFonts.fredoka(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ),
        ),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(label,
          style: GoogleFonts.fredoka(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _WordBubble extends StatelessWidget {
  final String word, emoji;
  const _WordBubble({required this.word, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _kAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kAccent.withValues(alpha: 0.25)),
      ),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(word,
            style: GoogleFonts.fredoka(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ]),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String emoji, text;
  const _SummaryTile({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: GoogleFonts.fredoka(
                  fontSize: 13, color: Colors.white54, height: 1.4)),
        ),
        const Icon(Icons.check_circle_rounded, color: _kGreen, size: 18),
      ]),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool passed;
  const _CheckRow({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: passed
              ? _kGreen.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.04),
          shape: BoxShape.circle,
          border: Border.all(
            color: passed ? _kGreen : Colors.white12,
            width: 2,
          ),
        ),
        child: Icon(passed ? Icons.check_rounded : Icons.remove_rounded,
            size: 14,
            color: passed ? _kGreen : Colors.white24),
      ),
      const SizedBox(width: 12),
      Text(label,
          style: GoogleFonts.fredoka(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: passed ? Colors.white : Colors.white38)),
    ]);
  }
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kAccent.withValues(alpha: 0.04)
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