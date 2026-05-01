import 'package:flutter/material.dart';
import 'password_components.dart';

class IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const IntroStep({super.key, required this.onNext});

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
          InfoCard(color: Colors.blue, emoji: '📖', title: 'What you\'ll learn',
            body: 'Why passwords matter, what makes them weak or strong, and how to build one that\'s really hard to guess!'),
          const SizedBox(height: 12),
          InfoCard(color: Colors.green, emoji: '⏱️', title: '10 minutes',
            body: '4 quick lessons + a quiz + build your very own password at the end!'),
          const SizedBox(height: 12),
          InfoCard(color: Colors.amber, emoji: '⭐', title: 'Earn up to +100 XP',
            body: 'Complete everything to earn your Password Master badge!'),
          const SizedBox(height: 32),
          NextButton(onTap: onNext, label: '▶  Start Lesson'),
        ],
      ),
    );
  }
}

class LessonStep1 extends StatelessWidget {
  final VoidCallback onNext;
  const LessonStep1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(current: 1, total: 4),
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
          ScenarioCard(emoji: '📧', text: 'Someone reads your private messages', isBad: true),
          const SizedBox(height: 8),
          ScenarioCard(emoji: '🎮', text: 'A hacker steals your game progress', isBad: true),
          const SizedBox(height: 8),
          ScenarioCard(emoji: '📸', text: 'Strangers see your private photos', isBad: true),
          const SizedBox(height: 8),
          ScenarioCard(emoji: '🛡️', text: 'A strong password keeps all of this safe!', isBad: false),
          const SizedBox(height: 32),
          NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class LessonStep2 extends StatelessWidget {
  final VoidCallback onNext;
  const LessonStep2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(current: 2, total: 4),
          const SizedBox(height: 24),
          const Text('Spot the Weak Passwords! 😬',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text('These are passwords hackers try FIRST. Never use them!',
            style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 16),
          WeakPasswordTile(password: '123456', reason: 'Just numbers in order — way too easy!'),
          const SizedBox(height: 8),
          WeakPasswordTile(password: 'password', reason: 'The word "password" is the #1 most guessed!'),
          const SizedBox(height: 8),
          WeakPasswordTile(password: 'iloveyou', reason: 'Very common phrase — hackers know this one!'),
          const SizedBox(height: 8),
          WeakPasswordTile(password: 'abc123', reason: 'Short and simple = easy to crack in seconds!'),
          const SizedBox(height: 8),
          WeakPasswordTile(password: 'yourname123', reason: 'Using your own name makes it easy to guess!'),
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
          NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class LessonStep3 extends StatelessWidget {
  final VoidCallback onNext;
  const LessonStep3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(current: 3, total: 4),
          const SizedBox(height: 24),
          const Text('The 4 Rules of a Strong Password 💪',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          const SizedBox(height: 16),
          RuleCard(number: '1', emoji: '📏', color: Colors.blue, title: 'Make it LONG',
            body: 'At least 12 characters. Longer = much harder to crack!'),
          const SizedBox(height: 10),
          RuleCard(number: '2', emoji: '🔀', color: Colors.purple, title: 'Mix it UP',
            body: 'Use UPPER and lower case letters together, like "SuNsHiNe".'),
          const SizedBox(height: 10),
          RuleCard(number: '3', emoji: '🔢', color: Colors.orange, title: 'Add NUMBERS',
            body: 'Throw in some numbers — but not just "123" at the end!'),
          const SizedBox(height: 10),
          RuleCard(number: '4', emoji: '✨', color: Colors.green, title: 'Use SYMBOLS',
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
                    Tag(label: 'Long', color: Colors.blue),
                    const SizedBox(width: 6),
                    Tag(label: 'Mixed case', color: Colors.purple),
                    const SizedBox(width: 6),
                    Tag(label: 'Numbers', color: Colors.orange),
                    const SizedBox(width: 6),
                    Tag(label: 'Symbols', color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          NextButton(onTap: onNext),
        ],
      ),
    );
  }
}

class LessonStep4 extends StatelessWidget {
  final VoidCallback onNext;
  const LessonStep4({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(current: 4, total: 4),
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
                    WordBubble(word: 'Fluffy', emoji: '🐱'),
                    const Text(' + ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    WordBubble(word: 'Pizza', emoji: '🍕'),
                    const Text(' + ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    WordBubble(word: 'Rocket', emoji: '🚀'),
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
          InfoCard(color: Colors.green, emoji: '✅', title: 'Easy to remember',
            body: 'A funny image in your head — a fluffy cat eating pizza on a rocket!'),
          const SizedBox(height: 8),
          InfoCard(color: Colors.blue, emoji: '🔐', title: 'Very long',
            body: 'More characters = exponentially harder to crack.'),
          const SizedBox(height: 8),
          InfoCard(color: Colors.orange, emoji: '🤫', title: 'Your secret',
            body: 'Nobody else would pick the same 3 random words as you!'),
          const SizedBox(height: 32),
          NextButton(onTap: onNext, label: 'Take the Quiz! 🎯'),
        ],
      ),
    );
  }
}