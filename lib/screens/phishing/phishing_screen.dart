import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/xp_award.dart';
import 'phishing_chat_models.dart';
import 'phishing_chat.dart';
import 'phishing_choices.dart';
import 'phishing_feedback.dart';

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

  PhishingScenario get _current => phishingScenarios[_scenarioIndex];
  bool get _allMessagesShown => _step >= _current.messages.length - 1;
  bool get _isLastScenario => _scenarioIndex == phishingScenarios.length - 1;

  void _nextMessage() {
    if (_step < _current.messages.length - 1) {
      setState(() => _step++);
    }
  }

  void _makeChoice(int index) {
    setState(() {
      _choiceMade = index;
      _showFeedback = true;
    });
  }

  Future<void> _nextScenario() async {
    if (_scenarioIndex < phishingScenarios.length - 1) {
      setState(() {
        _scenarioIndex++;
        _step = 0;
        _choiceMade = null;
        _showFeedback = false;
      });
    } else {
      await UserService.instance.saveProgress(
        const LessonProgress(
          lessonId: 'phishing_detective',
          stepsCompleted: 6,
          totalSteps: 6,
          stars: 3,
          completed: true,
        ),
      );

      if (!mounted) return;

      await XpAward.show(
        context,
        lessonId: 'phishing_detective',
        amount: 200,
      );

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

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
            Text('Scenario ${_scenarioIndex + 1} of ${phishingScenarios.length}',
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
                child: Text('🔍 ${_scenarioIndex + 1}/${phishingScenarios.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4A90D9), fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(children: [
              const Text('🎯', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(_current.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
            ]),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _allMessagesShown || _showFeedback ? null : _nextMessage,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  for (int i = 0; i <= _step; i++)
                    ChatMessageWidget(
                      message: _current.messages[i],
                      isTyping: _current.messages[i].text == '...',
                    ),
                  if (!_allMessagesShown && !_showFeedback)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text('Tap to continue the chat...',
                          style: TextStyle(fontSize: 12, color: Color(0xFF9AABBF), fontStyle: FontStyle.italic)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
            child: _showFeedback
              ? FeedbackPanel(
                  key: const ValueKey('feedback'),
                  feedback: _current.feedback[_choiceMade!],
                  onNext: _nextScenario,
                  isLastScenario: _isLastScenario,
                )
              : _allMessagesShown
                ? ChoicesPanel(
                    key: const ValueKey('choices'),
                    question: _current.question,
                    choices: _current.choices,
                    onChoiceMade: _makeChoice,
                  )
                : const SizedBox(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}