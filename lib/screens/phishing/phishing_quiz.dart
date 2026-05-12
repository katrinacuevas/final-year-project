import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';
import 'phishing_cat_messages.dart';

// ─── Quiz ─────────────────────────────────────────────────────────────────────

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

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What does "phishing" mean?',
      'emoji': '🎣',
      'options': ['A type of computer virus', 'A fake message designed to trick you', 'A type of social media post', 'An online game'],
      'correct': 1,
    },
    {
      'question': 'You get an email saying your account will be deleted in 1 hour. What should you do?',
      'emoji': '⏰',
      'options': ['Click the link to save it immediately!', 'Don\'t click — tell a trusted adult', 'Reply asking for more time', 'Ignore it and forget about it'],
      'correct': 1,
    },
    {
      'question': 'Which of these email addresses looks suspicious?',
      'emoji': '📧',
      'options': ['support@roblox.com', 'itsupport@school.co.uk', 'help@r0blox-free.xyz', 'admin@minecraft.net'],
      'correct': 2,
    },
    {
      'question': 'What is a safe way to check if a link is real?',
      'emoji': '🔗',
      'options': ['Click it and see what happens', 'Type the official website address yourself', 'Ask the person who sent it', 'Check if it has lots of letters'],
      'correct': 1,
    },
    {
      'question': 'A stranger in a game offers you free V-Bucks if you log in to their website. What do you do?',
      'emoji': '🎮',
      'options': ['Log in quickly before the offer expires!', 'Ask them to prove it first', 'Ignore it — free currency offers are always scams', 'Tell your friends about the offer'],
      'correct': 2,
    },
  ];

  void next() {
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
    final bool isCorrect = answered && selected == correct;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quiz Time! 🎯',
            style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: kPhishingGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPhishingGreen.withValues(alpha: 0.4)),
            ),
            child: Text('${qi + 1} / ${questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kPhishingGreen, fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (qi + 1) / questions.length,
            minHeight: 6,
            backgroundColor: kPhishingAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(kPhishingAccent),
          ),
        ),
        const SizedBox(height: 20),
        PhishingDarkCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(q['question'] as String,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
        const SizedBox(height: 16),
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final bool isCorr = i == correct;
          final bool isSel = i == selected;
          Color bg = kPhishingCard;
          Color border = kPhishingAccent.withValues(alpha: 0.15);
          Color tc = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorr) {
              bg = kPhishingGreen.withValues(alpha: 0.12);
              border = kPhishingGreen.withValues(alpha: 0.6);
              tc = kPhishingGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: kPhishingGreen, size: 20);
            } else if (isSel) {
              bg = kPhishingRed.withValues(alpha: 0.12);
              border = kPhishingRed.withValues(alpha: 0.6);
              tc = kPhishingRed;
              trailing = const Icon(Icons.cancel_rounded, color: kPhishingRed, size: 20);
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: answered ? null : () {
                SoundService.playClick();
                setState(() { selected = i; answered = true; if (i == correct) _score++; });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      color: answered && isCorr ? kPhishingGreen.withValues(alpha: 0.2) : kPhishingAccent.withValues(alpha: 0.08),
                      border: Border.all(color: answered && isCorr ? kPhishingGreen : kPhishingAccent.withValues(alpha: 0.3)),
                    ),
                    child: Center(child: Text(['A', 'B', 'C', 'D'][i],
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: answered && isCorr ? kPhishingGreen : kPhishingAccent.withValues(alpha: 0.7),
                      ))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value,
                    style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: tc))),
                  if (trailing != null) trailing,
                ]),
              ),
            ),
          );
        }),
        // Cat gives feedback after each answer
        if (answered) ...[
          PhishingCatButton(
            button: PhishingNextButton(
              onTap: next,
              label: qi < questions.length - 1 ? 'Next Question →' : 'See Results! 🎉',
            ),
            message: PhishingCatMessages.quizFeedback(qi, isCorrect),
          ),
        ],
      ]),
    );
  }
}