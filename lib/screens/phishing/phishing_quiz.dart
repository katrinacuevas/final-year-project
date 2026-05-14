// phishing_quiz.dart
// 5-question multiple choice quiz for the Phishing Detective course.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'phishing_cat_messages.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';

class PhishingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const PhishingQuizStep({super.key, required this.onComplete});
  @override
  State<PhishingQuizStep> createState() => _PhishingQuizStepState();
}

class _PhishingQuizStepState extends State<PhishingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;

  static const List<Map<String, dynamic>> questions = [
    {'question': 'What does "phishing" mean?', 'emoji': '🎣',
      'options': ['A type of computer virus', 'A fake message designed to trick you', 'A type of social media post', 'An online game'],
      'correct': 1, 'explanation': 'Phishing is a fake message pretending to be from someone you trust to steal your information!'},
    {'question': 'You get an email saying your account will be deleted in 1 hour. What should you do?', 'emoji': '⏰',
      'options': ['Click the link to save it immediately!', 'Don\'t click — tell a trusted adult', 'Reply asking for more time', 'Ignore it and forget about it'],
      'correct': 1, 'explanation': 'Extreme urgency is a key phishing trick. Always tell a trusted adult before doing anything!'},
    {'question': 'Which of these email addresses looks suspicious?', 'emoji': '📧',
      'options': ['support@roblox.com', 'itsupport@school.co.uk', 'help@r0blox-free.xyz', 'admin@minecraft.net'],
      'correct': 2, 'explanation': '"r0blox-free.xyz" uses zero instead of "o" and has "free" in it — a classic fake domain trick!'},
    {'question': 'What is a safe way to check if a link is real?', 'emoji': '🔗',
      'options': ['Click it and see what happens', 'Type the official website address yourself', 'Ask the person who sent it', 'Check if it has lots of letters'],
      'correct': 1, 'explanation': 'Always type the official website address directly into your browser instead of clicking links in messages!'},
    {'question': 'A stranger in a game offers you free V-Bucks if you log in to their website. What do you do?', 'emoji': '🎮',
      'options': ['Log in quickly before the offer expires!', 'Ask them to prove it first', 'Ignore it — free currency offers are always scams', 'Tell your friends about the offer'],
      'correct': 2, 'explanation': 'Free in-game currency offers are always scams. Official games never give away currency through random messages!'},
  ];

  void _next() {
    SoundService.playClick();
    if (qi < questions.length - 1) {
      setState(() { qi++; selected = null; answered = false; });
    } else {
      widget.onComplete(_score, questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[qi];
    final List<String> opts = List<String>.from(q['options'] as List);
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
            decoration: BoxDecoration(color: kPhishingGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPhishingGreen.withValues(alpha: 0.4))),
            child: Text('${qi + 1} / ${questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kPhishingGreen, fontSize: 13))),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: (qi + 1) / questions.length, minHeight: 6,
            backgroundColor: kPhishingAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(kPhishingAccent))),
        const SizedBox(height: 20),
        PhishingDarkCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(q['question'] as String, textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
        const SizedBox(height: 16),
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final bool isCorrect  = i == correct;
          final bool isSelected = i == selected;
          Color bg = kPhishingCard, border = kPhishingAccent.withValues(alpha: 0.15), tc = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorrect) { bg = kPhishingGreen.withValues(alpha: 0.12); border = kPhishingGreen.withValues(alpha: 0.6); tc = kPhishingGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: kPhishingGreen, size: 20); }
            else if (isSelected) { bg = kPhishingRed.withValues(alpha: 0.12); border = kPhishingRed.withValues(alpha: 0.6); tc = kPhishingRed;
              trailing = const Icon(Icons.cancel_rounded, color: kPhishingRed, size: 20); }
          }
          return Padding(padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: answered ? null : () {
                if (i == correct) { SoundService.playCatHappy(); } else { SoundService.playCatIncorrect(); }
                setState(() { selected = i; answered = true; if (i == correct) _score++; });
              },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 1.5)),
                child: Row(children: [
                  Container(width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: answered && isCorrect ? kPhishingGreen.withValues(alpha: 0.2) : kPhishingAccent.withValues(alpha: 0.08),
                      border: Border.all(color: answered && isCorrect ? kPhishingGreen : kPhishingAccent.withValues(alpha: 0.3))),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13,
                        color: answered && isCorrect ? kPhishingGreen : kPhishingAccent.withValues(alpha: 0.7))))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: tc))),
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
          child: PhishingCatButton(
            button: PhishingNextButton(onTap: _next,
              label: qi < questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
            message: '${selected == correct ? "Purrfect! ✅" : "Not quite! 😿"} ${q['explanation'] as String}',
            accentColor: selected == correct ? kPhishingGreen : kPhishingRed,
            minHeight: 200,
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),
        ),
      ],
    ],
    );
  }
}