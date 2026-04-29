import 'package:flutter/material.dart';

class PasswordPowerScreen extends StatefulWidget {
  const PasswordPowerScreen({super.key});

  @override
  State<PasswordPowerScreen> createState() => _PasswordPowerScreenState();
}

class _PasswordPowerScreenState extends State<PasswordPowerScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2E45)),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Password Power',
          style: TextStyle(color: Color(0xFF1A2E45), fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          if (_currentStep > 0 && _currentStep < 5)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Step $_currentStep of 4',
                  style: const TextStyle(color: Color(0xFF7A9BB5), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _IntroStep(key: const ValueKey(0), onNext: () => setState(() => _currentStep = 1));
      case 1: return _LessonStep1(key: const ValueKey(1), onNext: () => setState(() => _currentStep = 2));
      case 2: return _LessonStep2(key: const ValueKey(2), onNext: () => setState(() => _currentStep = 3));
      case 3: return _LessonStep3(key: const ValueKey(3), onNext: () => setState(() => _currentStep = 4));
      case 4: return _LessonStep4(key: const ValueKey(4), onNext: () => setState(() => _currentStep = 5));
      case 5: return _QuizStep(key: const ValueKey(5), onComplete: () => setState(() => _currentStep = 6));
      case 6: return _BuildPasswordStep(key: const ValueKey(6), onComplete: () => setState(() => _currentStep = 7));
      case 7: return _CompleteStep(key: const ValueKey(7), onDone: () => Navigator.pop(context));
      default: return const SizedBox();
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            Text('$current / $total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextButton({required this.onTap, this.label = 'Next →', this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2E45),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFCDD8E3),
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji;
  final String title;
  final String body;
  const _InfoCard({required this.color, required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
            child: const Text('🔒', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 24),
          const Text('Password Power!', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          const Text(
            'Learn how to create passwords so strong, even the sneakiest hackers can\'t crack them! 💪',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF5A7A95), height: 1.5),
          ),
          const SizedBox(height: 28),
          _InfoCard(color: Colors.blue, emoji: '📖', title: 'What you\'ll learn',
            body: 'Why passwords matter, what makes them weak or strong, and how to build one that\'s really hard to guess!'),
          const SizedBox(height: 12),
          _InfoCard(color: Colors.green, emoji: '⏱️', title: '10 minutes',
            body: '4 quick lessons + a quiz + build your very own password at the end!'),
          const SizedBox(height: 12),
          _InfoCard(color: Colors.amber, emoji: '⭐', title: 'Earn up to +100 XP',
            body: 'Complete everything to earn your Password Master badge!'),
          const SizedBox(height: 32),
          _NextButton(onTap: onNext, label: '▶  Start Lesson'),
        ],
      ),
    );
  }
}

class _LessonStep1 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressBar(current: 1, total: 4),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: const Column(
              children: [
                Text('🏠', style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text('Think of a password like the key to your house!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45)))
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('What can happen without a good password?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          _ScenarioCard(emoji: '📧', text: 'Someone reads your private messages', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '🎮', text: 'A hacker steals your game progress', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '📸', text: 'Strangers see your private photos', isBad: true),
          const SizedBox(height: 8),
          _ScenarioCard(emoji: '🛡️', text: 'A strong password keeps all of this safe!', isBad: false),
          const SizedBox(height: 32),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String emoji, text;
  final bool isBad;
  const _ScenarioCard({required this.emoji, required this.text, required this.isBad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isBad ? const Color(0xFFFFEBEB) : const Color(0xFFD5F5E3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isBad ? const Color(0xFFFFAAAA) : const Color(0xFF82E0AA), width: 1.2),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: isBad ? const Color(0xFFB03030) : const Color(0xFF1E8449)))),
          Icon(isBad ? Icons.cancel : Icons.check_circle,
            color: isBad ? const Color(0xFFE74C3C) : const Color(0xFF2ECC71), size: 20),
        ],
      ),
    );
  }
}

class _LessonStep2 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressBar(current: 2, total: 4),
          const SizedBox(height: 24),
          const Text('Spot the Weak Passwords! 😬',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text('These are passwords hackers try FIRST. Never use them!',
            style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 16),
          _WeakPasswordTile(password: '123456', reason: 'Just numbers in order — way too easy!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'password', reason: 'The word "password" is the #1 most guessed!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'iloveyou', reason: 'Very common phrase — hackers know this one!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'abc123', reason: 'Short and simple = easy to crack in seconds!'),
          const SizedBox(height: 8),
          _WeakPasswordTile(password: 'yourname123', reason: 'Using your own name makes it easy to guess!'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 24)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hackers use programs that try millions of common passwords in seconds. The simpler yours is, the faster it gets cracked!',
                    style: TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class _WeakPasswordTile extends StatelessWidget {
  final String password, reason;
  const _WeakPasswordTile({required this.password, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8)),
            child: Text(password, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
              color: Color(0xFFB03030), fontFamily: 'monospace')),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(reason, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95)))),
          const Text('❌', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class _LessonStep3 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressBar(current: 3, total: 4),
          const SizedBox(height: 24),
          const Text('The 4 Rules of a Strong Password 💪',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 16),
          _RuleCard(number: '1', emoji: '📏', color: Colors.blue, title: 'Make it LONG',
            body: 'At least 12 characters. Longer = much harder to crack!'),
          const SizedBox(height: 10),
          _RuleCard(number: '2', emoji: '🔀', color: Colors.purple, title: 'Mix it UP',
            body: 'Use UPPER and lower case letters together, like "SuNsHiNe".'),
          const SizedBox(height: 10),
          _RuleCard(number: '3', emoji: '🔢', color: Colors.orange, title: 'Add NUMBERS',
            body: 'Throw in some numbers — but not just "123" at the end!'),
          const SizedBox(height: 10),
          _RuleCard(number: '4', emoji: '✨', color: Colors.green, title: 'Use SYMBOLS',
            body: 'Characters like ! @ # \$ % make it much stronger.'),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFD5F5E3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF82E0AA)),
            ),
            child: Column(
              children: [
                const Text('✅ Strong Password Example',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E8449))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Text('Tr0pic@lFish!2024',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45), letterSpacing: 1)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Tag(label: 'Long', color: Colors.blue),
                    const SizedBox(width: 6),
                    _Tag(label: 'Mixed case', color: Colors.purple),
                    const SizedBox(width: 6),
                    _Tag(label: 'Numbers', color: Colors.orange),
                    const SizedBox(width: 6),
                    _Tag(label: 'Symbols', color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const _RuleCard({required this.number, required this.emoji, required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 3),
                Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
              ],
            ),
          ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text(number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _LessonStep4 extends StatelessWidget {
  final VoidCallback onNext;
  const _LessonStep4({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressBar(current: 4, total: 4),
          const SizedBox(height: 24),
          const Text('The Passphrase Trick 🧠',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text('Hard to guess, but easy for YOU to remember!',
            style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(
              children: [
                const Text('Pick 3 random words you like:',
                  style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _WordBubble(word: 'Fluffy', emoji: '🐱'),
                    const Text(' + ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    _WordBubble(word: 'Pizza', emoji: '🍕'),
                    const Text(' + ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    _WordBubble(word: 'Rocket', emoji: '🚀'),
                  ],
                ),
                const SizedBox(height: 16),
                const Icon(Icons.arrow_downward, color: Color(0xFF4A90D9), size: 28),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFFD5F5E3), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Fluffy\$Pizza!Rocket7',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45), letterSpacing: 0.5)),
                ),
                const SizedBox(height: 10),
                const Text('Add numbers & symbols between the words ✨',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5A7A95))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Why is this great?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          _InfoCard(color: Colors.green, emoji: '✅', title: 'Easy to remember',
            body: 'A funny image in your head — a fluffy cat eating pizza on a rocket!'),
          const SizedBox(height: 8),
          _InfoCard(color: Colors.blue, emoji: '🔐', title: 'Very long',
            body: 'More characters = exponentially harder to crack.'),
          const SizedBox(height: 8),
          _InfoCard(color: Colors.orange, emoji: '🤫', title: 'Your secret',
            body: 'Nobody else would pick the same 3 random words as you!'),
          const SizedBox(height: 32),
          _NextButton(onTap: onNext, label: 'Take the Quiz! 🎯'),
        ],
      ),
    );
  }
}

class _WordBubble extends StatelessWidget {
  final String word, emoji;
  const _WordBubble({required this.word, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A90D9).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(word, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
        ],
      ),
    );
  }
}

class _QuizStep extends StatefulWidget {
  final VoidCallback onComplete;
  const _QuizStep({super.key, required this.onComplete});

  @override
  State<_QuizStep> createState() => _QuizStepState();
}

class _QuizStepState extends State<_QuizStep> {
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
                    ?trailing,
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
            _NextButton(
              onTap: _next,
              label: _questionIndex < _questions.length - 1 ? 'Next Question →' : 'Now build your own! 🛠️',
            ),
          ],
        ],
      ),
    );
  }
}

class _BuildPasswordStep extends StatefulWidget {
  final VoidCallback onComplete;
  const _BuildPasswordStep({super.key, required this.onComplete});

  @override
  State<_BuildPasswordStep> createState() => _BuildPasswordStepState();
}

class _BuildPasswordStepState extends State<_BuildPasswordStep> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;

  bool get _hasLength => _controller.text.length >= 12;
  bool get _hasUpper  => _controller.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower  => _controller.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _controller.text.contains(RegExp(r'[0-9]'));
  bool get _hasSymbol => _controller.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;~/`]'));

  int get _score => [_hasLength, _hasUpper, _hasLower, _hasNumber, _hasSymbol].where((b) => b).length;

  bool get _canProceed => _score >= 4;

  String get _strengthLabel {
    if (_controller.text.isEmpty) return 'Start typing...';
    if (_score <= 1) return 'Very Weak 😬';
    if (_score == 2) return 'Weak 😕';
    if (_score == 3) return 'Getting Better 🙂';
    if (_score == 4) return 'Strong 💪';
    return 'Super Strong! 🔥';
  }

  Color get _strengthColor {
    if (_controller.text.isEmpty) return Colors.grey.shade300;
    if (_score <= 1) return const Color(0xFFE74C3C);
    if (_score == 2) return const Color(0xFFE67E22);
    if (_score == 3) return const Color(0xFFF1C40F);
    if (_score == 4) return const Color(0xFF2ECC71);
    return const Color(0xFF27AE60);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('🛠️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Build Your Own Password!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            ),
          ]),
          const SizedBox(height: 6),
          const Text('Use everything you\'ve learned to create a strong password. It needs to pass all 4 rules!',
            style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95), height: 1.4)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Type your password:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  obscureText: _obscure,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                    letterSpacing: 1.5, color: Color(0xFF1A2E45)),
                  decoration: InputDecoration(
                    hintText: 'e.g. Fluffy\$Pizza!Rocket7',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400, letterSpacing: 0),
                    filled: true,
                    fillColor: const Color(0xFFEFF4FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade500),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Strength:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7A9BB5))),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _strengthColor),
                      child: Text(_strengthLabel),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _controller.text.isEmpty ? 0 : _score / 5,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rules checklist:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
                const SizedBox(height: 12),
                _CheckRow(label: 'At least 12 characters long', passed: _hasLength),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has UPPERCASE letters', passed: _hasUpper),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has lowercase letters', passed: _hasLower),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has numbers (0–9)', passed: _hasNumber),
                const SizedBox(height: 8),
                _CheckRow(label: 'Has symbols (! @ # \$ % etc.)', passed: _hasSymbol),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (!_canProceed && _controller.text.isNotEmpty)
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
                Expanded(child: Text(_getHint(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4))),
              ]),
            ),

          if (_canProceed)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFD5F5E3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF82E0AA)),
              ),
              child: const Row(children: [
                Text('🎉', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Expanded(child: Text('Amazing! Your password passes the rules. You\'re ready to finish!',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1E8449), fontWeight: FontWeight.w600, height: 1.4))),
              ]),
            ),

          const SizedBox(height: 24),
          _NextButton(
            onTap: widget.onComplete,
            enabled: _canProceed,
            label: 'Finish! 🏆',
          ),
          if (!_canProceed)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text('Complete at least 4 rules to finish',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AABBF))),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getHint() {
    if (!_hasLength) return 'Your password is too short — aim for at least 12 characters. Try adding more words!';
    if (!_hasUpper) return 'Add some UPPERCASE letters — try capitalising the start of each word.';
    if (!_hasLower) return 'Add some lowercase letters too — mix them with your capitals.';
    if (!_hasNumber) return 'Throw in a number or two — like replacing "o" with "0" or adding "7" at the end.';
    if (!_hasSymbol) return 'Nearly there! Add a symbol like ! @ # or \$ to make it super strong.';
    return 'Keep going — you\'re almost there!';
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool passed;
  const _CheckRow({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 26, height: 26,
          decoration: BoxDecoration(
            color: passed ? const Color(0xFF2ECC71) : const Color(0xFFEFF4FB),
            shape: BoxShape.circle,
            border: Border.all(
              color: passed ? const Color(0xFF2ECC71) : const Color(0xFFCDD8E3),
              width: 2,
            ),
          ),
          child: Icon(passed ? Icons.check : Icons.remove,
            size: 15, color: passed ? Colors.white : const Color(0xFFCDD8E3)),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: passed ? const Color(0xFF1A2E45) : const Color(0xFF9AABBF),
          decoration: passed ? TextDecoration.none : TextDecoration.none,
        )),
      ],
    );
  }
}

class _CompleteStep extends StatelessWidget {
  final VoidCallback onDone;
  const _CompleteStep({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(color: Color(0xFFD5F5E3), shape: BoxShape.circle),
            child: const Text('🏆', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 24),
          const Text('You did it! 🎉',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          const Text('You\'ve completed Password Power!', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF5A7A95))),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: const Color(0xFFFFFDE7), borderRadius: BorderRadius.circular(14)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('⭐', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 8),
                  Text('+100 XP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFE6A817))),
                ]),
              ),
              const SizedBox(height: 16),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('⭐', style: TextStyle(fontSize: 32)),
                Text('⭐', style: TextStyle(fontSize: 32)),
                Text('⭐', style: TextStyle(fontSize: 32)),
              ]),
              const SizedBox(height: 10),
              const Text('3 Stars — Amazing!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            ]),
          ),
          const SizedBox(height: 20),
          _InfoCard(color: Colors.orange, emoji: '🔒', title: 'Badge Unlocked: Password Master!',
            body: 'You know how to build a password that even hackers can\'t crack — AND you made one yourself!'),
          const SizedBox(height: 16),
          const Text('What you learned:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          _SummaryTile(emoji: '🏠', text: 'Why passwords protect your online life'),
          _SummaryTile(emoji: '😬', text: 'How to spot a weak, hackable password'),
          _SummaryTile(emoji: '💪', text: 'The 4 rules of a strong password'),
          _SummaryTile(emoji: '🧠', text: 'The passphrase trick'),
          _SummaryTile(emoji: '🛠️', text: 'Built your very own strong password!'),
          const SizedBox(height: 32),
          _NextButton(onTap: onDone, label: '🏠 Back to Dashboard'),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String emoji, text;
  const _SummaryTile({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95)))),
        const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 18),
      ]),
    );
  }
}