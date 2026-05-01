// lib/screens/password/password_quiz.dart
import 'package:flutter/material.dart';
import 'password_components.dart';

class QuizStep extends StatefulWidget {
  final VoidCallback onComplete;
  const QuizStep({super.key, required this.onComplete});

  @override
  State<QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<QuizStep> {
  int _questionIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which of these is the STRONGEST password?',
      'emoji': '🤔',
      'options': ['fluffy123', 'password', 'Tr0pic@lFish!2024', '12345678'],
      'correct': 2,
      'explanation': 'Tr0pic@lFish!2024 is long, has mixed case, numbers AND symbols — all 4 rules!',
    },
    {
      'question': 'What is the MINIMUM length a strong password should be?',
      'emoji': '📏',
      'options': ['4 characters', '8 characters', '12 characters', '6 characters'],
      'correct': 2,
      'explanation': 'At least 12 characters! The longer the better.',
    },
    {
      'question': 'Why is "yourname123" a weak password?',
      'emoji': '🤨',
      'options': ['It\'s too long', 'It uses your name — easy to guess!', 'It has numbers', 'It\'s hard to remember'],
      'correct': 1,
      'explanation': 'Using your own name makes it very easy for people who know you to guess it!',
    },
    {
      'question': 'Which symbol can make your password stronger?',
      'emoji': '✨',
      'options': ['A space', '@ or ! or #', 'Only letters', 'A smiley face'],
      'correct': 1,
      'explanation': 'Special symbols like @ ! # \$ make passwords much harder to crack!',
    },
    {
      'question': 'A passphrase uses... ?',
      'emoji': '🧠',
      'options': ['One short word', 'Your birthday', 'Random words joined together', 'Just numbers'],
      'correct': 2,
      'explanation': 'Combining random words (like Fluffy+Pizza+Rocket) makes a memorable but super strong password!',
    },
  ];

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
    });
  }

  void _next() {
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_questionIndex];
    final List<String> options = List<String>.from(q['options'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Quiz Time! 🎯',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFD5F5E3), borderRadius: BorderRadius.circular(20)),
              child: Text('${_questionIndex + 1} / ${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF27AE60), fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (_questionIndex + 1) / _questions.length,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90D9)),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(children: [
              Text(q['emoji'] as String, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 14),
              Text(q['question'] as String, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            ]),
          ),
          const SizedBox(height: 20),
          ...options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final correct = q['correct'] as int;
            Color bg = Colors.white;
            Color border = const Color(0xFFDDE8F2);
            Color textColor = const Color(0xFF1A2E45);
            Widget? trailing;

            if (_answered) {
              if (i == correct) {
                bg = const Color(0xFFD5F5E3); border = const Color(0xFF82E0AA);
                textColor = const Color(0xFF1E8449);
                trailing = const Icon(Icons.check_circle, color: Color(0xFF2ECC71));
              } else if (i == _selectedAnswer) {
                bg = const Color(0xFFFFEBEB); border = const Color(0xFFFFAAAA);
                textColor = const Color(0xFFB03030);
                trailing = const Icon(Icons.cancel, color: Color(0xFFE74C3C));
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _selectAnswer(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Row(children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _answered && i == correct ? const Color(0xFF2ECC71) : const Color(0xFFEFF4FB),
                      ),
                      child: Center(child: Text(['A', 'B', 'C', 'D'][i],
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13,
                          color: _answered && i == correct ? Colors.white : const Color(0xFF9AABBF)))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(opt,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor))),
                    if (trailing != null) trailing,
                  ]),
                ),
              ),
            );
          }),

          if (_answered) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(q['explanation'] as String,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4))),
              ]),
            ),
            const SizedBox(height: 20),
            NextButton(
              onTap: _next,
              label: _questionIndex < _questions.length - 1 ? 'Next Question →' : 'Now build your own! 🛠️',
            ),
          ],
        ],
      ),
    );
  }
}