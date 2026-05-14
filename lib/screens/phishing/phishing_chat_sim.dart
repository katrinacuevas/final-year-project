// phishing_chat_sim.dart
// Interactive chat simulation — user reads 3 phishing scenarios and picks
// how to respond. Each scenario has right/wrong feedback.

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';

class PhishingChatSim extends StatefulWidget {
  final VoidCallback onNext;
  const PhishingChatSim({super.key, required this.onNext});
  @override
  State<PhishingChatSim> createState() => _PhishingChatSimState();
}

class _PhishingChatSimState extends State<PhishingChatSim> {
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
      'feedback': [
        {'safe': false, 'catMessage': 'Oh no! 😿 "r0blox-free.xyz" swaps the "o" for a zero — that\'s a fake site! Free Robux don\'t exist, it\'s always a trap. 🎣'},
        {'safe': false, 'catMessage': 'Hmm! 🤔 Scammers can fake proof really easily. Exit the chat and tell a trusted adult instead! 🙋'},
        {'safe': true,  'catMessage': 'Amazing detective work! 🎉 You spotted the dodgy link AND ignored the countdown pressure. No real game gives away free currency — you\'re a natural! 🕵️😸'},
      ],
    },
    {
      'title': 'School Email Alert',
      'roomName': 'school-notifications@sch00l-help.com',
      'roomAvatar': '🏫',
      'strangerEmoji': '🦹',
      'strangerColour': '0xFF1565C0',
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
        {'safe': false, 'catMessage': 'Uh oh! 😿 Real schools never threaten to delete accounts like that. "school-help-verify.com" is a fake site — your password would\'ve been stolen! 🔑'},
        {'safe': false, 'catMessage': 'Good suspicion! 🤔 But replying tells the scammer your email is active. Walk up to your teacher in person instead — much safer! 🚶'},
        {'safe': true,  'catMessage': 'Purrfect! 😸 You spotted the urgency trick and checked in person. That\'s exactly what a phishing detective does! 🕵️🎉'},
      ],
    },
    {
      'title': 'Gaming Chat Support',
      'roomName': 'MC_Support_Official',
      'roomAvatar': '⛏️',
      'strangerEmoji': '🤖',
      'strangerColour': '0xFF6A1B9A',
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
        {'safe': false, 'catMessage': 'Yikes! 🙀 Real game companies never DM players with free offers. "mc-support-verify.net" is fake — logging in hands your account straight to the scammer! 😱'},
        {'safe': true,  'catMessage': 'Really smart! 😸 Asking a trusted adult is always a right call. Two sets of eyes are better than one! 🎉'},
        {'safe': true,  'catMessage': 'Brilliant! 🕵️ Real companies don\'t send random DMs, and that countdown was just pressure to rush you. Blocking them protects other players too! 🛡️😸'},
      ],
    },
  ];

  Map<String, dynamic> get scenario => scenarios[scenarioIndex];
  List get msgs => scenario['messages'] as List;
  bool get isLastScenario => scenarioIndex == scenarios.length - 1;

  @override
  void initState() { super.initState(); _startScenario(); }

  @override
  void dispose() { _msgTimer?.cancel(); _scrollCtrl.dispose(); super.dispose(); }

  void _startScenario() {
    setState(() { visibleMsgCount = 0; isTyping = false; choicePhase = false; choice = null; showFeedback = false; });
    _scheduleNextMessage();
  }

  void _scheduleNextMessage() {
    if (visibleMsgCount >= msgs.length) { setState(() => choicePhase = true); return; }
    final msg = msgs[visibleMsgCount] as Map;
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
        _msgTimer = Timer(Duration(milliseconds: typeDuration + 120), () { if (!mounted) return; _scheduleNextMessage(); });
      });
    } else {
      _msgTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;
        setState(() => visibleMsgCount++);
        _scrollToBottom();
        _msgTimer = Timer(const Duration(milliseconds: 150), () { if (!mounted) return; _scheduleNextMessage(); });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _selectChoice(int index) {
    final fb = (scenario['feedback'] as List)[index] as Map<String, dynamic>;
    if (fb['safe'] as bool) {
      SoundService.playCatHappy();
    } else {
      SoundService.playCatIncorrect();
    }
    setState(() { choice = index; showFeedback = true; });
  }

  void _nextScenario() {
    SoundService.playClick();
    _msgTimer?.cancel();
    if (isLastScenario) { widget.onNext(); }
    else { setState(() => scenarioIndex++); _startScenario(); }
  }

  @override
  Widget build(BuildContext context) {
    final fb = showFeedback ? (scenario['feedback'] as List)[choice!] as Map<String, dynamic> : null;
    return Stack(children: [
    Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Chat Scenario 💬',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: kPhishingAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4))),
            child: Text('${scenarioIndex + 1} / ${scenarios.length}',
              style: GoogleFonts.fredoka(color: kPhishingAccent, fontWeight: FontWeight.w700, fontSize: 13))),
        ])),
      const SizedBox(height: 10),
      _ChatRoomHeader(roomName: scenario['roomName'] as String, avatar: scenario['roomAvatar'] as String, title: scenario['title'] as String),
      Expanded(child: ListView(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        children: [
          ...msgs.sublist(0, visibleMsgCount).map((m) {
            final bool isYou = m['from'] == 'you';
            return _AnimatedChatBubble(
              key: ValueKey('${scenarioIndex}_${msgs.indexOf(m)}'),
              text: m['text'] as String, isYou: isYou,
              senderName: isYou ? 'You' : scenario['roomName'] as String,
              scrollCtrl: _scrollCtrl,
              userEmoji: UserService.instance.profile?.avatarEmoji ?? '🧒',
              userColour: Color(int.parse(UserService.instance.profile?.avatarColour ?? '0xFF00D1FF')),
              strangerEmoji: scenario['strangerEmoji'] as String,
              strangerColour: Color(int.parse(scenario['strangerColour'] as String)),
            );
          }),
          if (isTyping) _TypingIndicator(key: ValueKey('typing_$scenarioIndex'),
            strangerColour: Color(int.parse(scenario['strangerColour'] as String))),
          if (choicePhase && !showFeedback) ...[
            const SizedBox(height: 8),
            _ChoicePrompt(question: scenario['question'] as String,
              choices: scenario['choices'] as List, onSelect: _selectChoice),
          ],
        ],
      )),
    ]),
      if (showFeedback && fb != null) ...[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: PhishingCatButton(
            button: PhishingNextButton(
              onTap: _nextScenario,
              label: isLastScenario ? 'Take the Quiz! 🎯' : 'Next Scenario →',
            ),
            message: fb['catMessage'] as String,
            accentColor: (fb['safe'] as bool) ? kPhishingGreen : kPhishingRed,
            showBubble: true,
            showButton: true,
            minHeight: 200,
          ),
        ),
      ],
    ]);
  }
}

// ─── Chat UI Components ───────────────────────────────────────────────────────

class _ChatRoomHeader extends StatelessWidget {
  final String roomName, avatar, title;
  const _ChatRoomHeader({required this.roomName, required this.avatar, required this.title});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: const Color(0xFF1A2035), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kPhishingAccent.withValues(alpha: 0.2))),
    child: Row(children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(shape: BoxShape.circle, color: kPhishingRed.withValues(alpha: 0.12),
          border: Border.all(color: kPhishingRed.withValues(alpha: 0.4))),
        child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(roomName, overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white38)),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: kPhishingRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kPhishingRed.withValues(alpha: 0.3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: kPhishingRed)),
          const SizedBox(width: 4),
          Text('UNKNOWN', style: GoogleFonts.fredoka(fontSize: 10, color: kPhishingRed, fontWeight: FontWeight.w700)),
        ])),
    ]),
  );
}

class _AnimatedChatBubble extends StatefulWidget {
  final String text, senderName;
  final bool isYou;
  final ScrollController scrollCtrl;
  final String userEmoji, strangerEmoji;
  final Color userColour, strangerColour;
  const _AnimatedChatBubble({super.key, required this.text, required this.isYou,
    required this.senderName, required this.scrollCtrl,
    required this.userEmoji, required this.userColour,
    required this.strangerEmoji, required this.strangerColour});
  @override
  State<_AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<_AnimatedChatBubble> with SingleTickerProviderStateMixin {
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
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _fade  = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: Offset(widget.isYou ? 0.12 : -0.12, 0), end: Offset.zero)
      .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
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
        if (!mounted) { t.cancel(); return; }
        if (_charIndex >= _chars.length) { t.cancel(); return; }
        _charIndex++;
        setState(() => _displayed = _chars.sublist(0, _charIndex).join());
        if (_charIndex % 5 == 0 && widget.scrollCtrl.hasClients) {
          widget.scrollCtrl.animateTo(widget.scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 80), curve: Curves.easeOut);
        }
      });
    });
  }

  @override
  void dispose() { _slideCtrl.dispose(); _typeTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final String label = widget.isYou ? 'You'
      : (widget.senderName.characters.length > 18 ? '${widget.senderName.characters.take(18)}...' : widget.senderName);
    final Color avatarCol = widget.isYou ? widget.userColour : widget.strangerColour;
    final String avatarEmoji = widget.isYou ? widget.userEmoji : widget.strangerEmoji;
    final bool typing = _displayed.isEmpty && _charIndex == 0;

    final Widget avatar = Container(width: 36, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, color: avatarCol.withValues(alpha: 0.18),
        border: Border.all(color: avatarCol.withValues(alpha: 0.5), width: 1.5)),
      child: Center(child: Text(avatarEmoji, style: const TextStyle(fontSize: 18))));

    final Widget bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isYou ? widget.userColour.withValues(alpha: 0.12) : kPhishingCard,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(widget.isYou ? 18 : 4),
          bottomRight: Radius.circular(widget.isYou ? 4 : 18)),
        border: Border.all(color: widget.isYou
          ? widget.userColour.withValues(alpha: 0.35)
          : widget.strangerColour.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: typing ? _InlineDots(color: avatarCol) : Stack(children: [
        Text(widget.text, style: GoogleFonts.fredoka(fontSize: 14, color: Colors.transparent, height: 1.45)),
        Text(_displayed, style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, height: 1.45)),
      ]),
    );

    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide,
      child: Padding(padding: const EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: widget.isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.only(bottom: 4, left: 44, right: 44),
            child: Text(label, style: GoogleFonts.fredoka(fontSize: 10, fontWeight: FontWeight.w600,
              color: avatarCol.withValues(alpha: 0.7)))),
          Row(mainAxisAlignment: widget.isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.isYou
              ? [Flexible(child: bubble), const SizedBox(width: 8), avatar]
              : [avatar, const SizedBox(width: 8), Flexible(child: bubble)]),
        ]),
      ),
    ));
  }
}

class _InlineDots extends StatefulWidget {
  final Color color;
  const _InlineDots({required this.color});
  @override
  State<_InlineDots> createState() => _InlineDotsState();
}

class _InlineDotsState extends State<_InlineDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _anims;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
    _anims = List.generate(3, (i) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut))));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => SizedBox(height: 20,
    child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
      AnimatedBuilder(animation: _anims[i], builder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3), width: 7, height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.4 + 0.6 * _anims[i].value)))))));
}

class _TypingIndicator extends StatefulWidget {
  final Color strangerColour;
  const _TypingIndicator({super.key, required this.strangerColour});
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _dotAnims;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
    _dotAnims = List.generate(3, (i) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut))));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, right: 50),
    child: Row(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: kPhishingCard,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18)),
          border: Border.all(color: kPhishingRed.withValues(alpha: 0.2))),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
          AnimatedBuilder(animation: _dotAnims[i], builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3), width: 7, height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: kPhishingRed.withValues(alpha: 0.3 + 0.6 * _dotAnims[i].value))))))),
    ]),
  );
}

class _ChoicePrompt extends StatelessWidget {
  final String question;
  final List choices;
  final ValueChanged<int> onSelect;
  const _ChoicePrompt({required this.question, required this.choices, required this.onSelect});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: kPhishingAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPhishingAccent.withValues(alpha: 0.25))),
      child: Row(children: [
        const Text('🤔', style: TextStyle(fontSize: 16)), const SizedBox(width: 8),
        Expanded(child: Text(question,
          style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
      ])),
    ...choices.asMap().entries.map((e) =>
      GestureDetector(onTap: () => onSelect(e.key),
        child: Container(margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: kPhishingCard, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kPhishingAccent.withValues(alpha: 0.25), width: 1.5)),
          child: Row(children: [
            Container(width: 26, height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kPhishingAccent.withValues(alpha: 0.1),
                border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4))),
              child: Center(child: Text(['A','B','C'][e.key],
                style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: kPhishingAccent)))),
            const SizedBox(width: 12),
            Expanded(child: Text(e.value as String,
              style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70))),
          ])),
      ).animate().fadeIn(delay: Duration(milliseconds: e.key * 100)).slideX(begin: 0.05)),
  ]);
}