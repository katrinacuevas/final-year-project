// pretexting_chat_sim.dart
// 3-scenario chat simulation for the Pretexting Detective course.
// Cat gives all feedback — no separate feedback boxes.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:characters/characters.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../services/sound_service.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';

class PretextingChatSim extends StatefulWidget {
  final VoidCallback onNext;
  const PretextingChatSim({super.key, required this.onNext});
  @override
  State<PretextingChatSim> createState() => _PretextingChatSimState();
}

class _PretextingChatSimState extends State<PretextingChatSim> {
  int scenarioIndex = 0;
  int visibleMsgCount = 0;
  int? choice;
  bool showFeedback = false;
  bool isTyping = false;
  bool choicePhase = false;
  Timer? _msgTimer;
  final ScrollController _scrollCtrl = ScrollController();

  static const List<Map<String, dynamic>> scenarios = [
    {
      'title': 'The "IT Teacher"',
      'roomName': 'MrDavies_ITSupport',
      'roomAvatar': '🖥️',
      'strangerEmoji': '🧑‍💻',
      'strangerColour': '0xFF1565C0',
      'messages': [
        {
          'from': 'stranger',
          'text': 'Hi! I\'m Mr Davies, the new IT cover teacher. I\'m doing a quick account check today 🖥️',
          'delay': 700
        },
        {'from': 'you', 'text': 'Oh… okay?', 'delay': 1200},
        {
          'from': 'stranger',
          'text': 'I just need to check your school login. Can you send me your username and password? It\'ll only take a second!',
          'delay': 1400
        },
        {
          'from': 'stranger',
          'text': 'Don\'t worry, it\'s totally normal — I just need to confirm everything is working for you 😊',
          'delay': 1200
        },
      ],
      'question': 'What do you do?',
      'choices': [
        'Sure! My username is jamie123 and my password is...',
        'I\'ll give you my username but NOT my password',
        'I don\'t share my login with anyone — I\'ll check with my real teacher first',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'catMessage':
              'Uh oh! 😿 Real IT teachers NEVER need your password — they have special tools to fix accounts! By sharing it, you handed over the keys to your account. Always verify who you\'re talking to first! 🔑'
        },
        {
          'safe': false,
          'catMessage':
              'Better — but still risky! 😼 Your username on its own can still be misused, and a real IT teacher would never ask this way. The safest answer is always to check with a trusted grown-up first! 🛡️'
        },
        {
          'safe': true,
          'catMessage':
              'Amazing! 🎉 IT staff NEVER need your password — they have their own admin tools! You spotted the pretext AND used the PAUSE rule. That\'s exactly what a Pretexting Detective does! 🕵️😸'
        },
      ],
    },
    {
      'title': 'The "Old Friend"',
      'roomName': 'Mia_PrimarySchool',
      'roomAvatar': '👧',
      'strangerEmoji': '🕵️',
      'strangerColour': '0xFF6A1B9A',
      'messages': [
        {
          'from': 'stranger',
          'text': 'Heyyy! It\'s Mia from your old primary school! 😄 Remember me??',
          'delay': 700
        },
        {
          'from': 'you',
          'text': 'Hmm… I think so? It\'s been ages!',
          'delay': 1200
        },
        {
          'from': 'stranger',
          'text': 'Yes! We were in Year 3 together! I\'ve been trying to find everyone. Can I add you on Instagram?',
          'delay': 1400
        },
        {
          'from': 'stranger',
          'text': 'Also — do you still live near Maple Road? I want to post you a birthday card! 🎂',
          'delay': 1300
        },
      ],
      'question': 'How do you respond?',
      'choices': [
        'Yes I\'m on Instagram! And I still live near Maple Road 😊',
        'I\'ll add you on Instagram but I\'m not giving my address',
        'I don\'t really remember you — I\'m not sharing anything until I\'ve checked with a grown-up',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'catMessage':
              'Oh no! 🚨 You just gave your home area to someone you can\'t verify! Pretexters build trust first, then collect info step by step. NEVER confirm your address to anyone online without checking with a grown-up! 🏠'
        },
        {
          'safe': false,
          'catMessage':
              'Good call on the address! 😼 But adding an unverified stranger on social media is still risky — they could find out a lot about you from your posts. Check with a parent before adding anyone you can\'t really remember! 👀'
        },
        {
          'safe': true,
          'catMessage':
              'Perfect! 🛡️ You didn\'t confirm your address OR add a stranger online. Checking with a grown-up is always the right move. And if it really WAS an old friend — a real friend would totally understand you being careful! 😸'
        },
      ],
    },
    {
      'title': 'The "Game Moderator"',
      'roomName': 'RobloxMod_Official',
      'roomAvatar': '🎮',
      'strangerEmoji': '👾',
      'strangerColour': '0xFFB71C1C',
      'messages': [
        {
          'from': 'stranger',
          'text': '⚠️ URGENT: Your Roblox account has been reported. I\'m from the Roblox Moderation Team.',
          'delay': 700
        },
        {
          'from': 'you',
          'text': 'What?! I didn\'t do anything wrong!',
          'delay': 1200
        },
        {
          'from': 'stranger',
          'text': 'Don\'t worry — just send me your username and password so we can verify it\'s really you. We\'ll clear your account in 5 minutes! ⏰',
          'delay': 1500
        },
        {
          'from': 'stranger',
          'text': 'Hurry! Accounts that don\'t verify get banned in 10 minutes. You don\'t want to lose all your Robux, right? 😬',
          'delay': 1300
        },
      ],
      'question': 'What do you do?',
      'choices': [
        'Okay okay! My username is jamie123 and my password is...',
        'I\'ll send my username but NOT my password',
        'I\'m not sending anything — I\'ll check the real Roblox site and tell a grown-up',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'catMessage':
              'Oh no! 😿 This is the oldest trick in the book — PANIC + RUSH = bad decisions! Real game companies NEVER ask for your password in a DM. By sharing it, you\'ve handed over your whole account. Always stop and PAUSE! 🎮'
        },
        {
          'safe': false,
          'catMessage':
              'Good thinking on the password! 😼 But real Roblox moderators NEVER contact players this way at all — not even for your username. The "10 minute ban" is made up to scare you. Always check the real website and ask a grown-up! 🛡️'
        },
        {
          'safe': true,
          'catMessage':
              'Brilliant! 🕵️😸 You spotted the FAKE URGENCY trick — rushing you so you panic and don\'t think straight! Real game companies fix accounts without ever needing your password. You used PAUSE perfectly. Now... Quiz Time! 🎯'
        },
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
    setState(() {
      choice = index;
      showFeedback = true;
    });
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
              style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: kPretextAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPretextAccent.withValues(alpha: 0.4)),
            ),
            child: Text('${scenarioIndex + 1} / ${scenarios.length}',
                style: GoogleFonts.fredoka(
                    color: kPretextAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
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
            ...(msgs.sublist(0, visibleMsgCount) as List).map((m) {
              final bool isYou = (m as Map)['from'] == 'you';
              return _AnimatedChatBubble(
                key: ValueKey('${scenarioIndex}_${msgs.indexOf(m)}'),
                text: m['text'] as String,
                isYou: isYou,
                senderName: isYou ? 'You' : scenario['roomName'] as String,
                scrollCtrl: _scrollCtrl,
                userEmoji:
                    UserService.instance.profile?.avatarEmoji ?? '🧒',
                userColour: Color(int.parse(
                    UserService.instance.profile?.avatarColour ??
                        '0xFF00D1FF')),
                strangerEmoji: scenario['strangerEmoji'] as String,
                strangerColour:
                    Color(int.parse(scenario['strangerColour'] as String)),
              );
            }),
            if (isTyping)
              _TypingIndicator(
                key: ValueKey('typing_$scenarioIndex'),
                strangerColour: Color(
                    int.parse(scenario['strangerColour'] as String)),
              ),
            if (choicePhase && !showFeedback) ...[
              const SizedBox(height: 8),
              _ChoicePrompt(
                question: scenario['question'] as String,
                choices: scenario['choices'] as List,
                onSelect: _selectChoice,
              ),
            ],
            if (showFeedback && fb != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: PretextingCatButton(
                  button: PretextingNextButton(
                    onTap: _nextScenario,
                    label: isLastScenario ? 'Quiz Time! 🎯' : 'Next Scenario →',
                  ),
                  message: fb['catMessage'] as String,
                  accentColor:
                      (fb['safe'] as bool) ? kPretextGreen : kPretextRed,
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

// ─── Chat Room Header ─────────────────────────────────────────────────────────
class _ChatRoomHeader extends StatelessWidget {
  final String roomName, avatar, title;
  const _ChatRoomHeader(
      {required this.roomName, required this.avatar, required this.title});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kPretextAccent.withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPretextAccent.withValues(alpha: 0.1),
              border: Border.all(
                  color: kPretextAccent.withValues(alpha: 0.4)),
            ),
            child: Center(
                child: Text(avatar, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text(roomName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fredoka(
                    fontSize: 11, color: Colors.white38)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kPretextRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kPretextRed.withValues(alpha: 0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: kPretextRed)),
              const SizedBox(width: 5),
              Text('LIVE',
                  style: GoogleFonts.fredoka(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: kPretextRed)),
            ]),
          ),
        ]),
      );
}

// ─── Animated Chat Bubble ─────────────────────────────────────────────────────
class _AnimatedChatBubble extends StatefulWidget {
  final String text, senderName;
  final bool isYou;
  final ScrollController scrollCtrl;
  final String userEmoji, strangerEmoji;
  final Color userColour, strangerColour;
  const _AnimatedChatBubble({
    super.key,
    required this.text,
    required this.isYou,
    required this.senderName,
    required this.scrollCtrl,
    required this.userEmoji,
    required this.userColour,
    required this.strangerEmoji,
    required this.strangerColour,
  });
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
  List<String> _chars = [];

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _fade = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(widget.isYou ? 0.12 : -0.12, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
    _startTyping();
  }

  void _startTyping() {
    _chars = widget.text.characters.toList();
    final int msPerChar = widget.isYou ? 22 : 28;
    final int startDelay = widget.isYou ? 300 : 0;
    Future.delayed(Duration(milliseconds: startDelay), () {
      if (!mounted) return;
      _typeTimer = Timer.periodic(Duration(milliseconds: msPerChar), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        if (_charIndex >= _chars.length) {
          t.cancel();
          return;
        }
        _charIndex++;
        setState(
            () => _displayed = _chars.sublist(0, _charIndex).join());
        if (_charIndex % 5 == 0 && widget.scrollCtrl.hasClients) {
          widget.scrollCtrl.animateTo(
            widget.scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOut,
          );
        }
      });
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
    final Color avatarCol =
        widget.isYou ? widget.userColour : widget.strangerColour;
    final String avatarEmoji =
        widget.isYou ? widget.userEmoji : widget.strangerEmoji;
    final String label = widget.isYou
        ? 'You'
        : (widget.senderName.characters.length > 18
            ? '${widget.senderName.characters.take(18)}...'
            : widget.senderName);

    final Widget avatar = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarCol.withValues(alpha: 0.18),
        border: Border.all(
            color: avatarCol.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Center(
          child:
              Text(avatarEmoji, style: const TextStyle(fontSize: 18))),
    );

    final Widget bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isYou
            ? widget.userColour.withValues(alpha: 0.12)
            : kPretextCard,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(widget.isYou ? 18 : 4),
          bottomRight: Radius.circular(widget.isYou ? 4 : 18),
        ),
        border: Border.all(
          color: widget.isYou
              ? widget.userColour.withValues(alpha: 0.35)
              : widget.strangerColour.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Stack(children: [
        Text(widget.text,
            style: GoogleFonts.fredoka(
                fontSize: 14, color: Colors.transparent, height: 1.45)),
        Text(_displayed,
            style: GoogleFonts.fredoka(
                fontSize: 14, color: Colors.white, height: 1.45)),
      ]),
    );

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: widget.isYou
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 4, left: 44, right: 44),
                child: Text(label,
                    style: GoogleFonts.fredoka(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: avatarCol.withValues(alpha: 0.7))),
              ),
              Row(
                mainAxisAlignment: widget.isYou
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: widget.isYou
                    ? [
                        Flexible(child: bubble),
                        const SizedBox(width: 8),
                        avatar
                      ]
                    : [
                        avatar,
                        const SizedBox(width: 8),
                        Flexible(child: bubble)
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  final Color strangerColour;
  const _TypingIndicator({super.key, required this.strangerColour});
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
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
    _dotAnims = List.generate(
        3,
        (i) => Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: _ctrl,
            curve:
                Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut))));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 50),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kPretextCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                  color: kPretextAccent.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  3,
                  (i) => AnimatedBuilder(
                        animation: _dotAnims[i],
                        builder: (_, __) => Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 3),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.strangerColour.withValues(
                                alpha: 0.3 + 0.6 * _dotAnims[i].value),
                          ),
                        ),
                      )),
            ),
          ),
        ]),
      );
}

// ─── Choice Prompt ────────────────────────────────────────────────────────────
class _ChoicePrompt extends StatelessWidget {
  final String question;
  final List choices;
  final ValueChanged<int> onSelect;
  const _ChoicePrompt(
      {required this.question,
      required this.choices,
      required this.onSelect});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: kPretextAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: kPretextAccent.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            const Text('🤔', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(question,
                    style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white))),
          ]),
        ),
        ...choices.asMap().entries.map(
              (e) => GestureDetector(
                onTap: () => onSelect(e.key),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: kPretextCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: kPretextAccent.withValues(alpha: 0.25),
                        width: 1.5),
                  ),
                  child: Row(children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPretextAccent.withValues(alpha: 0.1),
                        border: Border.all(
                            color: kPretextAccent.withValues(alpha: 0.4)),
                      ),
                      child: Center(
                          child: Text(['A', 'B', 'C'][e.key],
                              style: GoogleFonts.fredoka(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: kPretextAccent))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(e.value as String,
                            style: GoogleFonts.fredoka(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70))),
                  ]),
                ).animate().fadeIn(delay: Duration(milliseconds: e.key * 100)).slideX(begin: 0.05),
              ),
            ),
      ]);
}
