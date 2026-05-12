import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/user_service.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';
import 'phishing_cat_messages.dart';

// ─── Chat Simulation ──────────────────────────────────────────────────────────

class PhishingChatSimActivity extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingChatSimActivity({super.key, required this.onNext});
  @override
  State<PhishingChatSimActivity> createState() => _PhishingChatSimActivityState();
}

class _PhishingChatSimActivityState extends State<PhishingChatSimActivity> {
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
      'strangerEmoji': '😈',
      'strangerColour': '0xFFE53935',
      'messages': [
        {'from': 'stranger', 'text': 'Hey!! I found a glitch that gives unlimited Robux 💎 Want some for free?', 'delay': 600},
        {'from': 'you',      'text': 'Wait... really?? 😮',                                                       'delay': 1200},
        {'from': 'stranger', 'text': 'Yeah! Just log in here 👉 r0blox-free.xyz and I\'ll send 10,000 to you 🤑', 'delay': 1400},
        {'from': 'stranger', 'text': 'But you have to do it in the next 10 mins or the link expires!! ⏰',         'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': ['Quick — log in before time runs out!', 'Ask them to prove it first', 'This looks fake — I\'m NOT clicking that'],
      'correct': 2,
    },
    {
      'title': 'Prize Winner Text',
      'roomName': 'Competition_Centre',
      'roomAvatar': '🏆',
      'strangerEmoji': '🤑',
      'strangerColour': '0xFFFFA000',
      'messages': [
        {'from': 'stranger', 'text': 'Congratulations! 🎉 You\'ve been selected as this week\'s prize winner!', 'delay': 600},
        {'from': 'you',      'text': 'Oh wow — I didn\'t enter anything though... 🤔',                          'delay': 1200},
        {'from': 'stranger', 'text': 'You were auto-entered when you signed up. Just confirm your details to claim your £500 Amazon voucher!', 'delay': 1400},
        {'from': 'stranger', 'text': 'Click here to verify: amaz0n-prizes.com/confirm 🎁',                       'delay': 1100},
      ],
      'question': 'What do you do?',
      'choices': ['Fill in my details — free £500 sounds amazing!', 'Ignore it — I didn\'t enter any competition', 'Reply asking which competition it is'],
      'correct': 1,
    },
    {
      'title': 'Fake Tech Support',
      'roomName': 'Microsoft_Support',
      'roomAvatar': '💻',
      'strangerEmoji': '🤖',
      'strangerColour': '0xFF1565C0',
      'messages': [
        {'from': 'stranger', 'text': 'ALERT: Your device has been compromised. We\'ve detected unusual activity on your account.', 'delay': 600},
        {'from': 'you',      'text': 'What?! How do I fix it?',                                                                     'delay': 1200},
        {'from': 'stranger', 'text': 'Our engineer needs remote access to clean the virus. Download this tool and give us the code: fixpc-now.ru/download', 'delay': 1600},
        {'from': 'stranger', 'text': 'Act fast — the virus is spreading RIGHT NOW. Every minute counts! 🚨',                        'delay': 1200},
      ],
      'question': 'What do you do?',
      'choices': ['Download the tool quickly — my computer might be infected!', 'Ask a parent or trusted adult before doing anything', 'Tell them to fix it without needing access to my computer'],
      'correct': 1,
      'feedback': [
        {'safe': false, 'emoji': '🚨', 'title': 'This is a vishing scam!',
          'points': ['Real tech companies NEVER contact you out of the blue like this', 'Downloading that "tool" would actually install malware on your device', 'The panic and urgency is designed to stop you thinking — always slow down!']},
        {'safe': true, 'emoji': '✅', 'title': 'Perfect! You stayed safe!',
          'points': ['Telling a trusted adult first is always the right call', 'Real Microsoft or Apple support never contacts you randomly to say you have a virus', 'The link "fixpc-now.ru" is clearly not an official Microsoft address']},
        {'safe': false, 'emoji': '⚠️', 'title': 'Getting closer, but still risky!',
          'points': ['This approach still keeps you engaged with the scammer', 'They\'ll just try another convincing argument', 'The best move is to stop the conversation entirely and tell a trusted adult']},
      ],
    },
  ];

  Map<String, dynamic> get scenario => scenarios[scenarioIndex];
  List<Map<String, dynamic>> get msgs =>
      List<Map<String, dynamic>>.from(scenario['messages'] as List);
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
    final msg = msgs[visibleMsgCount];
    final String text = msg['text'] as String;
    final int delay = msg['delay'] as int;
    final bool isStranger = msg['from'] == 'stranger';
    final int typeDuration = isStranger ? text.length * 28 : 0;

    if (isStranger) {
      setState(() => isTyping = true);
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() { isTyping = false; visibleMsgCount++; });
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
    final bool isCorrect =
      showFeedback && (choice == (scenario['correct'] as int));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Chat Simulation 💬',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: kPhishingAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4)),
            ),
            child: Text('${scenarioIndex + 1} / ${scenarios.length}',
              style: GoogleFonts.fredoka(color: kPhishingAccent, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ]),
      ),
      const SizedBox(height: 10),
      _PhishingChatRoomHeader(
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
              return _PhishingAnimatedChatBubble(
                key: ValueKey('${scenarioIndex}_${msgs.indexOf(m)}'),
                text: m['text'] as String,
                isYou: isYou,
                senderName: isYou ? 'You' : scenario['roomName'] as String,
                scrollCtrl: _scrollCtrl,
                userEmoji: UserService.instance.profile?.avatarEmoji ?? '🧒',
                userColour: Color(int.parse(
                    UserService.instance.profile?.avatarColour ?? '0xFF00D1FF')),
                strangerEmoji: scenario['strangerEmoji'] as String,
                strangerColour: Color(int.parse(scenario['strangerColour'] as String)),
              );
            }),
            if (isTyping)
              _PhishingTypingIndicator(
                key: ValueKey('typing_$scenarioIndex'),
                strangerColour: Color(int.parse(scenario['strangerColour'] as String)),
              ),
            if (choicePhase && !showFeedback) ...[
              const SizedBox(height: 8),
              _PhishingChoicePrompt(
                question: scenario['question'] as String,
                choices: scenario['choices'] as List,
                onSelect: _selectChoice,
              ),
            ],
            if (showFeedback) ...[
              const SizedBox(height: 12),
              PhishingCatButton(
                button: PhishingNextButton(
                  onTap: _nextScenario,
                  label: isLastScenario ? 'Take the Quiz! 🎯' : 'Next Scenario →',
                ),
                message: PhishingCatMessages.chatFeedback(
                  scenarioIndex,
                  isCorrect,
                ),
              ),
            ],
          ],
        ),
      ),
    ]);
  }
}

// ─── Chat Room Header ─────────────────────────────────────────────────────────

class _PhishingChatRoomHeader extends StatelessWidget {
  final String roomName, avatar, title;
  const _PhishingChatRoomHeader({required this.roomName, required this.avatar, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPhishingAccent.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: kPhishingCard,
            shape: BoxShape.circle,
            border: Border.all(color: kPhishingAccent.withValues(alpha: 0.3)),
          ),
          child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(roomName,
            style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(title,
            style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: kPhishingRed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kPhishingRed.withValues(alpha: 0.4)),
          ),
          child: Text('⚠️ Suspicious',
            style: GoogleFonts.fredoka(fontSize: 10, fontWeight: FontWeight.w700, color: kPhishingRed)),
        ),
      ]),
    );
  }
}

// ─── Animated Chat Bubble ─────────────────────────────────────────────────────

class _PhishingAnimatedChatBubble extends StatefulWidget {
  final String text, senderName, userEmoji, strangerEmoji;
  final bool isYou;
  final Color userColour, strangerColour;
  final ScrollController scrollCtrl;
  const _PhishingAnimatedChatBubble({
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
  State<_PhishingAnimatedChatBubble> createState() => _PhishingAnimatedChatBubbleState();
}

class _PhishingAnimatedChatBubbleState extends State<_PhishingAnimatedChatBubble> {
  String _displayed = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isYou) {
      _displayed = widget.text;
    } else {
      _typewrite();
    }
  }

  void _typewrite() {
    final chars = widget.text.characters.toList();
    int i = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 28), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i >= chars.length) { t.cancel(); return; }
      setState(() => _displayed += chars[i]);
      i++;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollCtrl.hasClients) {
          widget.scrollCtrl.animateTo(
            widget.scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.isYou ? widget.userColour : widget.strangerColour;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!widget.isYou) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.2),
                border: Border.all(color: accent.withValues(alpha: 0.5)),
              ),
              child: Center(child: Text(widget.strangerEmoji, style: const TextStyle(fontSize: 14))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isYou ? accent.withValues(alpha: 0.2) : kPhishingCard,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(widget.isYou ? 16 : 4),
                  bottomRight: Radius.circular(widget.isYou ? 4 : 16),
                ),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Text(_displayed,
                style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45)),
            ),
          ),
          if (widget.isYou) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.userColour.withValues(alpha: 0.2),
                border: Border.all(color: widget.userColour.withValues(alpha: 0.5)),
              ),
              child: Center(child: Text(widget.userEmoji, style: const TextStyle(fontSize: 14))),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0);
  }
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────

class _PhishingTypingIndicator extends StatefulWidget {
  final Color strangerColour;
  const _PhishingTypingIndicator({super.key, required this.strangerColour});
  @override
  State<_PhishingTypingIndicator> createState() => _PhishingTypingIndicatorState();
}

class _PhishingTypingIndicatorState extends State<_PhishingTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.strangerColour.withValues(alpha: 0.2),
            border: Border.all(color: widget.strangerColour.withValues(alpha: 0.5)),
          ),
          child: const Center(child: Text('💬', style: TextStyle(fontSize: 14))),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: kPhishingCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.strangerColour.withValues(alpha: 0.3)),
          ),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return Row(mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final double offset = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
                  final double size = 6 + 3 * (offset < 0.5 ? offset * 2 : (1 - offset) * 2);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.4 + 0.4 * (offset < 0.5 ? offset * 2 : (1 - offset) * 2)),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ]),
    ).animate().fadeIn(duration: 200.ms);
  }
}

// ─── Choice Prompt ────────────────────────────────────────────────────────────

class _PhishingChoicePrompt extends StatelessWidget {
  final String question;
  final List choices;
  final void Function(int) onSelect;
  const _PhishingChoicePrompt({required this.question, required this.choices, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kPhishingAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPhishingAccent.withValues(alpha: 0.25)),
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
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: kPhishingCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kPhishingAccent.withValues(alpha: 0.25), width: 1.5),
            ),
            child: Row(children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPhishingAccent.withValues(alpha: 0.1),
                  border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4)),
                ),
                child: Center(child: Text(['A', 'B', 'C'][e.key],
                  style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: kPhishingAccent))),
              ),
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