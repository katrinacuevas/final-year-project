import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/xp_award.dart';

class PhishingDetectiveScreen extends StatefulWidget {
  const PhishingDetectiveScreen({super.key});

  @override
  State<PhishingDetectiveScreen> createState() => _PhishingDetectiveScreenState();
}

class _PhishingDetectiveScreenState extends State<PhishingDetectiveScreen> {
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
            if (_currentStep > 0) setState(() => _currentStep--);
            else Navigator.pop(context);
          },
        ),
        title: const Text('Phishing Detective',
          style: TextStyle(color: Color(0xFF1A2E45), fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          if (_currentStep >= 1 && _currentStep <= 4)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('Lesson $_currentStep of 4',
                style: const TextStyle(color: Color(0xFF7A9BB5), fontWeight: FontWeight.w600, fontSize: 13))),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
          child: child,
        ),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    n(int s) => () => setState(() => _currentStep = s);
    switch (_currentStep) {
      case 0: return _IntroStep(key: const ValueKey(0), onNext: n(1));
      case 1: return _Lesson1(key: const ValueKey(1), onNext: n(2));
      case 2: return _Lesson2(key: const ValueKey(2), onNext: n(3));
      case 3: return _Lesson3(key: const ValueKey(3), onNext: n(4));
      case 4: return _Lesson4(key: const ValueKey(4), onNext: n(5));
      case 5: return _ChatSimActivity(key: const ValueKey(5), onNext: n(6));
      case 6: return _QuizStep(key: const ValueKey(6), onComplete: n(7));
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
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
      Text('$current / $total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: current / total, minHeight: 10,
        backgroundColor: Colors.grey.shade200,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
      ),
    ),
  ]);
}

class _NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextBtn({required this.onTap, this.label = 'Next →', this.enabled = true});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A2E45),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFCDD8E3),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const _InfoCard({required this.color, required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 28)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        const SizedBox(height: 4),
        Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95), height: 1.4)),
      ])),
    ]),
  );
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: child,
  );
}

class _TipBox extends StatelessWidget {
  final String text;
  const _TipBox({required this.text});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.amber.shade50,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.amber.shade200),
    ),
    child: Row(children: [
      const Text('💡', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4))),
    ]),
  );
}

class _RedFlagCard extends StatelessWidget {
  final String flag, detail;
  const _RedFlagCard({required this.flag, required this.detail});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      border: Border.all(color: const Color(0xFFFFCDD2), width: 1.2),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFB03030))),
      const SizedBox(height: 5),
      Text(detail, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
    ]),
  );
}

class _StepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const _StepCard({required this.number, required this.emoji, required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(children: [
      Container(width: 48, height: 48,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24)))),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        const SizedBox(height: 3),
        Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
      ])),
      Container(width: 28, height: 28,
        decoration: const BoxDecoration(color: Color(0xFF26A69A), shape: BoxShape.circle),
        child: Center(child: Text(number,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)))),
    ]),
  );
}

class _IntroStep extends StatelessWidget {
  final VoidCallback onNext;
  const _IntroStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
        child: const Text('🎣', style: TextStyle(fontSize: 72)),
      ),
      const SizedBox(height: 24),
      const Text('Phishing Detective!', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 12),
      const Text(
        'Learn how cybercriminals send fake messages to trick you — and become an expert at spotting them! 🕵️',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Color(0xFF5A7A95), height: 1.5),
      ),
      const SizedBox(height: 28),
      _InfoCard(color: const Color(0xFF26A69A), emoji: '📖', title: "What you'll learn",
        body: "What phishing is, how to spot fake emails and messages, red flags to watch for, what to do when something feels wrong, and real chat simulations."),
      const SizedBox(height: 12),
      _InfoCard(color: Colors.green, emoji: '⏱️', title: '~20 minutes',
        body: '4 lessons + 3 chat simulations + quiz at the end!'),
      const SizedBox(height: 12),
      _InfoCard(color: Colors.amber, emoji: '⭐', title: 'Earn up to +150 XP',
        body: 'Complete everything to earn your Phishing Detective badge!'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext, label: '▶  Start Course'),
    ]),
  );
}

class _Lesson1 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 1, total: 4),
      const SizedBox(height: 24),
      _WhiteCard(child: const Column(children: [
        Text('🎣', style: TextStyle(fontSize: 56)),
        SizedBox(height: 12),
        Text('What is Phishing?', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        SizedBox(height: 10),
        Text(
          'Phishing is when a cybercriminal sends you a fake message pretending to be someone you trust — like your school, a game company, or even a friend — to trick you into giving away personal information.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95), height: 1.5),
        ),
      ])),
      const SizedBox(height: 20),
      const Text('Why is it called phishing? 🐟',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 12),
      _WhiteCard(child: const Column(children: [
        _FishRow(emoji: '🎣', text: 'A fisherman throws bait hoping a fish will bite'),
        _FishRow(emoji: '📧', text: 'A phisher sends fake messages hoping YOU will bite'),
        _FishRow(emoji: '🐟', text: 'The fish gets caught — you give away your password'),
        _FishRow(emoji: '😨', text: 'The phisher gets into your accounts'),
      ])),
      const SizedBox(height: 20),
      const Text('Who do phishers pretend to be?',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 10),
      _InfoCard(color: const Color(0xFF26A69A), emoji: '🏫', title: 'Your school',
        body: '"Your account needs verifying — click here immediately or it will be deleted."'),
      const SizedBox(height: 8),
      _InfoCard(color: Colors.orange, emoji: '🎮', title: 'Game companies',
        body: '"Your Roblox/Minecraft account has been flagged. Log in now to keep your account."'),
      const SizedBox(height: 8),
      _InfoCard(color: Colors.purple, emoji: '👦', title: 'Someone you know',
        body: '"Hey it\'s me — I got a new number. Can you send me the code that just came to your phone?"'),
      const SizedBox(height: 16),
      _TipBox(text: 'Phishing can happen by email, text, gaming chats and social media DMs. Always be alert!'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _FishRow extends StatelessWidget {
  final String emoji, text;
  const _FishRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2E45), height: 1.4))),
    ]),
  );
}

class _Lesson2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 2, total: 4),
      const SizedBox(height: 24),
      const Text('Spotting Fake Messages 📧',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text('Can you tell a real message from a fake one?',
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _EmailCard(
        from: 'support@sch00l-help.com',
        subject: 'URGENT: Your account will be deleted in 24 hours!',
        body: 'Dear student, your school account has been flagged. Click the link below immediately to avoid losing access forever.',
        isReal: false,
        clue: '"sch00l-help.com" uses zeros instead of "o" — a classic fake address trick.',
      ),
      const SizedBox(height: 12),
      _EmailCard(
        from: 'itsupport@westfieldacademy.co.uk',
        subject: 'Scheduled maintenance this weekend',
        body: 'The school portal will be offline Saturday 9am–1pm for updates. No action required from students.',
        isReal: true,
        clue: 'Official domain, no urgency, no links, no request for personal info.',
      ),
      const SizedBox(height: 20),
      const Text('Red flags to look for 🚩',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '⏰ Extreme urgency', detail: '"Act NOW or your account will be deleted!" — real organisations give you time to respond.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '✉️ Suspicious sender address', detail: 'Look closely — "amaz0n.com" or "sch00l-help.com" are fake. Check the full address.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '🔑 Asking for your password', detail: 'No real company, school or game will ever ask for your password by email. Ever.'),
      const SizedBox(height: 8),
      _RedFlagCard(flag: '🔗 Unexpected links', detail: 'A message with a random link you weren\'t expecting is almost always suspicious.'),
      const SizedBox(height: 16),
      _TipBox(text: 'Always check the full email address — not just the name shown. "Apple Support" could actually come from "apple.xyz.ru"!'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _EmailCard extends StatelessWidget {
  final String from, subject, body, clue;
  final bool isReal;
  const _EmailCard({required this.from, required this.subject, required this.body, required this.clue, required this.isReal});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isReal ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(children: [
          Icon(isReal ? Icons.check_circle : Icons.warning,
            color: isReal ? const Color(0xFF27AE60) : const Color(0xFFE74C3C), size: 16),
          const SizedBox(width: 6),
          Text(isReal ? '✅ Looks legitimate' : '❌ Suspicious',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
              color: isReal ? const Color(0xFF27AE60) : const Color(0xFFB03030))),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('From: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF7A9BB5))),
            Expanded(child: Text(from, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: isReal ? const Color(0xFF1A2E45) : const Color(0xFFB03030)))),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Text('Subject: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF7A9BB5))),
            Expanded(child: Text(subject, style: const TextStyle(fontSize: 11, color: Color(0xFF1A2E45)))),
          ]),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isReal ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🔍 ', style: TextStyle(fontSize: 13)),
              Expanded(child: Text(clue, style: TextStyle(fontSize: 12, height: 1.4,
                color: isReal ? const Color(0xFF1E6B3A) : const Color(0xFFB03030)))),
            ]),
          ),
        ]),
      ),
    ]),
  );
}

class _Lesson3 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 3, total: 4),
      const SizedBox(height: 24),
      const Text('Suspicious Links 🔗',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text('A dangerous link can look completely normal. Here\'s how to spot one:',
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(children: const [
        Text('⚠️ Real vs Fake Links',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        SizedBox(height: 14),
        _LinkRow(label: '✅', link: 'roblox.com/login', safe: true),
        _LinkRow(label: '❌', link: 'r0blox-free.xyz/login', safe: false),
        SizedBox(height: 6),
        _LinkRow(label: '✅', link: 'minecraft.net/en-us', safe: true),
        _LinkRow(label: '❌', link: 'minecraft-free-items.xyz', safe: false),
        SizedBox(height: 6),
        _LinkRow(label: '✅', link: 'bbc.co.uk/news', safe: true),
        _LinkRow(label: '❌', link: 'bbc.news-alerts.ru/click', safe: false),
      ])),
      const SizedBox(height: 20),
      const Text('How to check a link safely 🛡️',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 10),
      _StepCard(number: '1', emoji: '🌐', color: const Color(0xFFE0F2F1),
        title: 'Go directly to the website',
        body: 'Instead of clicking the link, type the official website address yourself in your browser.'),
      const SizedBox(height: 8),
      _StepCard(number: '2', emoji: '🔒', color: const Color(0xFFFFF9C4),
        title: 'Check for https://',
        body: 'Real websites use "https://" and show a padlock icon. No padlock = not secure.'),
      const SizedBox(height: 8),
      _StepCard(number: '3', emoji: '🔍', color: const Color(0xFFE8D5FB),
        title: 'Look for sneaky spelling tricks',
        body: '"r0blox" uses zero instead of o. "amaz0n" fakes Amazon. Always read the full address carefully.'),
      const SizedBox(height: 8),
      _StepCard(number: '4', emoji: '🙋', color: const Color(0xFFDCEDC8),
        title: 'Ask a trusted adult',
        body: 'If you\'re ever unsure — don\'t click. Show a parent or teacher first.'),
      const SizedBox(height: 16),
      _TipBox(text: 'NEVER click a link in a message you weren\'t expecting — even if it looks like it came from a friend or a company you know.'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
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
        decoration: BoxDecoration(
          color: safe ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(link, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
          color: safe ? const Color(0xFF1E6B3A) : const Color(0xFFB03030))),
      )),
    ]),
  );
}

class _Lesson4 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson4({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 4, total: 4),
      const SizedBox(height: 24),
      const Text('What To Do 🛡️',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text('If you think you\'ve received a phishing message — follow these steps:',
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _StepCard(number: '1', emoji: '🛑', color: const Color(0xFFFFEBEB),
        title: 'STOP — don\'t click anything',
        body: 'Close the message. Don\'t tap any links, download files or reply.'),
      const SizedBox(height: 10),
      _StepCard(number: '2', emoji: '🤔', color: const Color(0xFFFFF9C4),
        title: 'Ask yourself: Does this make sense?',
        body: 'Did I expect this message? Would my school or game company really send this?'),
      const SizedBox(height: 10),
      _StepCard(number: '3', emoji: '🗣️', color: const Color(0xFFE0F2F1),
        title: 'Tell a trusted adult',
        body: 'Show the message to a parent or teacher. They can help you check if it\'s real.'),
      const SizedBox(height: 10),
      _StepCard(number: '4', emoji: '🚫', color: const Color(0xFFE8D5FB),
        title: 'Report and delete',
        body: 'Use the "Report" button in your email or app, then delete the message.'),
      const SizedBox(height: 10),
      _StepCard(number: '5', emoji: '🔒', color: const Color(0xFFDCEDC8),
        title: 'Change your password if needed',
        body: 'If you accidentally entered your details — tell an adult and change your password immediately.'),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF26A69A).withValues(alpha: 0.4)),
        ),
        child: const Row(children: [
          Text('🧠', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(child: Text(
            'It\'s always better to be too careful than to fall for a scam. Real organisations will never be upset that you checked!',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF00695C), height: 1.4),
          )),
        ]),
      ),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext, label: 'Chat Simulation 💬'),
    ]),
  );
}

class _ChatSimActivity extends StatefulWidget {
  final VoidCallback onNext;
  const _ChatSimActivity({super.key, required this.onNext});

  @override
  State<_ChatSimActivity> createState() => _ChatSimActivityState();
}

class _ChatSimActivityState extends State<_ChatSimActivity> {
  int _scenarioIndex = 0;
  int _msgStep = 0;
  int? _choice;
  bool _showFeedback = false;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'The Free Robux Message',
      'messages': [
        {'from': 'stranger', 'text': 'Hey! I found a glitch that gives unlimited Robux 💎 Want some for free?'},
        {'from': 'you', 'text': 'Wait... really?? 😮'},
        {'from': 'stranger', 'text': 'Yeah! Just need you to log in here 👉 r0blox-free.xyz and I\'ll transfer 10,000 Robux to you'},
        {'from': 'stranger', 'text': 'Loads of people have done it already — but you have to do it in the next 10 mins or the link expires! ⏰'},
        {'from': 'you', 'text': '...'},
      ],
      'question': 'What do you do?',
      'choices': [
        'Quick — log in before the time runs out!',
        'Ask them to show me proof it works first',
        'This looks fake — I\'m not clicking that link',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'emoji': '🚨',
          'title': 'That\'s a phishing trap!',
          'points': [
            '"r0blox-free.xyz" is NOT the official Roblox website',
            'Logging in gives the scammer your username and password',
            'Free Robux "glitches" don\'t exist — it\'s always a scam',
          ],
        },
        {
          'safe': false,
          'emoji': '😬',
          'title': 'Better — but still risky!',
          'points': [
            'Screenshots and "proof" can easily be faked',
            'Staying in the conversation lets the scammer keep trying',
            'The safest response is to not engage at all and tell a trusted adult',
          ],
        },
        {
          'safe': true,
          'emoji': '🛡️',
          'title': 'Great detective work! 🎉',
          'points': [
            'You spotted the suspicious URL "r0blox-free.xyz"',
            'You weren\'t fooled by the countdown timer pressure trick',
            'You can also report this account to keep others safe',
          ],
        },
      ],
    },
    {
      'title': 'The School Email',
      'messages': [
        {'from': 'stranger', 'text': 'URGENT: Your school email account will be deleted in 24 hours 🚨'},
        {'from': 'you', 'text': 'What?! Why?? 😱'},
        {'from': 'stranger', 'text': 'Our system detected unusual activity. Verify your account now at: school-help-verify.com'},
        {'from': 'stranger', 'text': 'Enter your school username and password to keep your account — time is running out! 🕐'},
        {'from': 'you', 'text': '...'},
      ],
      'question': 'What should you do?',
      'choices': [
        'Log in quickly to save my account!',
        'Email them back asking if it\'s real',
        'Don\'t click anything — check with my teacher in person',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'emoji': '😨',
          'title': 'That\'s exactly what the scammer wants!',
          'points': [
            'Real schools never threaten to delete accounts without proper warning',
            '"school-help-verify.com" is not your school\'s real website',
            'Entering your details gives the scammer full access to your account',
          ],
        },
        {
          'safe': false,
          'emoji': '😬',
          'title': 'Good instinct — but replying isn\'t safe either!',
          'points': [
            'Replying confirms your email address is active — which the scammer wants',
            'They will just send another convincing fake reply',
            'Go to a teacher or school staff in person to check instead',
          ],
        },
        {
          'safe': true,
          'emoji': '🛡️',
          'title': 'Exactly right! 🎉',
          'points': [
            'You spotted the urgency trick — a classic phishing tactic',
            'Checking in person means you can\'t be fooled by a fake reply',
            'Real school IT staff can confirm if the email was genuine',
          ],
        },
      ],
    },
    {
      'title': 'The Gaming Chat Message',
      'messages': [
        {'from': 'stranger', 'text': 'Hey! I\'m from the Minecraft support team 🎮 We\'re giving selected players a free rank upgrade!'},
        {'from': 'you', 'text': 'Oh wow, really?'},
        {'from': 'stranger', 'text': 'Yes! You\'ve been chosen. Just send me your Minecraft username and password so I can add the rank to your account 📦'},
        {'from': 'stranger', 'text': 'Only 50 spots left — lots of people are claiming theirs right now! Don\'t miss out 😊'},
        {'from': 'you', 'text': '...'},
      ],
      'question': 'What do you do?',
      'choices': [
        'Send my username and password — it\'s the official support team!',
        'Send my username but not my password',
        'This is a scam — real game companies never DM players for passwords',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'emoji': '🚨',
          'title': 'This is a classic phishing scam!',
          'points': [
            'Real game companies NEVER contact players by DM to ask for passwords',
            'Sharing your password gives the scammer full control of your account',
            'The "50 spots left" pressure is designed to stop you thinking clearly',
          ],
        },
        {
          'safe': false,
          'emoji': '😬',
          'title': 'Good instinct on the password — but still risky!',
          'points': [
            'Your username on its own can still be misused',
            'Engaging with the scammer encourages them to keep trying',
            'Real support teams add things to your account without needing your login',
          ],
        },
        {
          'safe': true,
          'emoji': '🛡️',
          'title': 'Spot on — you\'re a Phishing Detective! 🎉',
          'points': [
            'Official game companies NEVER ask for passwords — they don\'t need them',
            'You recognised the fake urgency and didn\'t fall for it',
            'You can report this account to the game\'s official support team',
          ],
        },
      ],
    },
  ];

  Map<String, dynamic> get _current => _scenarios[_scenarioIndex];
  List get _messages => _current['messages'] as List;
  bool get _allMsgsShown => _msgStep >= _messages.length - 1;
  bool get _isLastScenario => _scenarioIndex == _scenarios.length - 1;

  void _nextScenario() {
    if (!_isLastScenario) {
      setState(() {
        _scenarioIndex++;
        _msgStep = 0;
        _choice = null;
        _showFeedback = false;
      });
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fb = _showFeedback ? (_current['feedback'] as List)[_choice!] as Map : null;
    return Column(children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(children: [
          const Text('💬', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Chat Simulation',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            Text(_current['title'] as String,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7A9BB5))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(20)),
            child: Text('${_scenarioIndex + 1}/${_scenarios.length}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF00695C), fontSize: 13)),
          ),
        ]),
      ),
      Expanded(
        child: GestureDetector(
          onTap: (_allMsgsShown || _showFeedback) ? null : () => setState(() => _msgStep++),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (int i = 0; i <= _msgStep; i++)
                _buildBubble(_messages[i] as Map<String, dynamic>),
              if (!_allMsgsShown && !_showFeedback)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Tap to continue the chat...',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9AABBF), fontStyle: FontStyle.italic)),
                  )),
                ),
            ],
          ),
        ),
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        child: _showFeedback
            ? _buildFeedback(fb!, _isLastScenario)
            : _allMsgsShown
                ? _buildChoices()
                : const SizedBox(key: ValueKey('empty')),
      ),
    ]);
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final isYou = msg['from'] == 'you';
    final isDots = msg['text'] == '...';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isYou) ...[
            Container(width: 34, height: 34,
              decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
              child: const Icon(Icons.person, size: 20, color: Colors.grey)),
            const SizedBox(width: 8),
          ],
          Flexible(child: Container(
            padding: isDots
                ? const EdgeInsets.symmetric(horizontal: 18, vertical: 14)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isYou ? const Color(0xFF26A69A) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                bottomLeft: isYou ? const Radius.circular(18) : const Radius.circular(4),
                bottomRight: isYou ? const Radius.circular(4) : const Radius.circular(18),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: isDots
                ? _TypingDots()
                : Text(msg['text'] as String,
                    style: TextStyle(fontSize: 14,
                      color: isYou ? Colors.white : const Color(0xFF1A2E45), height: 1.4)),
          )),
          if (isYou) ...[
            const SizedBox(width: 8),
            Container(width: 34, height: 34,
              decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
              child: const Icon(Icons.person, size: 20, color: Color(0xFF26A69A))),
          ],
        ],
      ),
    );
  }

  Widget _buildChoices() {
    final choices = List<String>.from(_current['choices'] as List);
    return Container(
      key: const ValueKey('choices'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            onTap: () => setState(() { _choice = e.key; _showFeedback = true; }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF26A69A).withValues(alpha: 0.4), width: 1.5),
              ),
              child: Row(children: [
                Container(width: 26, height: 26,
                  decoration: BoxDecoration(color: const Color(0xFF26A69A).withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF00695C))))),
                const SizedBox(width: 12),
                Expanded(child: Text(e.value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2E45)))),
              ]),
            ),
          ),
        )),
      ]),
    );
  }

  Widget _buildFeedback(Map fb, bool isLast) {
    final safe = fb['safe'] as bool;
    final points = List<String>.from(fb['points'] as List);
    return Container(
      key: const ValueKey('feedback'),
      decoration: BoxDecoration(
        color: safe ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(fb['emoji'] as String, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(child: Text(fb['title'] as String,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
              color: safe ? const Color(0xFF1E6B3A) : const Color(0xFFB03030)))),
        ]),
        const SizedBox(height: 12),
        ...points.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.only(top: 5), width: 6, height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: safe ? const Color(0xFF27AE60) : const Color(0xFFE74C3C))),
            const SizedBox(width: 10),
            Expanded(child: Text(p, style: TextStyle(fontSize: 13, height: 1.4,
              color: safe ? const Color(0xFF1A4A2A) : const Color(0xFF7A2020)))),
          ]),
        )),
        const SizedBox(height: 16),
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
            child: Text(isLast ? 'Quiz Time! 🎯' : 'Next Scenario →',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
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
  int _qi = 0;
  int? _selected;
  bool _answered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'emoji': '🎣',
      'question': 'What is phishing?',
      'options': ['A type of online fishing game', 'Fake messages used to trick you into giving away personal info', 'A way to find new friends online', 'A type of computer virus'],
      'correct': 1,
      'explanation': 'Phishing uses fake messages that look real to steal your passwords, personal info or money.',
    },
    {
      'emoji': '📧',
      'question': 'You get an email from "sch00l-help.com" saying your account will be deleted. What do you do?',
      'options': ['Log in immediately to save your account', 'Reply and ask if it\'s real', 'Don\'t click anything — check with a teacher in person', 'Forward it to your friends'],
      'correct': 2,
      'explanation': '"sch00l-help.com" uses zeros — it\'s not a real school address. Never click links in suspicious emails.',
    },
    {
      'emoji': '🔗',
      'question': 'Which of these links looks suspicious?',
      'options': ['bbc.co.uk/news', 'roblox.com/login', 'r0blox-free-items.xyz', 'minecraft.net'],
      'correct': 2,
      'explanation': '"r0blox-free-items.xyz" uses "0" instead of "o" to look like Roblox — it\'s a fake site.',
    },
    {
      'emoji': '⏰',
      'question': 'A message says "You\'ve won £200! Claim in the next 5 minutes!" What is the countdown for?',
      'options': ['To help you win faster', 'To stop you from thinking clearly', 'To show the prize is real', 'To give you extra time'],
      'correct': 1,
      'explanation': 'Countdown timers create panic so you act without thinking — exactly what phishers want.',
    },
    {
      'emoji': '🎮',
      'question': 'A message says it\'s from "Minecraft Support" and asks for your password to add a free rank. What do you do?',
      'options': ['Send it — it\'s official support!', 'Send your username but not your password', 'Don\'t send anything — game companies never need your password', 'Send a fake password to trick them'],
      'correct': 2,
      'explanation': 'Real game companies NEVER need your password. Anyone asking for it is a scammer.',
    },
    {
      'emoji': '🛡️',
      'question': 'You accidentally clicked a phishing link. What should you do FIRST?',
      'options': ['Keep browsing and hope it\'s fine', 'Tell a trusted adult straight away', 'Click more links to see what happens', 'Delete the message and forget about it'],
      'correct': 1,
      'explanation': 'Tell an adult immediately — the faster they know, the quicker they can protect your accounts and device.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final q = _questions[_qi];
    final opts = List<String>.from(q['options'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Quiz Time! 🎯',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(20)),
            child: Text('${_qi + 1} / ${_questions.length}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF00695C), fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (_qi + 1) / _questions.length, minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
          ),
        ),
        const SizedBox(height: 24),
        _WhiteCard(child: Column(children: [
          Text(q['emoji'] as String, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          Text(q['question'] as String, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        ])),
        const SizedBox(height: 20),
        ...opts.asMap().entries.map((e) {
          final i = e.key;
          final correct = q['correct'] as int;
          Color bg = Colors.white;
          Color border = const Color(0xFFDDE8F2);
          Color tc = const Color(0xFF1A2E45);
          Widget? trailing;
          if (_answered) {
            if (i == correct) {
              bg = const Color(0xFFD5F5E3); border = const Color(0xFF82E0AA); tc = const Color(0xFF1E8449);
              trailing = const Icon(Icons.check_circle, color: Color(0xFF2ECC71));
            } else if (i == _selected) {
              bg = const Color(0xFFFFEBEB); border = const Color(0xFFFFAAAA); tc = const Color(0xFFB03030);
              trailing = const Icon(Icons.cancel, color: Color(0xFFE74C3C));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: _answered ? null : () => setState(() { _selected = i; _answered = true; }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: border, width: 1.5)),
                child: Row(children: [
                  Container(width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: _answered && i == correct ? const Color(0xFF2ECC71) : const Color(0xFFEFF4FB)),
                    child: Center(child: Text(['A','B','C','D'][i],
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13,
                        color: _answered && i == correct ? Colors.white : const Color(0xFF9AABBF))))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tc))),
                  if (trailing != null) trailing,
                ]),
              ),
            ),
          );
        }),
        if (_answered) ...[
          const SizedBox(height: 8),
          _TipBox(text: q['explanation'] as String),
          const SizedBox(height: 20),
          _NextBtn(
            onTap: () {
              if (_qi < _questions.length - 1) {
                setState(() { _qi++; _selected = null; _answered = false; });
              } else {
                widget.onComplete();
              }
            },
            label: _qi < _questions.length - 1 ? 'Next Question →' : 'See Results! 🎉',
          ),
        ],
      ]),
    );
  }
}

class _CompleteStep extends StatelessWidget {
  final VoidCallback onDone;
  const _CompleteStep({super.key, required this.onDone});

  Future<void> _finish(BuildContext context) async {
    await UserService.instance.saveProgress(
      const LessonProgress(
        lessonId: 'phishing_detective',
        stepsCompleted: 6,
        totalSteps: 6,
        stars: 3,
        completed: true,
      ),
    );
    await XpAward.show(context, lessonId: 'phishing_detective', amount: 150);
    onDone();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
        child: const Text('🏆', style: TextStyle(fontSize: 72)),
      ),
      const SizedBox(height: 24),
      const Text('You did it! 🎉',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text("You've completed Phishing Detective!", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xFF5A7A95))),
      const SizedBox(height: 28),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFFFFDE7), borderRadius: BorderRadius.circular(14)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('⭐', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Text('+150 XP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFE6A817))),
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
      _InfoCard(color: const Color(0xFF26A69A), emoji: '🕵️', title: 'Badge Unlocked: Phishing Detective!',
        body: 'You can now spot a phishing attempt before it catches you!'),
      const SizedBox(height: 16),
      const Align(alignment: Alignment.centerLeft,
        child: Text('What you learned:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45)))),
      const SizedBox(height: 10),
      _SummaryRow(emoji: '🎣', text: 'What phishing is and how it works'),
      _SummaryRow(emoji: '📧', text: 'How to spot fake emails and messages'),
      _SummaryRow(emoji: '🔗', text: 'How to check suspicious links safely'),
      _SummaryRow(emoji: '🛡️', text: 'What to do if you receive a phishing message'),
      _SummaryRow(emoji: '💬', text: '3 real-life chat simulation scenarios'),
      const SizedBox(height: 32),
      _NextBtn(onTap: () => _finish(context), label: '🎉 Claim your XP!'),
    ]),
  );
}

class _SummaryRow extends StatelessWidget {
  final String emoji, text;
  const _SummaryRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95)))),
      const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 18),
    ]),
  );
}

class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Row(mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final double phase = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
        final double b = phase < 0.5 ? phase : 1.0 - phase;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(width: 6 + b * 4, height: 6 + b * 4,
            decoration: const BoxDecoration(color: Color(0xFF9AABBF), shape: BoxShape.circle)),
        );
      }),
    ),
  );
}