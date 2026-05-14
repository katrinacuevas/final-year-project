// baiting_quiz.dart
// 5-question quiz for the Baiting Pro course.
// Cat gives feedback after each answer — no separate feedback boxes.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'baiting_cat_messages.dart';
import 'baiting_theme.dart';
import 'baiting_widgets.dart';

class BaitingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const BaitingQuizStep({super.key, required this.onComplete});
  @override State<BaitingQuizStep> createState() => _BaitingQuizStepState();
}

class _BaitingQuizStepState extends State<BaitingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;

  static const List<Map<String, dynamic>> questions = [
    {'question': 'What makes baiting different from phishing?', 'emoji': '🪤',
      'options': ['Baiting uses fear and urgency', 'Baiting uses greed and temptation', 'Baiting only happens by email', 'Baiting is less dangerous'],
      'correct': 1,
      'explanation': 'Phishing uses fear ("your account will be deleted!"), while baiting uses greed and temptation ("free prizes, free games!") to trick you.'},
    {'question': 'You see "FREE 10,000 V-Bucks — click here in the next 5 mins!" What do you do?', 'emoji': '🎮',
      'options': ['Click quickly before it expires!', 'Ask a friend if it\'s real', 'Ignore it — free game currency is always a trap', 'Share it with your friends first'],
      'correct': 2,
      'explanation': 'Free in-game currency is always a trap. The countdown is fake urgency to stop you thinking. Official games never give away currency through random messages!'},
    {'question': 'You find a USB stick on the floor labelled "SECRET FILES". What should you do?', 'emoji': '🖲️',
      'options': ['Plug it in to see what\'s on it!', 'Give it to a trusted adult without plugging it in', 'Put it back where you found it', 'Share it with a friend'],
      'correct': 1,
      'explanation': 'Hackers leave USB sticks with tempting labels on purpose. Plugging in an unknown USB can instantly infect a computer with malware — always give it to a trusted adult!'},
    {'question': 'You get a message saying you\'ve won a PS5 in a competition you never entered. What is this?', 'emoji': '🏆',
      'options': ['A genuine prize — fill in your details!', 'A mistake — someone sent it to the wrong person', 'Classic baiting — you can\'t win something you didn\'t enter', 'A loyalty reward from a game company'],
      'correct': 2,
      'explanation': 'You can\'t win a competition you never entered — that\'s an instant red flag! Fake prize messages are designed to steal your personal details.'},
    {'question': 'You spot a baiting trap online. What\'s the BEST first step?', 'emoji': '🛡️',
      'options': ['Click it to check if it\'s real', 'Tell your friends about it', 'Stop, close it, and tell a trusted adult', 'Report it but keep looking at it'],
      'correct': 2,
      'explanation': 'Always stop and close the trap straight away. Clicking to "check" is still dangerous — the harm can happen in a single click. Then tell a trusted adult!'},
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
            decoration: BoxDecoration(color: kBaitGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBaitGreen.withValues(alpha: 0.4))),
            child: Text('${qi + 1} / ${questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kBaitGreen, fontSize: 13))),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: (qi + 1) / questions.length, minHeight: 6,
            backgroundColor: kBaitAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(kBaitAccent))),
        const SizedBox(height: 20),
        BaitingCard(child: Column(children: [
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
          Color bg = kBaitCard, border = kBaitAccent.withValues(alpha: 0.15), tc = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorrect) { bg = kBaitGreen.withValues(alpha: 0.12); border = kBaitGreen.withValues(alpha: 0.6); tc = kBaitGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: kBaitGreen, size: 20); }
            else if (isSelected) { bg = kBaitRed.withValues(alpha: 0.12); border = kBaitRed.withValues(alpha: 0.6); tc = kBaitRed;
              trailing = const Icon(Icons.cancel_rounded, color: kBaitRed, size: 20); }
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
                      color: answered && isCorrect ? kBaitGreen.withValues(alpha: 0.2) : kBaitAccent.withValues(alpha: 0.08),
                      border: Border.all(color: answered && isCorrect ? kBaitGreen : kBaitAccent.withValues(alpha: 0.3))),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13,
                        color: answered && isCorrect ? kBaitGreen : kBaitAccent.withValues(alpha: 0.7))))),
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
          child: BaitingCatButton(
            button: BaitingNextButton(onTap: _next,
              label: qi < questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
            message: '${selected == correct ? "Purrfect! ✅" : "Not quite! 😿"} ${q['explanation'] as String}',
            accentColor: selected == correct ? kBaitGreen : kBaitRed,
          ),
        ),
      ],
    ],
    );
  }
}