import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/xp_award.dart';



class PretextingScreen extends StatefulWidget {
  const PretextingScreen({super.key});

  @override
  State<PretextingScreen> createState() => _PretextingScreenState();
}

class _PretextingScreenState extends State<PretextingScreen> {
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
        title: const Text('Pretexting',
            style: TextStyle(
                color: Color(0xFF1A2E45),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
        actions: [
          if (_currentStep >= 1 && _currentStep <= 4)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text('Lesson $_currentStep of 4',
                    style: const TextStyle(
                        color: Color(0xFF7A9BB5),
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    n(int s) => () => setState(() => _currentStep = s);
    switch (_currentStep) {
      case 0:
        return _IntroStep(key: const ValueKey(0), onNext: n(1));
      case 1:
        return _Lesson1(key: const ValueKey(1), onNext: n(2));
      case 2:
        return _Lesson2(key: const ValueKey(2), onNext: n(3));
      case 3:
        return _Lesson3(key: const ValueKey(3), onNext: n(4));
      case 4:
        return _Lesson4(key: const ValueKey(4), onNext: n(5));
      case 5:
        return _FinalChallenge(key: const ValueKey(5), onComplete: n(6));
      case 6:
        return _QuizStep(key: const ValueKey(6), onComplete: n(7));
      case 7:
        return _CompleteStep(
            key: const ValueKey(7), onDone: () => Navigator.pop(context));
      default:
        return const SizedBox();
    }
  }
}



const _accent = Color(0xFFB39DDB);
const _accentDark = Color(0xFF7C4DFF);

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Progress',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600)),
          Text('$current / $total',
              style:
                  TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                const AlwaysStoppedAnimation<Color>(_accent),
          ),
        ),
      ]);
}

class _NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const _NextBtn(
      {required this.onTap,
      this.label = 'Next →',
      this.enabled = true});

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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const _InfoCard(
      {required this.color,
      required this.emoji,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A2E45))),
                const SizedBox(height: 4),
                Text(body,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5A7A95),
                        height: 1.4)),
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
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
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
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A6020),
                      height: 1.4))),
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
            decoration: const BoxDecoration(
                color: Color(0xFFF0EBFF), shape: BoxShape.circle),
            child:
                const Text('🎭', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 24),
          const Text('Pretexting',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          const Text(
            'Learn how tricksters pretend to be someone else to fool you — and how to see through their disguise! 🕵️',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: Color(0xFF5A7A95),
                height: 1.5),
          ),
          const SizedBox(height: 28),
          _InfoCard(
              color: Colors.purple,
              emoji: '📖',
              title: "What you'll learn",
              body:
                  "What pretexting is, how people fake identities online, how to spot impersonation, and how to trust your instincts when something feels off."),
          const SizedBox(height: 12),
          _InfoCard(
              color: Colors.green,
              emoji: '⏱️',
              title: '~18 minutes',
              body:
                  '4 lessons + Final Challenge (chat simulation) + quiz!'),
          const SizedBox(height: 12),
          _InfoCard(
              color: Colors.amber,
              emoji: '⭐',
              title: 'Earn up to +180 XP',
              body:
                  'Complete everything to earn your Pretexting Detective badge!'),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _ProgressBar(current: 1, total: 4),
          const SizedBox(height: 24),
          _WhiteCard(
              child: const Column(children: [
            Text('🎭', style: TextStyle(fontSize: 56)),
            SizedBox(height: 12),
            Text('What is Pretexting?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E45))),
            SizedBox(height: 10),
            Text(
              'Pretexting is when a trickster invents a fake story — called a "pretext" — and pretends to be someone they\'re not, to get you to share information or do something you wouldn\'t normally do.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5A7A95),
                  height: 1.5),
            ),
          ])),
          const SizedBox(height: 20),
          const Text('A real example 🎬',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          _StoryPanel(
            steps: const [
              _StoryStep(
                  emoji: '📞',
                  speaker: 'Trickster',
                  text:
                      '"Hi, I\'m calling from your school IT department. We\'re upgrading the system and need your login details."'),
              _StoryStep(
                  emoji: '😮',
                  speaker: 'You',
                  text:
                      '"Oh! The school IT team? Sure, my username is..."'),
              _StoryStep(
                  emoji: '😈',
                  speaker: 'Reality',
                  text:
                      'It was never the school. They made up the story to steal your login.'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Why does it work?',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 10),
          _InfoCard(
              color: Colors.purple,
              emoji: '🤝',
              title: 'We trust authority figures',
              body:
                  'Teachers, IT staff, doctors, police — we\'re taught to trust them. Pretexters pretend to be these people.'),
          const SizedBox(height: 8),
          _InfoCard(
              color: Colors.blue,
              emoji: '⚡',
              title: 'They create urgency',
              body:
                  '"This needs to happen right now!" — rushing you stops you from stopping to think.'),
          const SizedBox(height: 8),
          _InfoCard(
              color: Colors.orange,
              emoji: '🧠',
              title: 'They know a little about you',
              body:
                  'Knowing your school name or teacher\'s name makes the fake story more believable.'),
          const SizedBox(height: 16),
          _TipBox(
              text:
                  'Anyone can CLAIM to be anyone online or on the phone. Always verify before sharing anything.'),
          const SizedBox(height: 32),
          _NextBtn(onTap: onNext),
        ]),
      );
}

class _StoryStep {
  final String emoji, speaker, text;
  const _StoryStep(
      {required this.emoji,
      required this.speaker,
      required this.text});
}

class _StoryPanel extends StatelessWidget {
  final List<_StoryStep> steps;
  const _StoryPanel({required this.steps});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: steps.asMap().entries.map((e) {
            final s = e.value;
            final isLast = e.key == steps.length - 1;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isLast
                          ? const Color(0xFFFFEBEB)
                          : const Color(0xFFF0EBFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(s.emoji,
                            style: const TextStyle(fontSize: 18))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(s.speaker,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isLast
                                    ? const Color(0xFFB03030)
                                    : const Color(0xFF7C4DFF))),
                        const SizedBox(height: 3),
                        Text(s.text,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1A2E45),
                                height: 1.4)),
                      ])),
                ]),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.only(left: 33),
                  child: Icon(Icons.arrow_downward,
                      color: Color(0xFFCDD8E3), size: 16),
                ),
            ]);
          }).toList(),
        ),
      );
}


class _Lesson2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _ProgressBar(current: 2, total: 4),
          const SizedBox(height: 24),
          const Text('Fake Identities 🪪',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text(
              'Pretexters put on many disguises. Here\'s who they pretend to be:',
              style:
                  TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 16),
          _FakeIDCard(
            emoji: '👮',
            role: 'Fake Police / Authority',
            color: const Color(0xFFBBDEFB),
            script:
                '"This is the police. We\'re investigating an incident at your school. We need your home address immediately."',
            clue:
                'Real police never contact children directly online or by text to ask for personal details.',
          ),
          const SizedBox(height: 12),
          _FakeIDCard(
            emoji: '🧑‍💻',
            role: 'Fake IT / Tech Support',
            color: const Color(0xFFDCEDC8),
            script:
                '"I\'m from the school IT team. Your account has a virus — send me your password so I can fix it."',
            clue:
                'Real IT staff never need your password. They can reset it themselves.',
          ),
          const SizedBox(height: 12),
          _FakeIDCard(
            emoji: '🏆',
            role: 'Fake Competition Organiser',
            color: const Color(0xFFFFF9C4),
            script:
                '"Congratulations! I\'m calling about your prize. I just need your parent\'s bank details to transfer the winnings."',
            clue:
                'Real competitions never ask for bank details over the phone or via a message.',
          ),
          const SizedBox(height: 12),
          _FakeIDCard(
            emoji: '👫',
            role: 'Fake Friend / Classmate',
            color: const Color(0xFFF0EBFF),
            script:
                '"Hey, it\'s me from school! I lost my phone — can you tell me your address? I want to send your birthday card."',
            clue:
                'Real friends don\'t suddenly ask for your address out of nowhere. Verify by calling them directly.',
          ),
          const SizedBox(height: 16),
          _TipBox(
              text:
                  'The more official or familiar someone sounds, the more suspicious you should be if they\'re asking for personal information.'),
          const SizedBox(height: 32),
          _NextBtn(onTap: onNext),
        ]),
      );
}

class _FakeIDCard extends StatelessWidget {
  final String emoji, role, script, clue;
  final Color color;
  const _FakeIDCard(
      {required this.emoji,
      required this.role,
      required this.script,
      required this.clue,
      required this.color});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18))),
            child: Row(children: [
              Text(emoji,
                  style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Text(role,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFB39DDB), width: 1.2),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('🎭 ',
                      style: TextStyle(fontSize: 14)),
                  Expanded(
                      child: Text('"$script"',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5A2D9A),
                              fontStyle: FontStyle.italic,
                              height: 1.4))),
                ]),
              ),
              const SizedBox(height: 10),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('🔍 ',
                    style: TextStyle(fontSize: 14)),
                Expanded(
                    child: Text(clue,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5A7A95),
                            height: 1.4))),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _ProgressBar(current: 3, total: 4),
          const SizedBox(height: 24),
          const Text('Impersonation Online 💻',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text(
              'Online, pretexters have even more ways to fake who they are:',
              style:
                  TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 16),

          _WhiteCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            const Text('🖼️ Fake Social Media Profiles',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E45))),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFB39DDB), width: 1.2),
              ),
              child: Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8D5FB),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                      child:
                          Text('👧', style: TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text('Sophie_Year8 ✓',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xFF1A2E45))),
                  Text('Goes to Westfield Academy 🏫',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF7A9BB5))),
                  Text('Loves Minecraft & football ⚽',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF7A9BB5))),
                ])),
              ]),
            ),
            const SizedBox(height: 12),
            _BulletPoint(
                text:
                    'This profile looks real — but it was made in minutes'),
            _BulletPoint(
                text:
                    'The photo is stolen from someone else\'s account'),
            _BulletPoint(
                text:
                    'The school name was guessed from your own profile'),
            _BulletPoint(
                text:
                    'The "✓" tick means nothing — anyone can add it'),
          ])),
          const SizedBox(height: 16),

          _WhiteCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            const Text('📧 Fake Emails That Look Official',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E45))),
            const SizedBox(height: 12),
            _EmailMockup(
              from: 'support@sch00l-help.com',
              subject: 'Important: Your school account needs updating',
              body:
                  'Dear student, please click the link below to verify your account within 24 hours or it will be deactivated.',
              isReal: false,
            ),
            const SizedBox(height: 10),
            _EmailMockup(
              from: 'itsupport@westfieldacademy.co.uk',
              subject: 'Scheduled maintenance this weekend',
              body:
                  'Please note the school portal will be offline Saturday 9am–1pm for scheduled updates. No action required.',
              isReal: true,
            ),
            const SizedBox(height: 10),
            _TipBox(
                text:
                    'Always check the full email address — "sch00l-help.com" uses zeros instead of the letter o to trick you!'),
          ])),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD5F5E3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF82E0AA)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('🔐 How to verify if someone is real:',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E6B3A))),
              const SizedBox(height: 10),
              _VerifyRow(
                  emoji: '📞',
                  text:
                      'Call the real organisation using a number from their official website'),
              _VerifyRow(
                  emoji: '👨‍👩‍👧',
                  text:
                      'Ask a trusted adult to check the message with you'),
              _VerifyRow(
                  emoji: '🌐',
                  text:
                      'Visit the official website directly — don\'t click the link in the message'),
              _VerifyRow(
                  emoji: '🤔',
                  text:
                      'Ask yourself: Would the real organisation actually send this?'),
            ]),
          ),
          const SizedBox(height: 32),
          _NextBtn(onTap: onNext),
        ]),
      );
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Color(0xFFB03030), shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5A7A95),
                      height: 1.4))),
        ]),
      );
}

class _EmailMockup extends StatelessWidget {
  final String from, subject, body;
  final bool isReal;
  const _EmailMockup(
      {required this.from,
      required this.subject,
      required this.body,
      required this.isReal});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isReal
              ? const Color(0xFFD5F5E3)
              : const Color(0xFFFFEBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isReal
                  ? const Color(0xFF82E0AA)
                  : const Color(0xFFFFAAAA),
              width: 1.5),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(children: [
            Icon(isReal ? Icons.check_circle : Icons.warning,
                color: isReal
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFE74C3C),
                size: 14),
            const SizedBox(width: 5),
            Text(isReal ? 'Looks legitimate ✅' : 'Suspicious ❌',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isReal
                        ? const Color(0xFF27AE60)
                        : const Color(0xFFB03030))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Text('From: ',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A9BB5))),
            Expanded(
                child: Text(from,
                    style: TextStyle(
                        fontSize: 11,
                        color: isReal
                            ? const Color(0xFF1A2E45)
                            : const Color(0xFFB03030),
                        fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 3),
          Row(children: [
            const Text('Subject: ',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A9BB5))),
            Expanded(
                child: Text(subject,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF1A2E45)))),
          ]),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A7A95),
                  height: 1.4)),
        ]),
      );
}

class _VerifyRow extends StatelessWidget {
  final String emoji, text;
  const _VerifyRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A4A2A),
                      height: 1.4))),
        ]),
      );
}


class _Lesson4 extends StatelessWidget {
  final VoidCallback onNext;
  const _Lesson4({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _ProgressBar(current: 4, total: 4),
          const SizedBox(height: 24),
          const Text('Trust Your Instincts 🧠',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text(
              'Your gut feeling is one of your best defences against pretexting.',
              style:
                  TextStyle(fontSize: 14, color: Color(0xFF5A7A95))),
          const SizedBox(height: 20),

          _WhiteCard(
              child: const Column(children: [
            Text('🤨', style: TextStyle(fontSize: 52)),
            SizedBox(height: 10),
            Text('That funny feeling is there for a reason',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E45))),
            SizedBox(height: 8),
            Text(
              'If something feels a bit off — even if you can\'t explain why — that feeling is important. Pretexters are very good at sounding convincing, but your instincts can still notice the signs.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A7A95),
                  height: 1.5),
            ),
          ])),
          const SizedBox(height: 20),
          const Text('Warning feelings to listen to:',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          _InstinctCard(
              emoji: '😬',
              feeling: 'This feels rushed',
              detail:
                  '"They keep saying I need to do it NOW." Real, legitimate requests always give you time to think and check.'),
          const SizedBox(height: 10),
          _InstinctCard(
              emoji: '🤔',
              feeling: 'Why do they need this from me?',
              detail:
                  'Your school already has your details. Your bank already knows your account number. Why would they ask again?'),
          const SizedBox(height: 10),
          _InstinctCard(
              emoji: '😟',
              feeling: 'Something doesn\'t add up',
              detail:
                  'Small inconsistencies — wrong name, slightly odd wording, strange timing — are signs a story might be fake.'),
          const SizedBox(height: 10),
          _InstinctCard(
              emoji: '🫣',
              feeling: 'I\'d feel embarrassed telling a parent',
              detail:
                  'If you\'d feel uncomfortable telling a trusted adult about the conversation — that\'s a big sign something is wrong.'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFB39DDB), width: 1.5),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('The PAUSE rule 🛑',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5A2D9A))),
              const SizedBox(height: 10),
              _PauseRow(letter: 'P', word: 'Pause', desc: 'Stop what you\'re doing'),
              _PauseRow(letter: 'A', word: 'Ask', desc: 'Ask yourself if this makes sense'),
              _PauseRow(letter: 'U', word: 'Understand', desc: 'Think about why they want this info'),
              _PauseRow(letter: 'S', word: 'Seek help', desc: 'Tell a trusted adult before doing anything'),
              _PauseRow(letter: 'E', word: 'Exit', desc: 'Leave the conversation if something feels wrong'),
            ]),
          ),
          const SizedBox(height: 16),
          _TipBox(
              text:
                  'It\'s ALWAYS okay to say "I\'ll check with a parent first." A real person with good intentions will be happy to wait.'),
          const SizedBox(height: 32),
          _NextBtn(onTap: onNext, label: 'Final Challenge 🎭'),
        ]),
      );
}

class _InstinctCard extends StatelessWidget {
  final String emoji, feeling, detail;
  const _InstinctCard(
      {required this.emoji,
      required this.feeling,
      required this.detail});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
          border: Border.all(
              color: const Color(0xFFE8D5FB), width: 1.2),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child:
                    Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Text('"$feeling"',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5A2D9A))),
            const SizedBox(height: 3),
            Text(detail,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A7A95),
                    height: 1.4)),
          ])),
        ]),
      );
}

class _PauseRow extends StatelessWidget {
  final String letter, word, desc;
  const _PauseRow(
      {required this.letter,
      required this.word,
      required this.desc});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
                color: Color(0xFF7C4DFF), shape: BoxShape.circle),
            child: Center(
                child: Text(letter,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13))),
          ),
          const SizedBox(width: 10),
          Text('$word — ',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2E45))),
          Expanded(
              child: Text(desc,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF5A7A95)))),
        ]),
      );
}



class _FinalChallenge extends StatefulWidget {
  final VoidCallback onComplete;
  const _FinalChallenge(
      {super.key, required this.onComplete});

  @override
  State<_FinalChallenge> createState() => _FinalChallengeState();
}

class _FinalChallengeState extends State<_FinalChallenge> {
  int _scenario = 0; 
  int _msgStep = 0;
  int? _choice;
  bool _showFeedback = false;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'Scenario 1: The "IT Teacher"',
      'messages': [
        {'from': 'stranger', 'text': 'Hi! I\'m Mr Davies, the new IT cover teacher. I\'m doing an account audit today 🖥️'},
        {'from': 'you', 'text': '...'},
        {'from': 'stranger', 'text': 'I just need to verify your school login. Can you tell me your username and password? It\'ll only take a second!'},
        {'from': 'stranger', 'text': 'Don\'t worry, it\'s completely routine — I just need to confirm everything is set up right for you 😊'},
        {'from': 'you', 'text': '...'},
      ],
      'question': 'What do you do?',
      'choices': [
        'Sure, my username is jamie123 and my password is...',
        'I\'ll give you my username but not my password',
        'I don\'t share my login with anyone — I\'ll check with my real teacher first',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'emoji': '😨',
          'title': 'That\'s very dangerous!',
          'points': [
            'Real teachers and IT staff NEVER need your password',
            'This person could now log into your account and change everything',
            'Always verify someone\'s identity before sharing any login details',
          ],
        },
        {
          'safe': false,
          'emoji': '😬',
          'title': 'Safer — but still risky!',
          'points': [
            'Your username can still be misused on its own',
            'A real IT teacher would not ask for this via a message',
            'The safest answer is always to check with a trusted adult first',
          ],
        },
        {
          'safe': true,
          'emoji': '🛡️',
          'title': 'Excellent! You spotted the pretext! 🎉',
          'points': [
            'IT staff never need your password — they have admin tools',
            'You correctly decided to verify through a trusted adult',
            'This is exactly what the PAUSE rule looks like in action!',
          ],
        },
      ],
    },
    {
      'title': 'Scenario 2: The "Old Friend"',
      'messages': [
        {'from': 'stranger', 'text': 'Heyyy! It\'s Mia from your old primary school 😄 Do you remember me??'},
        {'from': 'you', 'text': 'Oh hey! I think I remember you?'},
        {'from': 'stranger', 'text': 'Yes! We were in the same class! I moved away. I\'ve been trying to find everyone. Can I add you on Instagram?'},
        {'from': 'stranger', 'text': 'Also — do you still live near the park on Maple Road? That\'s where you used to live right? I want to send you a card!'},
        {'from': 'you', 'text': '...'},
      ],
      'question': 'How do you respond?',
      'choices': [
        'Yes I\'m on Instagram! And yes I still live near Maple Road 😊',
        'I\'ll add you on Instagram but I\'m not giving out my address',
        'I don\'t recognise you — I\'m not sharing anything until I\'ve checked with a parent',
      ],
      'correct': 2,
      'feedback': [
        {
          'safe': false,
          'emoji': '🚨',
          'title': 'That\'s a lot of personal info to share!',
          'points': [
            'You confirmed your home address to a stranger — this is very unsafe',
            'Pretexters build trust first, then extract information step by step',
            'You can\'t verify someone is who they say they are based on a message',
          ],
        },
        {
          'safe': false,
          'emoji': '😬',
          'title': 'Good instinct on the address — but stay cautious!',
          'points': [
            'Adding an unverified stranger on social media still carries risk',
            'They could use your Instagram to gather more info about you',
            'Check with a parent before adding anyone you don\'t fully remember',
          ],
        },
        {
          'safe': true,
          'emoji': '🛡️',
          'title': 'Perfect response! Safety first! 🎉',
          'points': [
            'You didn\'t confirm your address or share personal details',
            'Checking with a parent is always the right call when unsure',
            'Even if it really was an old friend — they\'d understand you being careful!',
          ],
        },
      ],
    },
  ];

  Map<String, dynamic> get _current => _scenarios[_scenario];
  List get _messages => _current['messages'] as List;
  bool get _allMsgsShown => _msgStep >= _messages.length - 1;

  void _nextScenario() {
    if (_scenario == 0) {
      setState(() {
        _scenario = 1;
        _msgStep = 0;
        _choice = null;
        _showFeedback = false;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fb = _showFeedback
        ? (_current['feedback'] as List)[_choice!] as Map
        : null;
    return Column(children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(children: [
          const Text('🎭', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            const Text('Final Challenge',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2E45))),
            Text(_current['title'] as String,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF7A9BB5))),
          ])),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(20)),
            child: Text('${_scenario + 1}/2',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C4DFF),
                    fontSize: 13)),
          ),
        ]),
      ),

      Expanded(
        child: GestureDetector(
          onTap: (_allMsgsShown || _showFeedback)
              ? null
              : () => setState(() => _msgStep++),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (int i = 0; i <= _msgStep; i++)
                _buildBubble(_messages[i] as Map<String, dynamic>),
              if (!_allMsgsShown && !_showFeedback)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Tap to continue...',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9AABBF),
                            fontStyle: FontStyle.italic)),
                  )),
                ),
            ],
          ),
        ),
      ),

      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        child: _showFeedback
            ? _buildFeedback(fb!, _scenario == 1)
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
        mainAxisAlignment:
            isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isYou) ...[
            Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle),
                child: const Icon(Icons.person,
                    size: 20, color: Colors.grey)),
            const SizedBox(width: 8),
          ],
          Flexible(
              child: Container(
            padding: isDots
                ? const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 14)
                : const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isYou
                  ? const Color(0xFF7C4DFF)
                  : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isYou
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
                bottomRight: isYou
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: isDots
                ? _TypingDots()
                : Text(msg['text'] as String,
                    style: TextStyle(
                        fontSize: 14,
                        color: isYou
                            ? Colors.white
                            : const Color(0xFF1A2E45),
                        height: 1.4)),
          )),
          if (isYou) ...[
            const SizedBox(width: 8),
            Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                    color: Color(0xFFE8D5FB),
                    shape: BoxShape.circle),
                child: const Icon(Icons.person,
                    size: 20, color: Color(0xFF7C4DFF))),
          ],
        ],
      ),
    );
  }

  Widget _buildChoices() {
    final choices =
        List<String>.from(_current['choices'] as List);
    return Container(
      key: const ValueKey('choices'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(children: [
          const Text('💬', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(_current['question'] as String,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
        ]),
        const SizedBox(height: 14),
        ...choices.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(
                    () {
                      _choice = e.key;
                      _showFeedback = true;
                    }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EBFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFB39DDB),
                        width: 1.5),
                  ),
                  child: Row(children: [
                    Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF)
                                .withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text('${e.key + 1}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF7C4DFF))))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(e.value,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A2E45)))),
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
        color: safe
            ? const Color(0xFFD5F5E3)
            : const Color(0xFFFFEBEB),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(fb['emoji'] as String,
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(fb['title'] as String,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: safe
                          ? const Color(0xFF1E6B3A)
                          : const Color(0xFFB03030)))),
        ]),
        const SizedBox(height: 12),
        ...points.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: safe
                            ? const Color(0xFF27AE60)
                            : const Color(0xFFE74C3C))),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(p,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: safe
                                ? const Color(0xFF1A4A2A)
                                : const Color(0xFF7A2020)))),
              ]),
            )),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextScenario,
            style: ElevatedButton.styleFrom(
              backgroundColor: safe
                  ? const Color(0xFF27AE60)
                  : const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(
              isLast ? 'Quiz Time! 🎯' : 'Next Scenario →',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
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
      'emoji': '🎭',
      'question': 'What is "pretexting"?',
      'options': [
        'Sending fake emails',
        'Inventing a fake story and pretending to be someone else to get information',
        'Installing a virus on a computer',
        'Pretending to be ill to skip school',
      ],
      'correct': 1,
      'explanation':
          'Pretexting means creating a false scenario and identity to trick someone into sharing information.',
    },
    {
      'emoji': '🧑‍💻',
      'question': 'An online message says it\'s from your school\'s IT department and asks for your password. What should you do?',
      'options': [
        'Send your password — it\'s the IT team!',
        'Send only your username, not your password',
        'Refuse and tell a trusted adult — IT staff never need your password',
        'Ignore it and hope they go away',
      ],
      'correct': 2,
      'explanation':
          'Real IT staff have tools to fix accounts without needing your password. Never share it.',
    },
    {
      'emoji': '🔍',
      'question': 'How can you tell if an email address is suspicious?',
      'options': [
        'It has your name in it',
        'It uses tricks like "sch00l.com" (zeros instead of "o") to look official',
        'It was sent in the morning',
        'It uses capital letters',
      ],
      'correct': 1,
      'explanation':
          'Pretexters use slight misspellings like "0" instead of "o" to make fake addresses look real at first glance.',
    },
    {
      'emoji': '🤔',
      'question': 'Someone online claims to be an old friend and asks for your home address to send a card. What do you do?',
      'options': [
        'Give them your address — it\'s just a card!',
        'Give your street name but not house number',
        'Don\'t share anything and check with a trusted adult first',
        'Ask them to send a gift instead',
      ],
      'correct': 2,
      'explanation':
          'Even if it seems innocent, you cannot verify who someone is online. Never share your address without checking with a trusted adult.',
    },
    {
      'emoji': '🛑',
      'question': 'What does the "P" in the PAUSE rule stand for?',
      'options': ['Password', 'Pause', 'Police', 'Privacy'],
      'correct': 1,
      'explanation':
          'P = Pause. Stop what you\'re doing before acting on any suspicious request.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final q = _questions[_qi];
    final opts = List<String>.from(q['options'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          const Text('Quiz Time! 🎯',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(20)),
            child: Text('${_qi + 1} / ${_questions.length}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C4DFF),
                    fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (_qi + 1) / _questions.length,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(_accent),
          ),
        ),
        const SizedBox(height: 24),
        _WhiteCard(
            child: Column(children: [
          Text(q['emoji'] as String,
              style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          Text(q['question'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
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
              bg = const Color(0xFFD5F5E3);
              border = const Color(0xFF82E0AA);
              tc = const Color(0xFF1E8449);
              trailing =
                  const Icon(Icons.check_circle, color: Color(0xFF2ECC71));
            } else if (i == _selected) {
              bg = const Color(0xFFFFEBEB);
              border = const Color(0xFFFFAAAA);
              tc = const Color(0xFFB03030);
              trailing =
                  const Icon(Icons.cancel, color: Color(0xFFE74C3C));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: _answered
                  ? null
                  : () => setState(() {
                        _selected = i;
                        _answered = true;
                      }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 1.5)),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _answered && i == correct
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFEFF4FB)),
                    child: Center(
                        child: Text(['A', 'B', 'C', 'D'][i],
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: _answered && i == correct
                                    ? Colors.white
                                    : const Color(0xFF9AABBF)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(e.value,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: tc))),
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
              Expanded(
                  child: Text(q['explanation'] as String,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A6020),
                          height: 1.4))),
            ]),
          ),
          const SizedBox(height: 20),
          _NextBtn(
            onTap: () {
              if (_qi < _questions.length - 1) {
                setState(() {
                  _qi++;
                  _selected = null;
                  _answered = false;
                });
              } else {
                widget.onComplete();
              }
            },
            label: _qi < _questions.length - 1
                ? 'Next Question →'
                : 'See Results! 🎉',
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
        lessonId: 'pretexting',
        stepsCompleted: 5,
        totalSteps: 5,
        stars: 3,
        completed: true,
      ),
    );
    await XpAward.show(
      context,
      lessonId: 'pretexting',
      amount: 200,
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
            decoration: const BoxDecoration(
                color: Color(0xFFF0EBFF), shape: BoxShape.circle),
            child:
                const Text('🏆', style: TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 24),
          const Text('You did it! 🎉',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45))),
          const SizedBox(height: 8),
          const Text("You've completed Pretexting!",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: Color(0xFF5A7A95))),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFDE7),
                    borderRadius: BorderRadius.circular(14)),
                child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Text('⭐', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 8),
                  Text('+180 XP',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE6A817))),
                ]),
              ),
              const SizedBox(height: 16),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
          _InfoCard(
              color: Colors.purple,
              emoji: '🎭',
              title: 'Badge Unlocked: Pretexting Detective!',
              body:
                  'You can now see through fake identities and invented stories!'),
          const SizedBox(height: 16),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('What you learned:',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45)))),
          const SizedBox(height: 10),
          _SummaryRow(emoji: '🎭', text: 'What pretexting is and how it works'),
          _SummaryRow(emoji: '🪪', text: 'Common fake identities pretexters use'),
          _SummaryRow(emoji: '💻', text: 'How impersonation works online and via email'),
          _SummaryRow(emoji: '🧠', text: 'How to trust your instincts with the PAUSE rule'),
          _SummaryRow(emoji: '🎬', text: 'Two real-life scenario challenges'),
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
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF5A7A95)))),
          const Icon(Icons.check_circle,
              color: Color(0xFF2ECC71), size: 18),
        ]),
      );
}



class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final double phase =
                ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final double b =
                phase < 0.5 ? phase : 1.0 - phase;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                  width: 6 + b * 4,
                  height: 6 + b * 4,
                  decoration: const BoxDecoration(
                      color: Color(0xFF9AABBF),
                      shape: BoxShape.circle)),
            );
          }),
        ),
      );
}