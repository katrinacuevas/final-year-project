// pretexting_quiz.dart
// 5-question quiz for the Pretexting Detective course.
// Cat gives feedback after each answer — no separate feedback boxes.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sound_service.dart';
import 'pretexting_cat_messages.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';

class PretextingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const PretextingQuizStep({super.key, required this.onComplete});
  @override
  State<PretextingQuizStep> createState() => _PretextingQuizStepState();
}

class _PretextingQuizStepState extends State<PretextingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;

  static const List<Map<String, dynamic>> questions = [
    {
      'emoji': '🎭',
      'question': 'What is "pretexting"?',
      'options': [
        'Sending fake emails to scare you',
        'Making up a fake story and pretending to be someone else to get your info',
        'Installing a virus on a computer',
        'Pretending to be ill to skip school',
      ],
      'correct': 1,
    },
    {
      'emoji': '🧑‍💻',
      'question': 'A message says it\'s from your school\'s IT department and asks for your password. What should you do?',
      'options': [
        'Send your password — it\'s the IT team!',
        'Send only your username, not your password',
        'Refuse and tell a grown-up — IT staff NEVER need your password',
        'Ignore it and hope they go away',
      ],
      'correct': 2,
    },
    {
      'emoji': '🔍',
      'question': 'How can you tell if an email address is suspicious?',
      'options': [
        'It has your name in it',
        'It uses tricks like "sch00l.com" — zeros instead of the letter "o" — to look real',
        'It was sent in the morning',
        'It uses capital letters',
      ],
      'correct': 1,
    },
    {
      'emoji': '🤔',
      'question': 'Someone online says they\'re an old friend and asks for your home address to send a card. What do you do?',
      'options': [
        'Give them your address — it\'s just a card!',
        'Give your street name but not your house number',
        'Don\'t share anything and check with a grown-up first',
        'Ask them to send a digital card instead',
      ],
      'correct': 2,
    },
    {
      'emoji': '🛑',
      'question': 'What does the "P" in the PAUSE rule stand for?',
      'options': [
        'Password',
        'Pause',
        'Police',
        'Privacy',
      ],
      'correct': 1,
    },
  ];

  void _next() {
    SoundService.playClick();
    if (qi < questions.length - 1) {
      setState(() {
        qi++;
        selected = null;
        answered = false;
      });
    } else {
      widget.onComplete(_score, questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[qi];
    final List<String> opts = List<String>.from(q['options'] as List);
    final int correct = q['correct'] as int;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quiz Time! 🎯',
              style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: kPretextGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: kPretextGreen.withValues(alpha: 0.4)),
            ),
            child: Text('${qi + 1} / ${questions.length}',
                style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700,
                    color: kPretextGreen,
                    fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (qi + 1) / questions.length,
            minHeight: 6,
            backgroundColor: kPretextAccent.withValues(alpha: 0.1),
            valueColor:
                const AlwaysStoppedAnimation<Color>(kPretextAccent),
          ),
        ),
        const SizedBox(height: 20),
        PretextingCard(
          child: Column(children: [
            Text(q['emoji'] as String,
                style: const TextStyle(fontSize: 44)),
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
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final bool isCorrect = i == correct;
          final bool isSelected = i == selected;
          Color bg = kPretextCard;
          Color border = kPretextAccent.withValues(alpha: 0.15);
          Color tc = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorrect) {
              bg = kPretextGreen.withValues(alpha: 0.12);
              border = kPretextGreen.withValues(alpha: 0.6);
              tc = kPretextGreen;
              trailing = const Icon(Icons.check_circle_rounded,
                  color: kPretextGreen, size: 20);
            } else if (isSelected) {
              bg = kPretextRed.withValues(alpha: 0.12);
              border = kPretextRed.withValues(alpha: 0.6);
              tc = kPretextRed;
              trailing = const Icon(Icons.cancel_rounded,
                  color: kPretextRed, size: 20);
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: answered
                  ? null
                  : () {
                      SoundService.playClick();
                      setState(() {
                        selected = i;
                        answered = true;
                        if (i == correct) _score++;
                      });
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: answered && isCorrect
                          ? kPretextGreen.withValues(alpha: 0.2)
                          : kPretextAccent.withValues(alpha: 0.08),
                      border: Border.all(
                          color: answered && isCorrect
                              ? kPretextGreen
                              : kPretextAccent.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                        child: Text(['A', 'B', 'C', 'D'][i],
                            style: GoogleFonts.fredoka(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: answered && isCorrect
                                    ? kPretextGreen
                                    : kPretextAccent
                                        .withValues(alpha: 0.7)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(e.value,
                          style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: tc))),
                  if (trailing != null) trailing,
                ]),
              ),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 16),
          PretextingCatButton(
            button: PretextingNextButton(
              onTap: _next,
              label: qi < questions.length - 1
                  ? 'Next Question →'
                  : 'See Results! 🎉',
            ),
            message: PretextingCatMessages.quizFeedback(
                qi, selected == correct),
            accentColor:
                selected == correct ? kPretextGreen : kPretextRed,
          ),
        ],
      ]),
    );
  }
}
