// ========================================================================
// password_quiz.dart
// ------------------------------------------------------------------------
// 5-question multiple choice quiz for the password lesson
// cat gives feedback after each answer
// ========================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'password_theme.dart';
import 'password_widgets.dart';

class QuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const QuizStep({super.key, required this.onComplete});
  @override
  State<QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<QuizStep> {
  int questionIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  int _score = 0;

  static const List<Map<String, dynamic>> questions = [
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

  void selectAnswer(int index) {
    if (answered) return;
    final int correct = questions[questionIndex]['correct'] as int;
    if (index == correct) {
      SoundService.playCatHappy();
    } else {
      SoundService.playCatIncorrect();
    }
    setState(() { selectedAnswer = index; answered = true; if (index == correct) _score++; });
  }

  void nextQuestion() {
    SoundService.playClick();
    if (questionIndex < questions.length - 1) {
      setState(() { questionIndex++; selectedAnswer = null; answered = false; });
    } else {
      widget.onComplete(_score, questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[questionIndex];
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
            child: Text('${questionIndex + 1} / ${questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kPasswordGreen, fontSize: 13))),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (questionIndex + 1) / questions.length, minHeight: 6,
            backgroundColor: kPasswordAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(kPasswordAccent))),
        const SizedBox(height: 20),

        // ----- question card -----
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

        // ----- answer options -----
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
                  ?trailing,
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
              label: questionIndex < questions.length - 1 ? 'Next Question →' : 'See Results! 🏆',
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