import 'package:flutter/material.dart';
import 'package:final_year_project/widgets/xp_award.dart';
import 'password_components.dart';

class CompleteStep extends StatelessWidget {
  final VoidCallback onDone;
  const CompleteStep({super.key, required this.onDone});

  Future<void> _finish(BuildContext context) async {
    await XpAward.show(
      context,
      lessonId: 'password_power', 
      amount: 100,                
    );
    onDone(); 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
                color: Color(0xFFD5F5E3), shape: BoxShape.circle),
            child: const Text('🏆', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 24),
          const Text('You did it! 🎉',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          const Text("You've completed Password Power!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF5A7A95))),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFDE7),
                    borderRadius: BorderRadius.circular(14)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('⭐', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 8),
                  Text('+100 XP',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE6A817))),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45))),
            ]),
          ),
          const SizedBox(height: 20),
          InfoCard(
              color: Colors.orange,
              emoji: '🔒',
              title: 'Badge Unlocked: Password Master!',
              body:
                  'You know how to build a password that even hackers can\'t crack — AND you made one yourself!'),
          const SizedBox(height: 16),
          const Text('What you learned:',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          SummaryTile(emoji: '🏠', text: 'Why passwords protect your online life'),
          SummaryTile(emoji: '😬', text: 'How to spot a weak, hackable password'),
          SummaryTile(emoji: '💪', text: 'The 4 rules of a strong password'),
          SummaryTile(emoji: '🧠', text: 'The passphrase trick'),
          SummaryTile(emoji: '🛠️', text: 'Built your very own strong password!'),
          const SizedBox(height: 32),
          NextButton(onTap: () => _finish(context), label: '🏠 Back to Dashboard'),
        ],
      ),
    );
  }
}