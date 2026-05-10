import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../widgets/xp_award.dart';
import '../../services/sound_service.dart';

const Color _kAccent = Color(0xFF4FC3F7);
const Color _kBg     = Color(0xFF0D1117);
const Color _kCard   = Color(0xFF161B2E);
const Color _kCyan   = Color(0xFF00D1FF);
const Color _kGreen  = Color(0xFF00E676);
const Color _kRed    = Color(0xFFFF5252);

class PhishingDetectiveScreen extends StatefulWidget {
  const PhishingDetectiveScreen({super.key});
  @override
  State<PhishingDetectiveScreen> createState() => _PhishingDetectiveScreenState();
}

class _PhishingDetectiveScreenState extends State<PhishingDetectiveScreen> {
  int currentStep = 0;
  static const int totalSteps = 6;
  int _quizScore = 0;
  int _quizTotal = 0;

  void goNext() => setState(() => currentStep++);
  void goBack() {
    if (currentStep > 0) { setState(() => currentStep--); }
    else { Navigator.pop(context); }
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = currentStep >= 1 && currentStep <= totalSteps;
    final bool isComplete = currentStep == totalSteps + 1;
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        SafeArea(child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              if (!isComplete)
                GestureDetector(
                  onTap: () { SoundService.playClick(); goBack(); },
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kAccent.withValues(alpha: 0.3))),
                    child: const Icon(Icons.arrow_back_rounded, color: _kAccent, size: 20),
                  ),
                ).animate().scale(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: _kAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🎣', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Text(
                    showProgress ? 'LESSON $currentStep OF $totalSteps' : 'PHISHING DETECTIVE',
                    style: GoogleFonts.fredoka(color: _kAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ]),
              ),
            ]),
          ),
          if (showProgress)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _LessonProgressBar(current: currentStep, total: totalSteps),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _buildStep(),
            ),
          ),
        ])),
      ]),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0: return _IntroStep(key: const ValueKey(0), onNext: goNext);
      case 1: return _Lesson1(key: const ValueKey(1), onNext: goNext);
      case 2: return _Lesson2(key: const ValueKey(2), onNext: goNext);
      case 3: return _Lesson3(key: const ValueKey(3), onNext: goNext);
      case 4: return _Lesson4(key: const ValueKey(4), onNext: goNext);
      case 5: return _ChatSimActivity(key: const ValueKey(5), onNext: goNext);
      case 6: return _QuizStep(key: const ValueKey(6), onComplete: (s,t) { setState(() { _quizScore = s; _quizTotal = t; currentStep++; }); });
      case 7: return _CompleteStep(key: const ValueKey(7), score: _quizScore, total: _quizTotal, onRetry: () => setState(() => currentStep = 6), onDone: () => Navigator.pop(context));
      default: return const SizedBox();
    }
  }
}

class _IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroStep({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(children: [
      Container(width: 110, height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [_kAccent, _kBg], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: _kAccent.withValues(alpha: 0.6), width: 2)),
        child: const Center(child: Text('🎣', style: TextStyle(fontSize: 54))),
      ).animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text('Phishing Detective!', textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      Text('Learn how cybercriminals send fake messages to trick you — and become an expert at spotting them! 🕵️',
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54, height: 1.5)),
      const SizedBox(height: 24),
      _InfoCard(color: _kAccent, emoji: '📖', title: "What you'll learn",
        body: 'What phishing is, how to spot fake emails and messages, red flags, what to do, and real chat simulations.'),
      const SizedBox(height: 10),
      _InfoCard(color: _kGreen, emoji: '⏱️', title: '~20 minutes',
        body: '4 lessons + chat simulation + quiz at the end!'),
      const SizedBox(height: 10),
      _InfoCard(color: _kAccent, emoji: '⭐', title: 'Earn +150 XP',
        body: 'Complete everything to earn your Phishing Detective badge!'),
      const SizedBox(height: 28),
      _NextButton(onTap: onNext, label: '▶  Start Course'),
    ]),
  );
}

class _Lesson1 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson1({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'WHAT IS PHISHING?'),
      const SizedBox(height: 16),
      _DarkCard(child: Column(children: [
        const Text('🎣', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 10),
        Text('Phishing is when a cybercriminal sends you a fake message pretending to be someone you trust — to trick you into giving away personal information.',
          textAlign: TextAlign.center, style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.5)),
      ])),
      const SizedBox(height: 16),
      Text('Why is it called "phishing"? 🐟',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _DarkCard(child: Column(children: [
        _SimpleRow(emoji: '🎣', text: 'A fisherman throws bait hoping a fish will bite'),
        _SimpleRow(emoji: '📧', text: 'A phisher sends fake messages hoping YOU will bite'),
        _SimpleRow(emoji: '🐟', text: 'The fish gets caught — you give away your password'),
        _SimpleRow(emoji: '😨', text: 'The phisher gets into your accounts'),
      ])),
      const SizedBox(height: 16),
      Text('Who do phishers pretend to be?',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _InfoCard(color: _kAccent, emoji: '🏫', title: 'Your school',
        body: '"Your account needs verifying — click here immediately or it will be deleted."'),
      const SizedBox(height: 8),
      _InfoCard(color: const Color(0xFFFF8A65), emoji: '🎮', title: 'Game companies',
        body: '"Your Roblox/Minecraft account has been flagged. Log in now to keep your account."'),
      const SizedBox(height: 8),
      _InfoCard(color: _kAccent, emoji: '👦', title: 'Someone you know',
        body: '"Hey it\'s me — I got a new number. Can you send me the code that just came to your phone?"'),
      const SizedBox(height: 12),
      _TipBox(text: 'Phishing can happen by email, text, gaming chats and social media DMs. Always be alert!'),
      const SizedBox(height: 28),
      _NextButton(onTap: onNext),
    ]),
  );
}

class _Lesson2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson2({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'SPOTTING FAKE MESSAGES'),
      const SizedBox(height: 6),
      Text('Can you tell a real message from a fake one?',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 14),
      _EmailCard(from: 'support@sch00l-help.com',
        subject: 'URGENT: Your account will be deleted in 24 hours!',
        body: 'Dear student, your school account has been flagged. Click the link below immediately to avoid losing access forever.',
        isReal: false, clue: '"sch00l-help.com" uses zeros instead of "o" — a classic fake address trick.'),
      const SizedBox(height: 12),
      _EmailCard(from: 'itsupport@westfieldacademy.co.uk',
        subject: 'Scheduled maintenance this weekend',
        body: 'The school portal will be offline Saturday 9am–1pm for updates. No action required from students.',
        isReal: true, clue: 'Official domain, no urgency, no links, no request for personal info.'),
      const SizedBox(height: 16),
      Text('Red flags to look for 🚩',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '⏰ Extreme urgency', detail: '"Act NOW or your account will be deleted!" — real organisations give you time.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '✉️ Suspicious sender address', detail: 'Look closely — "amaz0n.com" or "sch00l-help.com" are fake. Check the full address.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '🔑 Asking for your password', detail: 'No real company, school or game will ever ask for your password by email. Ever.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '🔗 Unexpected links', detail: 'A message with a random link you weren\'t expecting is almost always suspicious.'),
      const SizedBox(height: 12),
      _TipBox(text: 'Always check the full email address — not just the name shown. "Apple Support" could come from "apple.xyz.ru"!'),
      const SizedBox(height: 28),
      _NextButton(onTap: onNext),
    ]),
  );
}

class _Lesson3 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson3({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'SUSPICIOUS LINKS'),
      const SizedBox(height: 6),
      Text('A dangerous link can look completely normal. Here\'s how to spot one:',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 14),
      _DarkCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('⚠️  Real vs Fake Links',
          style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 12),
        _LinkRow(label: '✅', link: 'roblox.com/login', safe: true),
        _LinkRow(label: '❌', link: 'r0blox-free.xyz/login', safe: false),
        const SizedBox(height: 4),
        _LinkRow(label: '✅', link: 'minecraft.net/en-us', safe: true),
        _LinkRow(label: '❌', link: 'minecraft-free-items.xyz', safe: false),
        const SizedBox(height: 4),
        _LinkRow(label: '✅', link: 'bbc.co.uk/news', safe: true),
        _LinkRow(label: '❌', link: 'bbc.news-alerts.ru/click', safe: false),
      ])),
      const SizedBox(height: 16),
      Text('How to check a link safely 🛡️',
        style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 10),
      _StepCard(number: '1', emoji: '🌐', color: _kAccent,
        title: 'Go directly to the website', body: 'Type the official website address yourself in your browser instead of clicking the link.'),
      const SizedBox(height: 8),
      _StepCard(number: '2', emoji: '🔒', color: _kGreen,
        title: 'Check for https://', body: 'Real websites use "https://" and show a padlock icon. No padlock = not secure.'),
      const SizedBox(height: 8),
      _StepCard(number: '3', emoji: '🔍', color: const Color(0xFFBA68C8),
        title: 'Look for sneaky spelling tricks', body: '"r0blox" uses zero instead of o. "amaz0n" fakes Amazon. Read the full address carefully.'),
      const SizedBox(height: 8),
      _StepCard(number: '4', emoji: '🙋', color: _kAccent,
        title: 'Ask a trusted adult', body: 'If you\'re ever unsure — don\'t click. Show a parent or teacher first.'),
      const SizedBox(height: 12),
      _TipBox(text: 'NEVER click a link in a message you weren\'t expecting — even if it looks like it came from a friend you know.'),
      const SizedBox(height: 28),
      _NextButton(onTap: onNext),
    ]),
  );
}

class _Lesson4 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson4({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _LessonLabel(label: 'WHAT TO DO'),
      const SizedBox(height: 6),
      Text('If you think you\'ve received a phishing message — follow these steps:',
        style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54)),
      const SizedBox(height: 14),
      _StepCard(number: '1', emoji: '🛑', color: _kRed,
        title: 'STOP — don\'t click anything', body: 'Close the message. Don\'t tap any links, download files or reply.'),
      const SizedBox(height: 10),
      _StepCard(number: '2', emoji: '🤔', color: _kAccent,
        title: 'Ask yourself: Does this make sense?', body: 'Did I expect this? Would my school or game company really send this?'),
      const SizedBox(height: 10),
      _StepCard(number: '3', emoji: '🗣️', color: _kAccent,
        title: 'Tell a trusted adult', body: 'Show the message to a parent or teacher. They can help you check if it\'s real.'),
      const SizedBox(height: 10),
      _StepCard(number: '4', emoji: '🚫', color: const Color(0xFFBA68C8),
        title: 'Report and delete', body: 'Use the "Report" button in your email or app, then delete the message.'),
      const SizedBox(height: 10),
      _StepCard(number: '5', emoji: '🔒', color: _kGreen,
        title: 'Change your password if needed', body: 'If you accidentally entered your details — tell an adult and change your password immediately.'),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _kGreen.withValues(alpha: 0.35))),
        child: Row(children: [
          const Text('🧠', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text('It\'s always better to be too careful than to fall for a scam. Real organisations will never be upset that you checked!',
            style: GoogleFonts.fredoka(fontSize: 13, color: _kGreen, height: 1.4))),
        ])),
      const SizedBox(height: 28),
      _NextButton(onTap: onNext, label: 'Chat Simulation 💬'),
    ]),
  );
}

// ─── Chat Simulation ──────────────────────────────────────────────────────────

class _ChatSimActivity extends StatefulWidget {
  final VoidCallback onNext;
  const _ChatSimActivity({super.key, required this.onNext});
  @override
  State<_ChatSimActivity> createState() => _ChatSimActivityState();
}

class _ChatSimActivityState extends State<_ChatSimActivity> {
  int scenarioIndex = 0;
  int visibleMsgCount = 0;
  int? choice;
  bool showFeedback = false;
  bool isTyping = false;
  bool choicePhase = false;
  Timer? _msgTimer;
  final ScrollController _scrollCtrl = ScrollController();

  final List<Map<String, dynamic>> scenarios = [
    {
      'title': 'Free Robux DM',
      'roomName': 'RobloxPlayer_Xr3',
      'roomAvatar': '🎮',
      'messages': [
        {'from': 'stranger', 'text': 'Hey!! I found a glitch that gives unlimited Robux 💎 Want some for free?', 'delay': 600},
        {'from': 'you',      'text': 'Wait... really?? 😮',                                                       'delay': 1200},
        {'from': 'stranger', 'text': 'Yeah! Just log in here 👉 r0blox-free.xyz and I\'ll send 10,000 to you 🤑', 'delay': 1400},
        {'from': 'stranger', 'text': 'But you have to do it in the next 10 mins or the link expires!! ⏰',         'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': ['Quick — log in before time runs out!', 'Ask them to prove it first', 'This looks fake — I\'m NOT clicking that'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'That\'s a phishing trap!',
          'points': ['"r0blox-free.xyz" is NOT the real Roblox website', 'Logging in hands them your username and password', 'Free Robux glitches don\'t exist — it\'s always a scam']},
        {'safe': false, 'emoji': '😬', 'title': 'Better instinct — but still risky!',
          'points': ['Screenshots and "proof" can be faked easily', 'Staying in the chat lets the scammer keep trying', 'Safest move is to exit the chat and tell an adult']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Great detective work! 🎉',
          'points': ['You spotted the dodgy URL "r0blox-free.xyz"', 'You weren\'t tricked by the countdown pressure', 'You can also report the account to protect others!']},
      ],
    },
    {
      'title': 'School Email Alert',
      'roomName': 'school-notifications@sch00l-help.com',
      'roomAvatar': '🏫',
      'messages': [
        {'from': 'stranger', 'text': 'URGENT: Your school email will be deleted in 24 hours 🚨',                  'delay': 600},
        {'from': 'you',      'text': 'What?! Why?? 😱',                                                            'delay': 1200},
        {'from': 'stranger', 'text': 'Our system detected unusual activity. Verify now at school-help-verify.com', 'delay': 1400},
        {'from': 'stranger', 'text': 'Enter your school login to keep your account — time is running out! 🕐',     'delay': 1200},
      ],
      'question': 'What should you do?',
      'choices': ['Log in quickly to save my account!', 'Email back asking if it\'s real', 'Don\'t click anything — ask my teacher in person'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '😨', 'title': 'That\'s exactly what the scammer wants!',
          'points': ['Real schools never threaten to delete accounts without proper notice', '"school-help-verify.com" is not your school\'s real website', 'Your login details would be stolen immediately']},
        {'safe': false, 'emoji': '😬', 'title': 'Good instinct — but replying isn\'t safe!',
          'points': ['Replying confirms your email address is active', 'They\'ll just send another convincing fake reply', 'Go to a teacher in person to check instead']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Exactly right! 🎉',
          'points': ['You spotted the urgency trick — a classic phishing tactic', 'Checking in person means you can\'t be fooled by a fake reply', 'Real school IT staff can confirm if the email is genuine']},
      ],
    },
    {
      'title': 'Gaming Chat Support',
      'roomName': 'MC_Support_Official',
      'roomAvatar': '⛏️',
      'messages': [
        {'from': 'stranger', 'text': 'Hey! I\'m from the Minecraft support team 🎮 You\'ve been selected for a FREE rank upgrade!', 'delay': 600},
        {'from': 'you',      'text': 'Oh wow, really? 😮',                                                                          'delay': 1200},
        {'from': 'stranger', 'text': 'Yes! Just verify your account at: mc-support-verify.net and we\'ll apply it!',                'delay': 1400},
        {'from': 'stranger', 'text': 'This offer expires in 15 minutes — don\'t miss out!! ⏰',                                     'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': ['Log in quickly to claim the upgrade!', 'Ask a parent to check if this is real', 'Block and ignore — this is 100% a scam'],
      'correct': 2,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'That\'s a phishing attempt!',
          'points': ['Game companies never DM players offering free upgrades', '"mc-support-verify.net" is not an official Minecraft website', 'Your account details would be stolen instantly']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Really good thinking! 🎉',
          'points': ['Asking a parent is always a smart move', 'A trusted adult can help spot the scam', 'Two sets of eyes are better than one!']},
        {'safe': true,  'emoji': '🛡️', 'title': 'Spot on, detective! 🎉',
          'points': ['Real game companies never contact players via random DMs', 'The countdown timer is a classic pressure trick', 'Blocking protects other players too!']},
      ],
    },
  ];

  Map<String, dynamic> get scenario => scenarios[scenarioIndex];
  List get msgs => scenario['messages'] as List;
  bool get isLastScenario => scenarioIndex == scenarios.length - 1;

  @override
  void initState() {
    super.initState();
    _startScenario();
  }

  @override
  void dispose() {
    _msgTimer?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _startScenario() {
    setState(() {
      visibleMsgCount = 0;
      isTyping = false;
      choicePhase = false;
      choice = null;
      showFeedback = false;
    });
    _scheduleNextMessage();
  }

  void _scheduleNextMessage() {
    if (visibleMsgCount >= msgs.length) {
      setState(() => choicePhase = true);
      return;
    }

    final msg = msgs[visibleMsgCount] as Map;
    final String text = msg['text'] as String;
    final int delay = msg['delay'] as int;
    final bool isStranger = msg['from'] == 'stranger';
    // How long the typewriter takes for this message (28ms per char)
    final int typeDuration = isStranger ? text.length * 28 : 0;

    if (isStranger) {
      setState(() => isTyping = true);
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() {
          isTyping = false;
          visibleMsgCount++;
        });
        _scrollToBottom();
        // Wait for typewriter to finish before showing next message
        _msgTimer = Timer(Duration(milliseconds: typeDuration + 120), () {
          if (!mounted) return;
          _scheduleNextMessage();
        });
      });
    } else {
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() => visibleMsgCount++);
        _scrollToBottom();
        // "You" messages are instant so just a short pause
        _msgTimer = Timer(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          _scheduleNextMessage();
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _selectChoice(int index) {
    SoundService.playClick();
    setState(() { choice = index; showFeedback = true; });
  }

  void _nextScenario() {
    SoundService.playClick();
    _msgTimer?.cancel();
    if (isLastScenario) {
      widget.onNext();
    } else {
      setState(() => scenarioIndex++);
      _startScenario();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fb = showFeedback
        ? (scenario['feedback'] as List)[choice!] as Map<String, dynamic>
        : null;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Chat Simulation 💬',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: _kAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
            child: Text('${scenarioIndex + 1} / ${scenarios.length}',
              style: GoogleFonts.fredoka(color: _kAccent, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ]),
      ),
      const SizedBox(height: 10),
      _ChatRoomHeader(
        roomName: scenario['roomName'] as String,
        avatar: scenario['roomAvatar'] as String,
        title: scenario['title'] as String,
      ),
      Expanded(
        child: ListView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          children: [
            ...msgs.sublist(0, visibleMsgCount).map((m) {
              final bool isYou = m['from'] == 'you';
              return _AnimatedChatBubble(
                key: ValueKey('${scenarioIndex}_${msgs.indexOf(m)}'),
                text: m['text'] as String,
                isYou: isYou,
                senderName: isYou ? 'You' : scenario['roomName'] as String,
                scrollCtrl: _scrollCtrl,
              );
            }),
            if (isTyping) _TypingIndicator(key: ValueKey('typing_$scenarioIndex')),
            if (choicePhase && !showFeedback) ...[
              const SizedBox(height: 8),
              _ChoicePrompt(
                question: scenario['question'] as String,
                choices: scenario['choices'] as List,
                onSelect: _selectChoice,
              ),
            ],
            if (showFeedback && fb != null) ...[
              const SizedBox(height: 8),
              _FeedbackCard(fb: fb),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: _NextButton(
                  onTap: _nextScenario,
                  label: isLastScenario ? 'Take the Quiz! 🎯' : 'Next Scenario →',
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ]);
  }
}

class _ChatRoomHeader extends StatelessWidget {
  final String roomName, avatar, title;
  const _ChatRoomHeader({required this.roomName, required this.avatar, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kAccent.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _kRed.withValues(alpha: 0.12),
            border: Border.all(color: _kRed.withValues(alpha: 0.4)),
          ),
          child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
            style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(roomName,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _kRed.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kRed.withValues(alpha: 0.3)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 6, height: 6,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _kRed)),
            const SizedBox(width: 4),
            Text('UNKNOWN', style: GoogleFonts.fredoka(fontSize: 10, color: _kRed, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}

class _AnimatedChatBubble extends StatefulWidget {
  final String text, senderName;
  final bool isYou;
  final ScrollController scrollCtrl;
  const _AnimatedChatBubble({super.key, required this.text, required this.isYou, required this.senderName, required this.scrollCtrl});

  @override
  State<_AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<_AnimatedChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  String _displayed = '';
  Timer? _typeTimer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _fade  = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(widget.isYou ? 0.12 : -0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
    _startTyping();
  }

  void _startTyping() {
    if (widget.isYou) {
      setState(() => _displayed = widget.text);
      return;
    }
    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_charIndex >= widget.text.length) { t.cancel(); return; }
      _charIndex++;
      setState(() => _displayed = widget.text.substring(0, _charIndex));
      // Scroll every ~5 chars so the screen follows the text smoothly
      if (_charIndex % 5 == 0 && widget.scrollCtrl.hasClients) {
        widget.scrollCtrl.animateTo(
          widget.scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _typeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String label = widget.isYou
        ? 'You'
        : (widget.senderName.length > 22 ? '${widget.senderName.substring(0, 22)}...' : widget.senderName);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 8,
            left: widget.isYou ? 50 : 0,
            right: widget.isYou ? 0 : 50,
          ),
          child: Column(
            crossAxisAlignment: widget.isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 4, right: 4),
                child: Text(label,
                  style: GoogleFonts.fredoka(
                    fontSize: 10,
                    color: widget.isYou ? _kAccent.withValues(alpha: 0.6) : _kRed.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: widget.isYou ? _kAccent.withValues(alpha: 0.1) : _kCard,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(widget.isYou ? 18 : 4),
                    bottomRight: Radius.circular(widget.isYou ? 4 : 18),
                  ),
                  border: Border.all(
                    color: widget.isYou ? _kAccent.withValues(alpha: 0.25) : _kRed.withValues(alpha: 0.2),
                  ),
                ),
                child: Stack(children: [
                  Text(
                    widget.text,
                    style: GoogleFonts.fredoka(fontSize: 14, color: Colors.transparent, height: 1.45),
                  ),
                  Text(
                    _displayed,
                    style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, height: 1.45),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({super.key});
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _dotAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
    _dotAnims = List.generate(3, (i) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut),
      ),
    ));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 50),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18),
              bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18),
            ),
            border: Border.all(color: _kRed.withValues(alpha: 0.2)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
            AnimatedBuilder(
              animation: _dotAnims[i],
              builder: (_, _) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 7, height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kRed.withValues(alpha: 0.3 + 0.6 * _dotAnims[i].value),
                ),
              ),
            ),
          )),
        ),
      ]),
    );
  }
}

class _ChoicePrompt extends StatelessWidget {
  final String question;
  final List choices;
  final ValueChanged<int> onSelect;
  const _ChoicePrompt({required this.question, required this.choices, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _kAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kAccent.withValues(alpha: 0.25)),
        ),
        child: Row(children: [
          const Text('🤔', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(question,
            style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
        ]),
      ),
      ...choices.asMap().entries.map((e) =>
        GestureDetector(
          onTap: () => onSelect(e.key),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kAccent.withValues(alpha: 0.25), width: 1.5),
            ),
            child: Row(children: [
              Container(width: 26, height: 26,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _kAccent.withValues(alpha: 0.1),
                  border: Border.all(color: _kAccent.withValues(alpha: 0.4))),
                child: Center(child: Text(['A','B','C'][e.key],
                  style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: _kAccent)))),
              const SizedBox(width: 12),
              Expanded(child: Text(e.value as String,
                style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70))),
            ]),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: e.key * 100)).slideX(begin: 0.05),
      ),
    ]);
  }
}

class _FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> fb;
  const _FeedbackCard({required this.fb});

  @override
  Widget build(BuildContext context) {
    final bool safe = fb['safe'] as bool;
    final Color c = safe ? _kGreen : _kRed;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(fb['emoji'] as String, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(fb['title'] as String,
            style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: c))),
        ]),
        const SizedBox(height: 10),
        ...(fb['points'] as List).map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(safe ? Icons.check_circle_rounded : Icons.cancel_rounded, color: c, size: 15),
            const SizedBox(width: 8),
            Expanded(child: Text(p as String,
              style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
          ]),
        )),
      ]),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

// ─── Quiz ─────────────────────────────────────────────────────────────────────
class _QuizStep extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  const _QuizStep({super.key, required this.onComplete});
  @override
  State<_QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<_QuizStep> {
  int qi = 0;
  int? selected;
  bool answered = false;
  int _score = 0;

  final List<Map<String, dynamic>> questions = [
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Quiz Time! 🎯', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kGreen.withValues(alpha: 0.4))),
            child: Text('${qi + 1} / ${questions.length}',
              style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: _kGreen, fontSize: 13))),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: (qi + 1) / questions.length, minHeight: 6,
            backgroundColor: _kAccent.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation<Color>(_kAccent))),
        const SizedBox(height: 20),
        _DarkCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(q['question'] as String, textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
        const SizedBox(height: 16),
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final bool isCorrect = i == correct;
          final bool isSelected = i == selected;
          Color bg = _kCard; Color border = _kAccent.withValues(alpha: 0.15); Color tc = Colors.white70;
          Widget? trailing;
          if (answered) {
            if (isCorrect) { bg = _kGreen.withValues(alpha: 0.12); border = _kGreen.withValues(alpha: 0.6); tc = _kGreen;
              trailing = const Icon(Icons.check_circle_rounded, color: _kGreen, size: 20); }
            else if (isSelected) { bg = _kRed.withValues(alpha: 0.12); border = _kRed.withValues(alpha: 0.6); tc = _kRed;
              trailing = const Icon(Icons.cancel_rounded, color: _kRed, size: 20); }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: answered ? null : () { SoundService.playClick(); setState(() { selected = i; answered = true; if (i == correct) _score++; }); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 1.5)),
                child: Row(children: [
                  Container(width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: answered && isCorrect ? _kGreen.withValues(alpha: 0.2) : _kAccent.withValues(alpha: 0.08),
                      border: Border.all(color: answered && isCorrect ? _kGreen : _kAccent.withValues(alpha: 0.3))),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13,
                        color: answered && isCorrect ? _kGreen : _kAccent.withValues(alpha: 0.7))))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: tc))),
                  if (trailing != null) trailing!,
                ]),
              ),
            ),
          );
        }),
        if (answered) ...[
          _TipBox(text: q['explanation'] as String),
          const SizedBox(height: 16),
          _NextButton(onTap: next, label: qi < questions.length - 1 ? 'Next Question →' : 'See Results! 🎉'),
        ],
      ]),
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

  int get _awardedXp {
    if (_stars == 3) return 150;
    if (_stars == 2) return (150 * 0.7).round();
    return (150 * 0.4).round();
  }

  String get _emoji {
    if (_stars == 3) return '🏆';
    if (_stars == 2) return '🎉';
    return '💪';
  }

  String get _title {
    if (_stars == 3) return 'Perfect Score!';
    if (_stars == 2) return 'Great Effort!';
    return 'Good Try!';
  }

  String get _subtitle {
    if (_stars == 3) return "You've completed Phishing Detective!";
    if (_stars == 2) return 'You got ${widget.score} out of ${widget.total} — solid work!';
    return 'You got ${widget.score} out of ${widget.total} — review the lessons and try again!';
  }

  String get _encouragement {
    if (_stars == 3) return 'You nailed every question! 🌟';
    if (_stars == 2) return 'Almost there — revisit the tricky bits to get full marks!';
    return "Don't give up — each attempt makes you smarter and safer online!";
  }

  Future<void> _finish(BuildContext ctx) async {
    if (claiming) return;
    if (_stars < 3) {
      await RetryDialog.show(ctx, lessonId: 'phishing_detective', score: widget.score, total: widget.total, onRetry: widget.onRetry);
      return;
    }
    setState(() => claiming = true);
    try {
      await UserService.instance.saveProgress(LessonProgress(
        lessonId: 'phishing_detective', stepsCompleted: 6, totalSteps: 6,
        stars: _stars, completed: true));
      if (!ctx.mounted) return;
      await XpAward.show(ctx, lessonId: 'phishing_detective', amount: 150);
      widget.onDone();
    } catch (e) { debugPrint('Error: $e'); widget.onDone(); }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
    child: Column(children: [
      Container(
        width: 110, height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [_stars == 3 ? const Color(0xFFFFD700) : _stars == 2 ? _kAccent : _kCard, _kBg],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: (_stars == 3 ? const Color(0xFFFFD700) : _stars == 2 ? _kAccent : Colors.white24).withValues(alpha: 0.6), width: 2),
        ),
        child: Center(child: Text(_emoji, style: const TextStyle(fontSize: 54))),
      ).animate().scale(curve: Curves.elasticOut),
      const SizedBox(height: 20),
      Text(_title, style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 8),
      Text(_subtitle, textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: 15, color: Colors.white54)),
      const SizedBox(height: 20),
      _DarkCard(child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              i < _stars ? '⭐' : '☆',
              style: TextStyle(fontSize: 32, color: i < _stars ? const Color(0xFFFFD700) : Colors.white12),
            ),
          ),
        )),
        const SizedBox(height: 10),
        Text(
          _stars == 3 ? '3 Stars — Amazing!' : _stars == 2 ? '2 Stars — Well Done!' : '1 Star — Keep Practising!',
          style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('+$_awardedXp XP', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFFFD700))),
          ])),

      ])),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _stars >= 2 ? _kGreen.withValues(alpha: 0.07) : _kAccent.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _stars >= 2 ? _kGreen.withValues(alpha: 0.3) : _kAccent.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Text(_stars >= 2 ? '🌟' : '📖', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(_encouragement,
            style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
        ]),
      ),
      const SizedBox(height: 16),
      _InfoCard(color: _kAccent, emoji: '🕵️', title: 'Badge Unlocked: Phishing Detective!',
        body: 'You can now spot a phishing attempt before it catches you!'),
      const SizedBox(height: 20),
      Align(alignment: Alignment.centerLeft,
        child: Text('WHAT YOU LEARNED', style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38, letterSpacing: 1.2))),
      const SizedBox(height: 10),
      const _SummaryTile(emoji: '🎣', text: 'What phishing is and how it works'),
      const _SummaryTile(emoji: '📧', text: 'How to spot fake emails and messages'),
      const _SummaryTile(emoji: '🔗', text: 'How to check suspicious links safely'),
      const _SummaryTile(emoji: '🛡️', text: 'What to do if you receive a phishing message'),
      const _SummaryTile(emoji: '💬', text: '3 real-life chat simulation scenarios'),
      const SizedBox(height: 28),
      _NextButton(
        onTap: () => _finish(context),
        enabled: _stars < 3 ? true : !claiming,
        label: _stars < 3 ? '🔄  Try Again' : (claiming ? 'Claiming...' : '🎉  Claim your XP!'),
      ),
    ]),
  );
}

class _LessonProgressBar extends StatelessWidget {
  final int current, total;
  const _LessonProgressBar({required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('PROGRESS', style: GoogleFonts.fredoka(fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
      Text('$current / $total', style: GoogleFonts.fredoka(fontSize: 11, color: _kAccent, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(value: current / total, minHeight: 7,
        backgroundColor: _kCyan.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(current == total ? _kGreen : _kCyan))),
  ]);
}

class _LessonLabel extends StatelessWidget {
  final String label;
  const _LessonLabel({required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.chevron_right_rounded, color: _kAccent, size: 16),
    const SizedBox(width: 4),
    Text(label, style: GoogleFonts.fredoka(color: _kAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
  ]);
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextButton({required this.onTap, this.label = 'Next →', this.enabled = true});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? () { SoundService.playClick(); onTap(); } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kAccent, foregroundColor: Colors.white,
        disabledBackgroundColor: _kCard, disabledForegroundColor: Colors.white24,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), elevation: 0),
      child: Text(label, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
    ),
  );
}

class _DarkCard extends StatelessWidget {
  final Widget child;
  const _DarkCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _kAccent.withValues(alpha: 0.2))),
    child: child,
  );
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const _InfoCard({required this.color, required this.emoji, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.3))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 26)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
      ])),
    ]),
  );
}

class _TipBox extends StatelessWidget {
  final String text;
  const _TipBox({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: _kAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _kAccent.withValues(alpha: 0.25))),
    child: Row(children: [
      const Text('💡', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

class _RedFlagCard extends StatelessWidget {
  final String flag, detail;
  const _RedFlagCard({required this.flag, required this.detail});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _kRed.withValues(alpha: 0.25))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: _kRed)),
      const SizedBox(height: 5),
      Text(detail, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
    ]),
  );
}

class _StepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const _StepCard({required this.number, required this.emoji, required this.title, required this.body, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.25))),
    child: Row(children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
      ])),
      Container(width: 26, height: 26, decoration: BoxDecoration(color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle, border: Border.all(color: color.withValues(alpha: 0.5))),
        child: Center(child: Text(number, style: GoogleFonts.fredoka(color: color, fontWeight: FontWeight.w700, fontSize: 12)))),
    ]),
  );
}

class _EmailCard extends StatelessWidget {
  final String from, subject, body, clue;
  final bool isReal;
  const _EmailCard({required this.from, required this.subject, required this.body, required this.clue, required this.isReal});
  @override
  Widget build(BuildContext context) {
    final Color c = isReal ? _kGreen : _kRed;
    return Container(
      decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.35))),
      child: Column(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Row(children: [
            Icon(isReal ? Icons.check_circle_rounded : Icons.warning_rounded, color: c, size: 14),
            const SizedBox(width: 6),
            Text(isReal ? '✅ Looks legitimate' : '❌ Suspicious',
              style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
          ])),
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('From: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
            Expanded(child: Text(from, style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: c))),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Text('Subject: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
            Expanded(child: Text(subject, style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white70))),
          ]),
          const SizedBox(height: 8),
          Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🔍 ', style: TextStyle(fontSize: 13)),
              Expanded(child: Text(clue, style: GoogleFonts.fredoka(fontSize: 12, color: c, height: 1.4))),
            ])),
        ])),
      ]),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label, link;
  final bool safe;
  const _LinkRow({required this.label, required this.link, required this.safe});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      SizedBox(width: 24, child: Text(label, style: const TextStyle(fontSize: 14))),
      const SizedBox(width: 8),
      Expanded(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: (safe ? _kGreen : _kRed).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(link, style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: safe ? _kGreen : _kRed)))),
    ]),
  );
}

class _SimpleRow extends StatelessWidget {
  final String emoji, text;
  const _SimpleRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

class _SummaryTile extends StatelessWidget {
  final String emoji, text;
  const _SummaryTile({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
      const Icon(Icons.check_circle_rounded, color: _kGreen, size: 18),
    ]),
  );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _kAccent.withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}