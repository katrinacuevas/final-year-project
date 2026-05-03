import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';

class _Email {
  final String sender;
  final String subject;
  final String body;
  final bool isPhishing;
  final String explanation;
  const _Email({
    required this.sender,
    required this.subject,
    required this.body,
    required this.isPhishing,
    required this.explanation,
  });
}

const List<_Email> _emails = [
  _Email(
    sender: 'support@paypa1-secure.com',
    subject: 'URGENT: Your account has been suspended!',
    body:
        'Dear Customer,\n\nYour PayPal account has been suspended due to suspicious activity. Click the link below IMMEDIATELY to restore access or your account will be permanently deleted.\n\nwww.paypa1-secure.com/restore',
    isPhishing: true,
    explanation:
        'The sender says "paypa1" (number 1) instead of "paypal". Real companies never demand you click urgent links in emails.',
  ),
  _Email(
    sender: 'no-reply@google.com',
    subject: 'Your Google account: new sign-in on Windows',
    body:
        'Hi,\n\nWe noticed a new sign-in to your Google Account. If this was you, you can ignore this email.\n\nIf you don\'t recognise this activity, please review your account.\n\nThe Google Team',
    isPhishing: false,
    explanation:
        'This comes from the official google.com domain, doesn\'t create panic, and doesn\'t ask you to click a suspicious link.',
  ),
  _Email(
    sender: 'winner@prizes-online.net',
    subject: '🎉 You\'ve won a £1,000 Amazon Gift Card!',
    body:
        'CONGRATULATIONS!\n\nYou have been selected as today\'s lucky winner! Claim your £1,000 Amazon Gift Card now. This offer expires in 24 hours.\n\nEnter your details at: www.prizes-online.net/claim',
    isPhishing: true,
    explanation:
        'You can\'t win a prize you never entered. The sender looks unofficial and it\'s rushing you with a fake deadline.',
  ),
];

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool? _selectedAnswer;
  bool _showResult = false;
  bool _finished = false;
  bool _awardingXp = false;

  _Email get _current => _emails[_currentIndex];

  void _answer(bool guessedPhishing) {
    if (_showResult) return;
    SoundService.playClick();
    final correct = guessedPhishing == _current.isPhishing;
    if (correct) _score++;
    setState(() {
      _selectedAnswer = guessedPhishing;
      _showResult = true;
    });
  }

  Future<void> _next() async {
    SoundService.playClick();
    if (_currentIndex < _emails.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      await _finishChallenge();
    }
  }

  Future<void> _finishChallenge() async {
    setState(() => _awardingXp = true);
    await UserService.instance.saveProgress(
      LessonProgress(
        lessonId: 'daily_challenge',
        stepsCompleted: _emails.length,
        totalSteps: _emails.length,
        stars: _score >= _emails.length
            ? 3
            : _score >= (_emails.length ~/ 2 + 1)
                ? 2
                : 1,
        completed: true,
      ),
    );
    await UserService.instance.addXp('daily_challenge', 50);
    setState(() {
      _awardingXp = false;
      _finished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildFinished();
    final bool correct = _showResult && _selectedAnswer == _current.isPhishing;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2E45)),
          onPressed: () {
            SoundService.playClick();
            Navigator.pop(context);
          },
        ),
        title: const Text('Daily Challenge',
            style: TextStyle(
                color: Color(0xFF1A2E45),
                fontWeight: FontWeight.w800,
                fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Email ${_currentIndex + 1} of ${_emails.length}',
                  style: const TextStyle(
                      color: Color(0xFF7A6020),
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(1, 0), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
              child: SingleChildScrollView(
                key: ValueKey(_currentIndex),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / _emails.length,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFB347)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A2E45),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                        child: Text('📧',
                                            style: TextStyle(fontSize: 18))),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _current.sender,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF3D2C8D)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 8),
                                Text(
                                  _current.subject,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A2E45)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _current.body,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5A7A95),
                                height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!_showResult) ...[
                      const Text('Is this email real or fake? 🤔',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A2E45))),
                      const SizedBox(height: 12),
                      _choiceTile(
                        label: '✅  Real Email',
                        index: 0,
                        onTap: () => _answer(false),
                      ),
                      const SizedBox(height: 10),
                      _choiceTile(
                        label: '🎣  Fake / Phishing',
                        index: 1,
                        onTap: () => _answer(true),
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 1), end: Offset.zero)
                  .animate(CurvedAnimation(
                      parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
            child: _showResult
                ? _buildFeedbackPanel(correct)
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  Widget _choiceTile({
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB39DDB), width: 1.5),
        ),
        child: Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C4DFF).withOpacity(0.15),
            ),
            child: Center(
              child: Text('${index + 1}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C4DFF))),
            ),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2E45))),
        ]),
      ),
    );
  }

  Widget _buildFeedbackPanel(bool correct) {
    final bool isLast = _currentIndex == _emails.length - 1;
    return Container(
      key: const ValueKey('feedback'),
      decoration: BoxDecoration(
        color: correct ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(correct ? '🛡️' : '😬',
                style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                correct ? 'Correct! Well spotted! 🎉' : 'Not quite!',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: correct
                        ? const Color(0xFF1E6B3A)
                        : const Color(0xFFB03030)),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.only(top: 5),
                width: 6, height: 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: correct
                        ? const Color(0xFF27AE60)
                        : const Color(0xFFE74C3C))),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _current.explanation,
                style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: correct
                        ? const Color(0xFF1A4A2A)
                        : const Color(0xFF7A2020)),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _awardingXp
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: correct
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFE74C3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      isLast ? 'See Results! 🎉' : 'Next Email →',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinished() {
    final int total = _emails.length;
    final bool perfect = _score == total;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                  color: Color(0xFFFFFDE7), shape: BoxShape.circle),
              child: Text(
                perfect ? '🏆' : _score >= (total ~/ 2 + 1) ? '🌟' : '💪',
                style: const TextStyle(fontSize: 72),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              perfect
                  ? 'Perfect Score!'
                  : _score >= (total ~/ 2 + 1)
                      ? 'Great Job!'
                      : 'Good Try!',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2E45)),
            ),
            const SizedBox(height: 8),
            Text(
              'You got $_score out of $total correct!',
              style: const TextStyle(fontSize: 16, color: Color(0xFF5A7A95)),
            ),
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
                    Text('+50 XP',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE6A817))),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (i) => Text(
                              i < _score ? '⭐' : '☆',
                              style: const TextStyle(fontSize: 32),
                            ))),
                const SizedBox(height: 10),
                Text(
                  perfect ? '3 Stars — Amazing!' : '$_score Stars — Keep it up!',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E45)),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF).withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFB39DDB).withOpacity(0.4)),
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('🎭', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text('What you practised:',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2E45))),
                  SizedBox(height: 4),
                  Text(
                      'Spotting suspicious sender addresses, fake urgency, and too-good-to-be-true offers.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5A7A95),
                          height: 1.4)),
                ])),
              ]),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  SoundService.playClick();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2E45),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Back to Dashboard 🏠',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}