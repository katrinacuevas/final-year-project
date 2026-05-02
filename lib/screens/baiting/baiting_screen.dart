import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/xp_award.dart';

class BaitingScreen extends StatefulWidget {
  const BaitingScreen({super.key});

  @override
  State<BaitingScreen> createState() => _BaitingScreenState();
}

class _BaitingScreenState extends State<BaitingScreen> {
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
        title: const Text('Baiting Pro',
          style: TextStyle(color: Color(0xFF1A2E45), fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          if (_currentStep >= 1 && _currentStep <= 6)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('Lesson $_currentStep of 6',
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
      case 5: return _Lesson5(key: const ValueKey(5), onNext: n(6));
      case 6: return _Lesson6(key: const ValueKey(6), onNext: n(7));
      case 7: return _SpotTheBaitActivity(key: const ValueKey(7), onNext: n(8));
      case 8: return _QuizStep(key: const ValueKey(8), onComplete: n(9));
      case 9: return _CompleteStep(key: const ValueKey(9), onDone: () => Navigator.pop(context));
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
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF7F7F)),
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
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.3)),
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
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
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

class _ScenarioCard extends StatelessWidget {
  final String emoji, text;
  final bool isBad;
  const _ScenarioCard({required this.emoji, required this.text, required this.isBad});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: isBad ? const Color(0xFFFFEBEB) : const Color(0xFFD5F5E3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isBad ? const Color(0xFFFFAAAA) : const Color(0xFF82E0AA), width: 1.2),
    ),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600,
        color: isBad ? const Color(0xFFB03030) : const Color(0xFF1E8449)))),
      Icon(isBad ? Icons.cancel : Icons.check_circle,
        color: isBad ? const Color(0xFFE74C3C) : const Color(0xFF2ECC71), size: 20),
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
        decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
        child: const Text('🎁', style: TextStyle(fontSize: 72)),
      ),
      const SizedBox(height: 24),
      const Text('Baiting Pro!', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 12),
      const Text(
        'Learn how tricksters use tempting offers and freebies to trap you — and how to never fall for it! 🪤',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Color(0xFF5A7A95), height: 1.5),
      ),
      const SizedBox(height: 28),
      _InfoCard(color: Colors.red, emoji: '📖', title: "What you'll learn",
        body: "What baiting is, how it works online and in real life, how to spot red flags, and what to do if you see a trap."),
      const SizedBox(height: 12),
      _InfoCard(color: Colors.green, emoji: '⏱️', title: '~20 minutes',
        body: '6 lessons + Spot the Bait activity + quiz at the end!'),
      const SizedBox(height: 12),
      _InfoCard(color: Colors.amber, emoji: '⭐', title: 'Earn up to +200 XP',
        body: 'Complete everything to earn your Baiting Pro badge!'),
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
      _ProgressBar(current: 1, total: 6),
      const SizedBox(height: 24),
      _WhiteCard(child: const Column(children: [
        Text('🪤', style: TextStyle(fontSize: 56)),
        SizedBox(height: 12),
        Text('What is Baiting?', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        SizedBox(height: 10),
        Text(
          'Baiting is when a trickster offers you something tempting — like free games, gifts, or prizes — to get you to do something dangerous, like clicking a bad link or giving away personal info.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95), height: 1.5),
        ),
      ])),
      const SizedBox(height: 20),
      const Text('Think of it like a fishing trap 🎣',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 12),
      _WhiteCard(child: Column(children: const [
        _TrapRow(emoji: '🐟', text: 'A fish sees yummy bait dangling on a hook'),
        _TrapRow(emoji: '🎮', text: 'You see "FREE game skins — click here NOW!"'),
        _TrapRow(emoji: '🪤', text: 'The fish bites and gets caught'),
        _TrapRow(emoji: '😨', text: 'You click and your device gets hacked'),
      ])),
      const SizedBox(height: 16),
      _TipBox(text: 'Baiters know what you like — games, music, free stuff — and use it against you. Always stop and think before you click!'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _TrapRow extends StatelessWidget {
  final String emoji, text;
  const _TrapRow({required this.emoji, required this.text});

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
      _ProgressBar(current: 2, total: 6),
      const SizedBox(height: 24),
      const Text('Baiting Online 💻',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text("Here's how baiters trick people online:",
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _BaitExampleCard(
        emoji: '🎮', color: const Color(0xFFE8D5FB),
        title: 'Free Game Items',
        baitMsg: '"Get 10,000 free V-Bucks! Click here NOW before it expires!"',
        why: 'Hackers know kids love in-game currency. The link installs malware on your device.',
      ),
      const SizedBox(height: 12),
      _BaitExampleCard(
        emoji: '🎵', color: const Color(0xFFB2EBF2),
        title: 'Free Music & Films',
        baitMsg: '"Download any song or movie for free — no account needed!"',
        why: 'Illegal download sites bundle harmful software with the file you download.',
      ),
      const SizedBox(height: 12),
      _BaitExampleCard(
        emoji: '🏆', color: const Color(0xFFFFF9C4),
        title: 'Fake Competitions',
        baitMsg: '"You\'ve been randomly selected! Claim your £500 prize now!"',
        why: 'You never entered a competition. They just want your personal details.',
      ),
      const SizedBox(height: 12),
      _BaitExampleCard(
        emoji: '📱', color: const Color(0xFFDCEDC8),
        title: 'Free Phone / Gadgets',
        baitMsg: '"Win the latest iPhone — just complete this survey!"',
        why: 'Surveys steal your info. Nobody gives away free phones to random strangers.',
      ),
      const SizedBox(height: 16),
      _TipBox(text: 'If a website promises something amazing for free with no catch — the free thing IS the catch.'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _BaitExampleCard extends StatelessWidget {
  final String emoji, title, baitMsg, why;
  final Color color;
  const _BaitExampleCard({required this.emoji, required this.title, required this.baitMsg, required this.why, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFAAAA), width: 1.2),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🚨 ', style: TextStyle(fontSize: 14)),
              Expanded(child: Text('"$baitMsg"',
                style: const TextStyle(fontSize: 13, color: Color(0xFFB03030), fontStyle: FontStyle.italic, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('⚠️ ', style: TextStyle(fontSize: 14)),
            Expanded(child: Text(why, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4))),
          ]),
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
      _ProgressBar(current: 3, total: 6),
      const SizedBox(height: 24),
      const Text('Baiting in Real Life 🌍',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text("Baiting doesn't just happen online!",
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _WhiteCard(child: Column(children: const [
        Text('🖲️', style: TextStyle(fontSize: 52)),
        SizedBox(height: 12),
        Text('The USB Stick Trick', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
        SizedBox(height: 8),
        Text(
          'A hacker leaves a USB stick on the floor labelled "FREE GAMES" or "SECRET FILES". Someone picks it up and plugs it into their computer...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95), height: 1.5),
        ),
        SizedBox(height: 12),
        _ResultRow(emoji: '💻', text: 'Their computer gets infected instantly'),
        _ResultRow(emoji: '🔓', text: 'The hacker can access all their files'),
        _ResultRow(emoji: '📷', text: 'Even the camera could be turned on secretly'),
      ])),
      const SizedBox(height: 20),
      const Text('Other real-life baiting tricks:',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 10),
      _InfoCard(color: Colors.orange, emoji: '📀', title: 'Free CDs or Leaflets',
        body: 'A free disc or flyer with a QR code that leads to a dangerous website.'),
      const SizedBox(height: 8),
      _InfoCard(color: Colors.purple, emoji: '🎁', title: 'Suspicious "prize" packages',
        body: '"You\'ve won a prize — pick it up at this address!" Used to collect your details or lure you somewhere unsafe.'),
      const SizedBox(height: 16),
      _TipBox(text: 'NEVER plug in a USB stick you found — even if it looks exciting. Give it to a trusted adult straight away.'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
    ]),
  );
}

class _ResultRow extends StatelessWidget {
  final String emoji, text;
  const _ResultRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95)))),
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
      _ProgressBar(current: 4, total: 6),
      const SizedBox(height: 24),
      const Text('Spot the Red Flags 🚩',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text('These warning signs mean something is probably a trap:',
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _RedFlagCard(flag: '⏰ Countdown timers', detail: '"Only 5 minutes left!" — rushing you stops you from thinking clearly.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🆓 Too good to be true', detail: 'Free phones, free money, free premium games — nobody gives these away to strangers.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🔗 Suspicious links', detail: 'Strange URLs like "fr33-v-bucks.xyz" instead of official game websites.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '📝 Asking for personal info', detail: '"Just fill in your name, school, and address to claim!" — real prizes don\'t need all this.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '🎰 "You\'ve been selected!"', detail: 'You can\'t win something you never entered. This is almost always fake.'),
      const SizedBox(height: 10),
      _RedFlagCard(flag: '😮 Creates excitement or panic', detail: 'Baiters want you to act fast without thinking. Big emotions = big mistakes.'),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD5F5E3), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF82E0AA)),
        ),
        child: const Row(children: [
          Text('🛑', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(child: Text(
            'When you spot a red flag — STOP. Don\'t click, don\'t share, don\'t reply. Tell a trusted adult.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E6B3A), height: 1.4),
          )),
        ]),
      ),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
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
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      border: Border.all(color: const Color(0xFFFFCDD2), width: 1.2),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFB03030))),
      const SizedBox(height: 5),
      Text(detail, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
    ]),
  );
}


class _Lesson5 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson5({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 5, total: 6),
      const SizedBox(height: 24),
      const Text('What To Do 🛡️',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text("If you think you've spotted a bait — follow these steps:",
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 16),
      _StepCard(number: '1', emoji: '🛑', color: const Color(0xFFFFEBEB),
        title: 'STOP what you\'re doing',
        body: 'Close the tab, put down the device. Don\'t click anything else.'),
      const SizedBox(height: 10),
      _StepCard(number: '2', emoji: '🤔', color: const Color(0xFFFFF9C4),
        title: 'Ask yourself: Does this make sense?',
        body: 'Did I enter a competition? Is this an official website? Would a real company do this?'),
      const SizedBox(height: 10),
      _StepCard(number: '3', emoji: '🗣️', color: const Color(0xFFE8D5FB),
        title: 'Tell a trusted adult',
        body: 'Show a parent, carer, or teacher. They can help check if it\'s real or report it.'),
      const SizedBox(height: 10),
      _StepCard(number: '4', emoji: '🚫', color: const Color(0xFFB2EBF2),
        title: 'Block and report',
        body: 'If someone sent you a bait message online, block them and use the report button.'),
      const SizedBox(height: 10),
      _StepCard(number: '5', emoji: '📵', color: const Color(0xFFDCEDC8),
        title: 'Never go back',
        body: 'Even if you\'re curious — don\'t revisit the link or message. The bait is still there.'),
      const SizedBox(height: 16),
      _TipBox(text: 'If you already clicked something by mistake — tell an adult straight away. The faster they know, the quicker they can help protect your device.'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext),
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
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
        decoration: const BoxDecoration(color: Color(0xFFFF7F7F), shape: BoxShape.circle),
        child: Center(child: Text(number,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)))),
    ]),
  );
}



class _Lesson6 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson6({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ProgressBar(current: 6, total: 6),
      const SizedBox(height: 24),
      const Text('Real vs Fake Rewards 🔍',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text('Not everything is a trap — here\'s how to tell the difference:',
        style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD5F5E3), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF82E0AA)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('✅ Real Rewards', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E6B3A))),
          const SizedBox(height: 10),
          _CompareRow(emoji: '🌐', text: 'Come from official, well-known websites'),
          _CompareRow(emoji: '📧', text: 'Sent to email addresses you registered with'),
          _CompareRow(emoji: '⏳', text: 'No extreme time pressure — they give you days'),
          _CompareRow(emoji: '🔒', text: 'Only ask for info you\'d expect (e.g. delivery address)'),
          _CompareRow(emoji: '📞', text: 'You can verify by calling the official company'),
        ]),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFAAAA)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('❌ Fake Bait', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFB03030))),
          const SizedBox(height: 10),
          _CompareRow(emoji: '🔗', text: 'Comes from strange, unofficial links'),
          _CompareRow(emoji: '📨', text: 'Sent randomly to anyone — you never signed up'),
          _CompareRow(emoji: '⏰', text: 'Extreme urgency — "5 minutes left!"'),
          _CompareRow(emoji: '📋', text: 'Wants your school, address, and passwords'),
          _CompareRow(emoji: '🚫', text: 'No official contact number to verify with'),
        ]),
      ),
      const SizedBox(height: 16),
      _TipBox(text: 'When in doubt — don\'t act alone. A trusted adult can help you figure out if something is real in seconds.'),
      const SizedBox(height: 32),
      _NextBtn(onTap: onNext, label: 'Activity: Spot the Bait! 🎯'),
    ]),
  );
}

class _CompareRow extends StatelessWidget {
  final String emoji, text;
  const _CompareRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2E45), height: 1.3))),
    ]),
  );
}


class _SpotTheBaitActivity extends StatefulWidget {
  final VoidCallback onNext;
  const _SpotTheBaitActivity({super.key, required this.onNext});

  @override
  State<_SpotTheBaitActivity> createState() => _SpotTheBaitActivityState();
}

class _SpotTheBaitActivityState extends State<_SpotTheBaitActivity> {
  final List<Map<String, dynamic>> _items = [
    {
      'text': '🎮 "Win FREE Robux! Click this link now — only 3 minutes left!!"',
      'isBait': true,
      'explanation': 'Countdown timer + free currency + suspicious link = classic bait!',
    },
    {
      'text': '📧 "Your school newsletter is ready to read on the school website."',
      'isBait': false,
      'explanation': 'This is a normal, legitimate message from your school. No red flags here.',
    },
    {
      'text': '🏆 "Congratulations! You\'ve been chosen to receive a FREE iPad — claim before midnight!"',
      'isBait': true,
      'explanation': 'You never entered anything, and the midnight deadline is a pressure trick.',
    },
    {
      'text': '🎵 "Download ALL songs for free at fr33music.xyz — no account needed!"',
      'isBait': true,
      'explanation': 'Illegal download sites and dodgy URLs like "fr33music.xyz" are bait.',
    },
    {
      'text': '📚 "Your library book is due back next Tuesday."',
      'isBait': false,
      'explanation': 'A simple, expected reminder from a trusted source — completely fine!',
    },
    {
      'text': '🖲️ "Found this USB on the floor labelled FUNNY VIDEOS — shall we plug it in?"',
      'isBait': true,
      'explanation': 'Never plug in unknown USB sticks — this is a real baiting technique used by hackers!',
    },
    {
      'text': '📱 "Fortnite official: Your new season battle pass is now active. Log in at fortnite.com."',
      'isBait': false,
      'explanation': 'This links to the official Fortnite website with no suspicious pressure or requests.',
    },
    {
      'text': '💰 "Someone has transferred £200 to you! Enter your bank details to claim it NOW."',
      'isBait': true,
      'explanation': 'Never enter bank or personal details for unexpected money. This is a scam.',
    },
  ];

  final Map<int, bool?> _answers = {};
  bool get _allAnswered => _answers.length == _items.length;
  int get _score => _answers.entries.where((e) => e.value == (_items[e.key]['isBait'] as bool)).length;

  void _tap(int i, bool answer) {
    if (_answers.containsKey(i)) return;
    setState(() => _answers[i] = answer);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🎯', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          const Expanded(child: Text('Spot the Bait!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45)))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(20)),
            child: Text('${_answers.length}/${_items.length}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFB03030), fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 6),
        const Text('For each message, tap 🎣 BAIT or ✅ SAFE',
          style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
        const SizedBox(height: 20),

        ..._items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          final answered = _answers.containsKey(i);
          final correct = item['isBait'] as bool;
          final wasCorrect = answered ? (_answers[i] == correct) : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: answered
                  ? Border.all(color: wasCorrect! ? const Color(0xFF82E0AA) : const Color(0xFFFFAAAA), width: 2)
                  : Border.all(color: const Color(0xFFDDE8F2), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(item['text'] as String,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E45), height: 1.4)),
                ),

                if (!answered) ...[
                  const Divider(height: 1, color: Color(0xFFEFF4FB)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tap(i, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: Text('🎣  BAIT',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFB03030)))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tap(i, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(color: const Color(0xFFD5F5E3), borderRadius: BorderRadius.circular(12)),
                            child: const Center(child: Text('✅  SAFE',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF27AE60)))),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(wasCorrect! ? Icons.check_circle : Icons.cancel,
                          color: wasCorrect ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C), size: 18),
                        const SizedBox(width: 6),
                        Text(wasCorrect ? 'Correct! 🎉' : 'Not quite!',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                            color: wasCorrect ? const Color(0xFF27AE60) : const Color(0xFFB03030))),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: correct ? const Color(0xFFFFEBEB) : const Color(0xFFD5F5E3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(correct ? '🎣 Was BAIT' : '✅ Was SAFE',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: correct ? const Color(0xFFB03030) : const Color(0xFF27AE60))),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text(item['explanation'] as String,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
                    ]),
                  ),
                ],
              ]),
            ),
          );
        }),

        if (_allAnswered) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _score >= 6 ? const Color(0xFFD5F5E3) : const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _score >= 6 ? const Color(0xFF82E0AA) : Colors.amber.shade200),
            ),
            child: Row(children: [
              Text(_score == 8 ? '🏆' : _score >= 6 ? '🌟' : '💪', style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$_score / ${_items.length} correct!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                Text(
                  _score == 8 ? 'Perfect — you\'re a Bait Detector!'
                  : _score >= 6 ? 'Great job! Keep practising.'
                  : 'Good try — review the lessons and try again!',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95))),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          _NextBtn(onTap: widget.onNext, label: 'Quiz Time! 🎯'),
        ],
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
      'emoji': '🤔',
      'question': 'What is "baiting" in cybersecurity?',
      'options': ['Fishing in real life', 'Using tempting offers to trick you into doing something dangerous', 'A type of computer virus', 'Sending too many emails'],
      'correct': 1,
      'explanation': 'Baiting uses tempting things (free items, prizes) to make you click bad links or share personal info.',
    },
    {
      'emoji': '🖲️',
      'question': 'You find a USB stick on the floor labelled "FREE GAMES". What do you do?',
      'options': ['Plug it in straight away!', 'Give it to a trusted adult without plugging it in', 'Try it on a friend\'s computer instead', 'Look at it and then throw it away'],
      'correct': 1,
      'explanation': 'Never plug in unknown USB sticks. Give it to a trusted adult — it could contain malware.',
    },
    {
      'emoji': '⏰',
      'question': 'A message says "Claim your FREE prize in the next 5 minutes or it\'s gone!" What is the countdown timer designed to do?',
      'options': ['Help you win faster', 'Stop you from thinking clearly', 'Show the prize is real', 'Give you extra time'],
      'correct': 1,
      'explanation': 'Countdown timers rush you into acting without thinking — that\'s exactly what baiters want.',
    },
    {
      'emoji': '🔗',
      'question': 'Which of these links looks suspicious?',
      'options': ['minecraft.net/download', 'fr33-v-bucks.xyz/claim', 'bbc.co.uk/news', 'google.com'],
      'correct': 1,
      'explanation': '"fr33-v-bucks.xyz" is not an official website. Real game items always come from official sites.',
    },
    {
      'emoji': '✅',
      'question': 'Which of these is a sign that a reward is REAL and not bait?',
      'options': ['It came from a random message you weren\'t expecting', 'It links to an official website you recognise', 'It has a 10-minute countdown timer', 'It asks for your school name and address'],
      'correct': 1,
      'explanation': 'Real rewards come from official websites you recognise, with no extreme pressure or unexpected personal info requests.',
    },
    {
      'emoji': '😨',
      'question': 'You accidentally clicked a suspicious link. What should you do FIRST?',
      'options': ['Keep browsing and hope nothing happens', 'Tell a trusted adult straight away', 'Click more links to see what it does', 'Delete your browser history and forget about it'],
      'correct': 1,
      'explanation': 'Tell a trusted adult immediately — the faster they know, the quicker they can protect your device.',
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
            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(20)),
            child: Text('${_qi + 1} / ${_questions.length}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFB03030), fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (_qi + 1) / _questions.length, minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF7F7F)),
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
        lessonId: 'baiting_pro',
        stepsCompleted: 6,
        totalSteps: 6,
        stars: 3,
        completed: true,
      ),
    );
    await XpAward.show(
      context,
      lessonId: 'baiting_pro',
      amount: 400,
    );
    onDone();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
        child: const Text('🏆', style: TextStyle(fontSize: 72)),
      ),
      const SizedBox(height: 24),
      const Text('You did it! 🎉',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
      const SizedBox(height: 8),
      const Text("You've completed Baiting Pro!", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xFF5A7A95))),
      const SizedBox(height: 28),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFFFFDE7), borderRadius: BorderRadius.circular(14)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('⭐', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Text('+200 XP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFE6A817))),
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
      _InfoCard(color: Colors.red, emoji: '🎁', title: 'Badge Unlocked: Baiting Pro!',
        body: 'You can now spot a baiting trap before it catches you!'),
      const SizedBox(height: 16),
      const Align(alignment: Alignment.centerLeft,
        child: Text('What you learned:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45)))),
      const SizedBox(height: 10),
      _SummaryRow(emoji: '🪤', text: 'What baiting is and how it works'),
      _SummaryRow(emoji: '💻', text: 'Online baiting examples'),
      _SummaryRow(emoji: '🖲️', text: 'Physical baiting: USB sticks and real-world traps'),
      _SummaryRow(emoji: '🚩', text: 'How to spot red flags'),
      _SummaryRow(emoji: '🛡️', text: 'What to do when you spot a bait'),
      _SummaryRow(emoji: '🔍', text: 'Real vs fake rewards'),
      _SummaryRow(emoji: '🎯', text: 'Spot the Bait activity'),
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