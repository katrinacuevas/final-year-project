// phishing_quiz.dart
// 5-question multiple choice quiz for the Phishing Detective course.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/difficulty_level.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';

class PhishingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  final DifficultyLevel difficulty;
  const PhishingQuizStep({super.key, required this.onComplete, this.difficulty = DifficultyLevel.easy});
  @override
  State<PhishingQuizStep> createState() => _PhishingQuizStepState();
}

class _PhishingQuizStepState extends State<PhishingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;
  late final List<Map<String, dynamic>> _questions;

  static const List<Map<String, dynamic>> _easyQuestions = [
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

  static const List<Map<String, dynamic>> _mediumQuestions = [
    {'question': 'A Discord DM from "Roblox_Support" says your account was reported and sends a link to "verify". What do you do?', 'emoji': '💬',
      'options': ['Click the link — your account might get banned!', 'Reply asking for more details', 'Ignore it — Roblox never contacts players through Discord DMs', 'Forward it to a friend to check'],
      'correct': 2, 'explanation': 'Official game support NEVER contacts players through Discord. Any account claiming to be support in a DM is a phishing attempt — go to the official website directly.'},
    {'question': 'Which URL is a fake Roblox site trying to steal your login?', 'emoji': '🔗',
      'options': ['www.roblox.com/login', 'www.roblox-freeitems.com', 'www.roblox.com/games', 'www.web.roblox.com'],
      'correct': 1, 'explanation': '"roblox-freeitems.com" is a completely different website — the real domain is "roblox-freeitems", not "roblox". Official Roblox always uses exactly "roblox.com".'},
    {'question': 'Your friend\'s account sends you a link: "I got free Robux from this site — it actually works!" What\'s most likely happening?', 'emoji': '👾',
      'options': ['Your friend found a genuine reward site', 'Your friend\'s account was hacked to send phishing links', 'Roblox is running a special friend promotion', 'Your friend is testing you'],
      'correct': 1, 'explanation': 'When accounts get hacked, attackers use them to send phishing links to all contacts — because you trust your friends! Always verify unusual messages before clicking anything.'},
    {'question': 'A website has a padlock 🔒 in the browser bar. Does this mean it\'s safe to enter your password?', 'emoji': '🔒',
      'options': ['Yes — the padlock proves it\'s a real trusted website', 'No — the padlock only means your connection is encrypted, not that the site is genuine', 'Yes — only official sites can get a padlock', 'No — padlocks are always fake'],
      'correct': 1, 'explanation': 'The padlock just means data is sent privately. It says nothing about WHO you\'re sending it to. Phishing sites can and do have padlocks — always check the actual web address!'},
    {'question': 'An email has perfect Roblox branding and your real username. It asks you to click a link. What should you do?', 'emoji': '📧',
      'options': ['Trust it — it has your real username so it must be from Roblox', 'Click the link but check the next page carefully', 'Open Roblox directly by typing roblox.com yourself', 'Reply to the email to check it is genuine'],
      'correct': 2, 'explanation': 'Phishers can copy branding perfectly and often know your username from data leaks. Always navigate to sites yourself — never via links in emails, no matter how real they look.'},
  ];

  static const List<Map<String, dynamic>> _hardQuestions = [
    {'question': 'A URL shows "www.roblox.com.security-check.net/login". What is the REAL website you\'d land on?', 'emoji': '🕵️',
      'options': ['roblox.com', 'security-check.net', 'roblox.com.security-check.net', 'login.net'],
      'correct': 1, 'explanation': 'The real domain is always the LAST part before the first slash. Here "security-check.net" is the actual website — "roblox.com" is just text added before it to confuse you!'},
    {'question': 'A phishing message uses your username, avatar colour, and last game played. How could the attacker know this?', 'emoji': '🔎',
      'options': ['They hacked Roblox\'s main servers', 'They found it on your public profile or from a data breach', 'They guessed correctly', 'Only real Roblox staff could know this'],
      'correct': 1, 'explanation': 'Phishers collect details from public profiles and data breaches to make messages feel personal. Knowing your details does NOT mean a message is from a real source!'},
    {'question': 'An email arrives from "admin@fortnite-epicgames.support" with perfect branding. Which part PROVES it is fake?', 'emoji': '📬',
      'options': ['It uses "admin" instead of a real name', 'The domain is "fortnite-epicgames.support" instead of "epicgames.com"', 'It includes your username', 'The subject line says IMPORTANT'],
      'correct': 1, 'explanation': 'Epic Games\' real domain is epicgames.com. Any real email must come from @epicgames.com. The domain "fortnite-epicgames.support" belongs to whoever registered it — not Epic Games!'},
    {'question': 'You accidentally clicked a phishing link but haven\'t typed anything yet. What should you do FIRST?', 'emoji': '⚠️',
      'options': ['Type your username quickly then change your password later', 'Close the page immediately without entering anything', 'Delete the original message first', 'Tell your friends to avoid the link'],
      'correct': 1, 'explanation': 'If you haven\'t entered anything, closing immediately means no damage is done. Then tell a trusted adult so they can check your accounts — acting quickly is key!'},
    {'question': 'Why do phishing messages often say "ACT NOW — your account will be deleted in 1 hour!"?', 'emoji': '⏱️',
      'options': ['Because it is genuinely urgent and accounts do get deleted', 'To stop you thinking carefully and checking if it is real', 'To make the message look more official', 'Because longer deadlines are easier to ignore'],
      'correct': 1, 'explanation': 'Fake urgency is a deliberate trick to make you panic and act without thinking. Real services give you plenty of time and never threaten immediate deletion via email.'},
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

  void _next() {
    SoundService.playClick();
    if (qi < _questions.length - 1) {
      setState(() { qi++; selected = null; answered = false; });
    } else {
      widget.onComplete(_score, _questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[qi];
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
            child: Text('${qi + 1} / ${_questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kPhishingGreen, fontSize: 13))),
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
          child: LinearProgressIndicator(value: (qi + 1) / _questions.length, minHeight: 6,
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
              label: qi < _questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
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
