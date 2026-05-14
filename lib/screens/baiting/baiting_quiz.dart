// baiting_quiz.dart
// 5-question quiz for the Baiting Pro course.
// Cat gives feedback after each answer — no separate feedback boxes.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/difficulty_level.dart';
import '../../services/sound_service.dart';
import 'baiting_cat_messages.dart';
import 'baiting_theme.dart';
import 'baiting_widgets.dart';

class BaitingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  final DifficultyLevel difficulty;
  const BaitingQuizStep({super.key, required this.onComplete, this.difficulty = DifficultyLevel.easy});
  @override State<BaitingQuizStep> createState() => _BaitingQuizStepState();
}

class _BaitingQuizStepState extends State<BaitingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;
  late final List<Map<String, dynamic>> _questions;

  static const List<Map<String, dynamic>> _easyQuestions = [
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

  static const List<Map<String, dynamic>> _mediumQuestions = [
    {'question': 'A website offers "Free Spotify Premium for life — just share with 10 friends!" What type of trick is this?', 'emoji': '🎵',
      'options': ['A genuine Spotify promotion', 'Baiting — using a tempting offer to spread itself and collect your data', 'Phishing — pretending to be Spotify', 'A loyalty reward for existing users'],
      'correct': 1,
      'explanation': 'This is baiting — using a tempting offer to get you to spread it while collecting everyone\'s data. Spotify never gives away subscriptions through share chains!'},
    {'question': 'An app promises to reveal "who viewed your profile" if you log in with your gaming account. What\'s the danger?', 'emoji': '👀',
      'options': ['It might crash your device', 'It captures your login details to take over your account', 'It might cost money you didn\'t know about', 'It is against app store rules'],
      'correct': 1,
      'explanation': 'These apps are designed to steal your login credentials. The "who viewed you" feature is fake bait — once you log in, attackers have your username and password!'},
    {'question': 'An advert says "iPhone 15 GIVEAWAY — 1000 winners selected every hour!" What is the biggest red flag?', 'emoji': '📱',
      'options': ['Giving away 1000 iPhones every hour is financially impossible — it\'s always a scam', 'The advert uses capital letters', 'It says "giveaway" not "competition"', 'It mentions a specific number of winners'],
      'correct': 0,
      'explanation': 'Giving away 1000 iPhones every hour is economically impossible. If an offer is financially impossible, it is always a scam designed to steal your details.'},
    {'question': 'A gaming forum post from a popular account offers a "mod download" that unlocks all items. Why is this especially dangerous?', 'emoji': '💾',
      'options': ['Mods always contain viruses', 'The popular account makes it seem trustworthy, but the download likely contains malware', 'Mods are against the game\'s terms of service', 'The items might not work properly'],
      'correct': 1,
      'explanation': 'Attackers build up followers to look trustworthy before sharing malicious downloads. The credibility of the account IS the bait — always be suspicious of downloads promising special unlocks!'},
    {'question': 'A genuine gift offer asks for your home address to "ship it". Even if it seems real, why should you be careful?', 'emoji': '🏠',
      'options': ['The gift might not arrive', 'Your home address is sensitive personal information that reveals where you live', 'It might cost you postage fees', 'The gift might be the wrong size'],
      'correct': 1,
      'explanation': 'Even if the offer seems real, your home address is sensitive information. Attackers sometimes use real gifts as bait to collect addresses. Always check with a trusted adult before sharing your address.'},
  ];

  static const List<Map<String, dynamic>> _hardQuestions = [
    {'question': 'Why is baiting often harder to spot than phishing?', 'emoji': '🤔',
      'options': ['Baiting messages have better spelling', 'Baiting appeals to genuine desires (greed, curiosity) rather than fear, so your guard is lower', 'Baiting only happens on apps, not email', 'Phishing uses more technical language'],
      'correct': 1,
      'explanation': 'Phishing creates fear ("your account will be deleted!") which can feel suspicious. Baiting creates excitement ("you\'ve won!") so you\'re less likely to stop and question it.'},
    {'question': 'A professional-looking website with no spelling errors offers a "verified prize". What should STILL make you suspicious?', 'emoji': '🌐',
      'options': ['Professional sites are always safe', 'The prize is being offered without you entering any competition', 'The website loads slowly', 'There is no phone number listed'],
      'correct': 1,
      'explanation': 'Professional appearance and correct spelling don\'t make a site safe. You cannot win something you never entered — that remains an instant red flag no matter how polished the website looks.'},
    {'question': 'Someone offers a legitimate free gift AND asks for your email "to send delivery updates". Even if the gift is real, what\'s the risk?', 'emoji': '📩',
      'options': ['The emails might go to spam', 'Your email may be sold to marketers or used for future phishing attacks', 'The delivery might be delayed', 'You might receive too many updates'],
      'correct': 1,
      'explanation': 'Even legitimate offers can be data harvesting. Email addresses collected this way are often sold to spam networks or used in future phishing attacks. Your data has value beyond the gift itself.'},
    {'question': 'A YouTube video pauses and shows: "Congratulations viewer #1,000,000! Claim your prize!" What technique is being used?', 'emoji': '🎬',
      'options': ['A genuine YouTube milestone reward', 'Baiting — using a fake achievement and interruption to pressure a quick click', 'Phishing — pretending to be YouTube', 'An official sponsored advertisement'],
      'correct': 1,
      'explanation': 'The video interruption creates urgency, and "viewer #1,000,000" creates false achievement. Both are baiting techniques to make you click before thinking. YouTube does not reward viewers with pop-ups.'},
    {'question': 'Which is the MOST reliable way to tell if an online prize is genuine?', 'emoji': '🏆',
      'options': ['The website has a padlock icon', 'The prize was announced on the company\'s own verified social media first', 'The message uses your real name', 'The prize is something you actually want'],
      'correct': 1,
      'explanation': 'Genuine prizes are announced through official verified channels first. If a prize appears only through a DM, pop-up or forwarded message without any official announcement, it\'s almost certainly fake.'},
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
            decoration: BoxDecoration(color: kBaitGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBaitGreen.withValues(alpha: 0.4))),
            child: Text('${qi + 1} / ${_questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: kBaitGreen, fontSize: 13))),
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
              label: qi < _questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
            message: '${selected == correct ? "Purrfect! ✅" : "Not quite! 😿"} ${q['explanation'] as String}',
            accentColor: selected == correct ? kBaitGreen : kBaitRed,
          ),
        ),
      ],
    ],
    );
  }
}
