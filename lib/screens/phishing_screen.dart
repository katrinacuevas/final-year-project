import 'package:flutter/material.dart';

class PhishingDetectiveScreen extends StatefulWidget {
  const PhishingDetectiveScreen({super.key});

  @override
  State<PhishingDetectiveScreen> createState() => _PhishingDetectiveScreenState();
}

class _PhishingDetectiveScreenState extends State<PhishingDetectiveScreen> {
  int _scenarioIndex = 0;
  int _step = 0; 
  int? _choiceMade;
  bool _showFeedback = false;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'The Free Skin Trick 🎮',
      'messages': [
        {'from': 'stranger', 'text': 'Hey, nice work! You\'re pretty good for a new player 😊'},
        {'from': 'you',      'text': 'Thx, your outfit is awesome!'},
        {'from': 'stranger', 'text': 'Thx, I made most of it myself, I found a glitch to get it for freeee!!'},
        {'from': 'stranger', 'text': 'Its kind of complicated but i can do it if i log into your account for 2 mins :D'},
        {'from': 'you',      'text': '...'},
      ],
      'question': 'How do you respond?',
      'choices': [
        'OMG!! Yes :DD',
        'Cant you just tell me how ill try??',
        'No way im not doing that!',
      ],
      'correctIndex': 2,
      'feedback': [
        {
          'safe': false,
          'title': 'Uh-Oh! That choice would\'ve let a stranger into your account!',
          'points': [
            'Say NO if anyone asks for your password',
            'BLOCK the person',
            'REPORT them to keep others safe',
          ],
          'emoji': '😨',
        },
        {
          'safe': false,
          'title': 'Be careful! Asking how to do it yourself still shows you\'re interested.',
          'points': [
            'Never share or look for account glitches',
            'Real free items come from official sources only',
            'BLOCK and REPORT the person',
          ],
          'emoji': '😬',
        },
        {
          'safe': true,
          'title': 'Great job! You protected your account! 🎉',
          'points': [
            'Never give anyone access to your account',
            'Real games never need your login details',
            'You can also BLOCK and REPORT this person',
          ],
          'emoji': '🛡️',
        },
      ],
    },

    // ── SCENARIO 2: Prize phishing ──────────────────────────────────
    {
      'title': 'You\'ve Won a Prize! 🏆',
      'messages': [
        {'from': 'stranger', 'text': 'CONGRATULATIONS 🎉 You\'ve been selected as our 1,000,000th visitor!'},
        {'from': 'stranger', 'text': 'You\'ve won a £500 gift card! Click here to claim: bit.ly/cl4im-pr1ze'},
        {'from': 'you',      'text': 'Whoa really?? 😮'},
        {'from': 'stranger', 'text': 'Yes!! But you only have 10 minutes to claim or it expires. We just need your name, address and school name to send it 📦'},
        {'from': 'you',      'text': '...'},
      ],
      'question': 'What do you do?',
      'choices': [
        'Quick, send my details before time runs out!',
        'Ask my parent or teacher before doing anything',
        'Click the link to check if it\'s real',
      ],
      'correctIndex': 1,
      'feedback': [
        {
          'safe': false,
          'title': 'Watch out! This is a classic phishing trick!',
          'points': [
            'You never entered a competition — this is FAKE',
            'Countdown timers are used to rush you into mistakes',
            'Never share your address or school with strangers online',
          ],
          'emoji': '🚨',
        },
        {
          'safe': true,
          'title': 'Smart move! Always check with a trusted adult first! 🌟',
          'points': [
            'Real prizes don\'t pressure you with timers',
            'A trusted adult can spot scams more easily',
            'Never share personal info like your address online',
          ],
          'emoji': '🌟',
        },
        {
          'safe': false,
          'title': 'Never click unknown links — even to check!',
          'points': [
            'Dodgy links can install harmful software instantly',
            'Always ask a trusted adult before clicking anything suspicious',
            'If it sounds too good to be true, it usually is!',
          ],
          'emoji': '⚠️',
        },
      ],
    },

    {
      'title': 'A New Online Friend 🤝',
      'messages': [
        {'from': 'stranger', 'text': 'Hey! I go to your school. We\'re in different classes but I\'ve seen you around 😊'},
        {'from': 'you',      'text': 'Oh cool, what\'s your name?'},
        {'from': 'stranger', 'text': 'I\'m Jake! I love Minecraft too, saw it on your profile. Can we play sometime?'},
        {'from': 'stranger', 'text': 'Hey can you send me your phone number so we can chat off here? This app is annoying lol'},
        {'from': 'you',      'text': '...'},
      ],
      'question': 'What do you do?',
      'choices': [
        'Sure, here\'s my number! 📱',
        'Maybe later, let\'s just chat here for now',
        'I don\'t know you in real life, I\'m not sharing that',
      ],
      'correctIndex': 2,
      'feedback': [
        {
          'safe': false,
          'title': 'Be careful! This could be someone pretending to know you.',
          'points': [
            'Never share your phone number with online strangers',
            'People can lie about going to your school',
            'Tell a trusted adult about this conversation',
          ],
          'emoji': '😟',
        },
        {
          'safe': false,
          'title': 'Good instinct to wait, but you should be more firm!',
          'points': [
            'It\'s okay to say no clearly to people you don\'t know',
            'Real classmates can find you through school — not just online',
            'If unsure, check with a parent or teacher',
          ],
          'emoji': '🤔',
        },
        {
          'safe': true,
          'title': 'Brilliant! You stayed safe and set a firm boundary! 💪',
          'points': [
            'You can\'t verify who people really are online',
            'It\'s always okay to say no to sharing personal info',
            'Tell a trusted adult if someone keeps pushing you',
          ],
          'emoji': '💪',
        },
      ],
    },
  ];

  Map<String, dynamic> get _current => _scenarios[_scenarioIndex];
  List<dynamic> get _messages => _current['messages'] as List;
  int get _totalMessages => _messages.length;

  void _nextMessage() {
    if (_step < _totalMessages - 1) {
      setState(() => _step++);
    }
  }

  void _makeChoice(int index) {
    setState(() {
      _choiceMade = index;
      _showFeedback = true;
    });
  }

  void _nextScenario() {
    if (_scenarioIndex < _scenarios.length - 1) {
      setState(() {
        _scenarioIndex++;
        _step = 0;
        _choiceMade = null;
        _showFeedback = false;
      });
    } else {
      // all scenarios done
      Navigator.pop(context);
    }
  }

  bool get _allMessagesShown => _step >= _totalMessages - 1;
  bool get _isLastScenario => _scenarioIndex == _scenarios.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2E45)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phishing Detective',
              style: TextStyle(color: Color(0xFF1A2E45), fontWeight: FontWeight.w800, fontSize: 17)),
            Text('Scenario ${_scenarioIndex + 1} of ${_scenarios.length}',
              style: const TextStyle(color: Color(0xFF7A9BB5), fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFDEEAF8), borderRadius: BorderRadius.circular(20)),
                child: Text('🔍 ${_scenarioIndex + 1}/${_scenarios.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A90D9), fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // scenario title strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(children: [
              const Text('🎯', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(_current['title'] as String,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
            ]),
          ),

          // chat area
          Expanded(
            child: GestureDetector(
              onTap: _allMessagesShown || _showFeedback ? null : _nextMessage,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  // render visible messages
                  for (int i = 0; i <= _step; i++)
                    _buildMessage(_messages[i] as Map<String, dynamic>, i),

                  // tap hint
                  if (!_allMessagesShown && !_showFeedback)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Tap to continue the chat...',
                            style: TextStyle(fontSize: 12, color: Color(0xFF9AABBF), fontStyle: FontStyle.italic)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // bottom panel
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
            child: _showFeedback
              ? _buildFeedbackPanel()
              : _allMessagesShown
                ? _buildChoicesPanel()
                : const SizedBox(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg, int index) {
    final bool isYou = msg['from'] == 'you';
    final bool isTyping = msg['text'] == '...';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isYou) ...[
            _Avatar(isYou: false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: isTyping
                ? const EdgeInsets.symmetric(horizontal: 18, vertical: 14)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isYou ? const Color(0xFF4A90D9) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isYou ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isYou ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: isTyping
                ? _TypingDots()
                : Text(
                    msg['text'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: isYou ? Colors.white : const Color(0xFF1A2E45),
                      height: 1.4,
                    ),
                  ),
            ),
          ),
          if (isYou) ...[
            const SizedBox(width: 8),
            _Avatar(isYou: true),
          ],
        ],
      ),
    );
  }

  Widget _buildChoicesPanel() {
    final List<String> choices = List<String>.from(_current['choices'] as List);
    return Container(
      key: const ValueKey('choices'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const Text('💬', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(_current['question'] as String,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          ]),
          const SizedBox(height: 14),
          ...choices.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => _makeChoice(e.key),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD0DFF0), width: 1.5),
                ),
                child: Row(children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90D9).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('${e.key + 1}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF4A90D9)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2E45)))),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeedbackPanel() {
    final feedbacks = _current['feedback'] as List;
    final feedback = feedbacks[_choiceMade!] as Map<String, dynamic>;
    final bool safe = feedback['safe'] as bool;
    final List<String> points = List<String>.from(feedback['points'] as List);

    return Container(
      key: const ValueKey('feedback'),
      decoration: BoxDecoration(
        color: safe ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // title row
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(feedback['emoji'] as String, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(feedback['title'] as String,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: safe ? const Color(0xFF1E6B3A) : const Color(0xFFB03030),
                )),
            ),
          ]),
          const SizedBox(height: 14),

          // bullet points
          ...points.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: safe ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(p,
                style: TextStyle(
                  fontSize: 13,
                  color: safe ? const Color(0xFF1A4A2A) : const Color(0xFF7A2020),
                  height: 1.4,
                ))),
            ]),
          )),
          const SizedBox(height: 16),

          // next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextScenario,
              style: ElevatedButton.styleFrom(
                backgroundColor: safe ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                _isLastScenario ? '🏆 Finish Lesson' : 'Next Scenario →',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool isYou;
  const _Avatar({required this.isYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFFDEEAF8) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.person, size: 22,
          color: isYou ? const Color(0xFF4A90D9) : Colors.grey.shade500),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final double offset = ((_controller.value * 3) - i).clamp(0.0, 1.0);
            final double size = 6 + (offset < 0.5 ? offset : 1 - offset) * 4;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF9AABBF),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}