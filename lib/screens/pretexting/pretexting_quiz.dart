// pretexting_quiz.dart
// 5-question quiz for the Pretexting Detective course.
// Cat gives feedback after each answer — no separate feedback boxes.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/difficulty_level.dart';
import '../../services/sound_service.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';

class PretextingQuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  final DifficultyLevel difficulty;
  const PretextingQuizStep({super.key, required this.onComplete, this.difficulty = DifficultyLevel.easy});
  @override
  State<PretextingQuizStep> createState() => _PretextingQuizStepState();
}

class _PretextingQuizStepState extends State<PretextingQuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;
  late final List<Map<String, dynamic>> _questions;

  static const List<Map<String, dynamic>> _easyQuestions = [
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
      'explanation': 'Pretexting means inventing a fake story and identity to trick you into sharing information — like pretending to be a teacher, IT support, or an old friend!',
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
      'explanation': 'Real IT staff have special admin tools and NEVER need your password. Anyone asking for it is using pretexting — always refuse and tell a trusted adult!',
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
      'explanation': 'Pretexters swap letters for similar-looking numbers — "sch00l.com" fakes "school.com". Always read email addresses very carefully before trusting them!',
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
      'explanation': 'Pretexters build fake trust step by step. Never share your address online without checking with a grown-up!',
    },
    {
      'emoji': '🛑',
      'question': 'What does the "P" in the PAUSE rule stand for?',
      'options': [
        'Password',
        'Pause — stop and think before you act',
        'Post — share it with a friend',
        'Protect — change your settings',
      ],
      'correct': 1,
      'explanation': 'P stands for Pause — always stop and think before sharing any information online, even if the request seems urgent or from someone you trust!',
    },
  ];

  static const List<Map<String, dynamic>> _mediumQuestions = [
    {
      'emoji': '💻',
      'question': 'Someone claiming to be "school IT support" says they need to remotely access your device to fix a virus. What should you do?',
      'options': [
        'Let them in — IT support needs access to fix things',
        'Ask them to prove they are really from the school first',
        'Refuse and tell a trusted adult — real IT staff contact the school directly, not pupils',
        'Let them in but watch what they do',
      ],
      'correct': 2,
      'explanation': 'Real school IT support contacts the school office, not pupils directly. Anyone asking you personally for device access is almost certainly using pretexting to gain control of your device.',
    },
    {
      'emoji': '🎭',
      'question': 'How do pretexters typically make their fake story more believable?',
      'options': [
        'They use very long messages with lots of details',
        'They research real details about you first — school name, teacher\'s name, friends — to make the story sound authentic',
        'They always pretend to be family members',
        'They contact you very late at night',
      ],
      'correct': 1,
      'explanation': 'Pretexters research their targets beforehand — often from public social media — so they can drop real details into the conversation to build false trust. Real details in a message do NOT prove it is genuine.',
    },
    {
      'emoji': '🔑',
      'question': 'A friend\'s account sends you a message: "I got locked out — can you lend me your password so I can log in?" What is this?',
      'options': [
        'A genuine request — friends help each other',
        'Pretexting — using a fake emergency to get your credentials',
        'Baiting — offering something in return for your password',
        'An honest mistake',
      ],
      'correct': 1,
      'explanation': 'No legitimate friend needs YOUR password to access THEIR account. This is classic pretexting using a fake emergency. If a friend is really locked out, they contact the platform directly.',
    },
    {
      'emoji': '📝',
      'question': 'An email signed by "Mrs Johnson, Year 5 Teacher" asks for your home address for a school project. What should you check FIRST?',
      'options': [
        'Whether Mrs Johnson teaches Year 5',
        'The actual email address the message came from — not just the displayed name',
        'Whether the project sounds real',
        'The time the email was sent',
      ],
      'correct': 1,
      'explanation': 'Anyone can put any name in the "From" display name. The actual email address — the part in angle brackets — is what matters. Always check the real address, not just the name shown.',
    },
    {
      'emoji': '⌛',
      'question': 'Someone online gradually builds a friendship over several weeks before asking for any information. Why is this more dangerous?',
      'options': [
        'It means they are definitely a real friend',
        'Building trust slowly makes you less suspicious when they eventually ask for something',
        'It is less dangerous because you have more time to spot the signs',
        'It is rarer, so it is less likely to happen to you',
      ],
      'correct': 1,
      'explanation': 'Long-term grooming is a sophisticated pretexting technique. By the time the attacker asks for information, genuine trust has developed, making it much harder to recognise the threat.',
    },
  ];

  static const List<Map<String, dynamic>> _hardQuestions = [
    {
      'emoji': '📞',
      'question': 'A caller already knows your address, account number, and your parent\'s name. They now ask for your password to "fix an outage". What is most likely happening?',
      'options': [
        'They are definitely genuine — only real companies have those details',
        'They harvested those details elsewhere to build false credibility before asking for the one thing they don\'t have',
        'It is a data breach notification call',
        'They are police officers investigating fraud',
      ],
      'correct': 1,
      'explanation': 'Known details create false legitimacy — but they come from data breaches or public sources. Real companies NEVER need your password. The point of the call is always the thing they don\'t already know.',
    },
    {
      'emoji': '📱',
      'question': 'A social media account with years of posts, many followers, and mutual friends claims to know you from summer camp. What is the main risk?',
      'options': [
        'The account might post embarrassing things about you',
        'The account could be a carefully built fake identity designed to extract information over time',
        'Accepting will share your location',
        'The mutual friends might be fake accounts too',
      ],
      'correct': 1,
      'explanation': 'Sophisticated attackers build convincing fake identities over months — with real posts, followers, and mutual connections — specifically to use them for targeted pretexting later.',
    },
    {
      'emoji': '🔍',
      'question': 'What makes pretexting fundamentally different from phishing?',
      'options': [
        'Pretexting only happens by phone, phishing only happens by email',
        'Pretexting builds a false identity and relationship first, while phishing typically uses a single deceptive message',
        'Pretexting targets adults, phishing targets children',
        'Phishing asks for passwords, pretexting only asks for addresses',
      ],
      'correct': 1,
      'explanation': 'Phishing uses a single deceptive message (click this link). Pretexting involves constructing an entire false identity or scenario first — making it more sophisticated, personal, and harder to detect.',
    },
    {
      'emoji': '🌐',
      'question': 'A pretext attack uses your pet\'s name (from Instagram), your school (from Facebook), and your best friend\'s name (tagged in photos). What does this demonstrate?',
      'options': [
        'That your accounts were directly hacked',
        'That publicly shared personal information can be weaponised to create convincing fake stories',
        'That you should not have pets',
        'That Facebook and Instagram are unsafe apps',
      ],
      'correct': 1,
      'explanation': 'Attackers piece together details from public posts to craft personalised pretexts. What you share publicly can be used against you — even innocent-seeming posts.',
    },
    {
      'emoji': '🎯',
      'question': 'Which technique makes a pretexting attack most effective against children specifically?',
      'options': [
        'Using technical computer language',
        'Impersonating an authority figure (teacher, game moderator) and creating a sense of consequences',
        'Sending very long and detailed messages',
        'Contacting them on platforms parents don\'t use',
      ],
      'correct': 1,
      'explanation': 'Children are taught to respect authority and comply with their requests. Pretexters exploit this by impersonating teachers or moderators and adding consequences ("your account will be banned") to increase pressure.',
    },
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
      setState(() {
        qi++;
        selected = null;
        answered = false;
      });
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
            child: Text('${qi + 1} / ${_questions.length}',
                style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700,
                    color: kPretextGreen,
                    fontSize: 13)),
          ),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (qi + 1) / _questions.length,
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
                      if (i == correct) { SoundService.playCatHappy(); } else { SoundService.playCatIncorrect(); }
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
          child: PretextingCatButton(
            button: PretextingNextButton(
              onTap: _next,
              label: qi < _questions.length - 1 ? 'Next Question →' : 'See Results! 🎉',
            ),
            message: '${selected == correct ? "Purrfect! ✅" : "Not quite! 😿"} ${q['explanation'] as String}',
            accentColor: selected == correct ? kPretextGreen : kPretextRed,
          ),
        ),
      ],
    ],
    );
  }
}
