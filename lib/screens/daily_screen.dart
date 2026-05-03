import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        'This is a fake email! The sender address says "paypa1" (with a number 1) instead of "paypal". Real companies never ask you to click urgent links in emails.',
  ),
  _Email(
    sender: 'no-reply@google.com',
    subject: 'Your Google account: new sign-in on Windows',
    body:
        'Hi,\n\nWe noticed a new sign-in to your Google Account. If this was you, you can ignore this email.\n\nIf you don\'t recognise this activity, please review your account.\n\nThe Google Team',
    isPhishing: false,
    explanation:
        'This is a real email! It comes from the official google.com domain, doesn\'t create panic, and doesn\'t ask you to click a suspicious link.',
  ),
  _Email(
    sender: 'winner@prizes-online.net',
    subject: '🎉 You\'ve won a £1,000 Amazon Gift Card!',
    body:
        'CONGRATULATIONS!\n\nYou have been selected as today\'s lucky winner! Claim your £1,000 Amazon Gift Card now. This offer expires in 24 hours.\n\nEnter your details at: www.prizes-online.net/claim',
    isPhishing: true,
    explanation:
        'This is a phishing email! You can\'t win a prize you never entered. The sender address looks unofficial, and it\'s trying to rush you with a fake deadline.',
  ),
];

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  bool? _selectedAnswer;
  bool _showResult = false;
  bool _finished = false;
  bool _awardingXp = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  _Email get _current => _emails[_currentIndex];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

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
      await _animCtrl.reverse();
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
      _animCtrl.forward();
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

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmailCard(),
                      const SizedBox(height: 24),
                      if (!_showResult) _buildQuestionButtons(),
                      if (_showResult) _buildResultPanel(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              SoundService.playClick();
              Navigator.pop(context);
            },
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.4)),
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF4A2800), size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚡ Daily Challenge',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3D2C8D),
                  ),
                ),
                Text(
                  'Email ${_currentIndex + 1} of ${_emails.length}',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9B8ABF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE066),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB347).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '✨ +50 XP',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF4A2800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0D5F5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F0FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D2C8D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('📧', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _current.sender,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3D2C8D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _current.subject,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D1B69),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              _current.body,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: const Color(0xFF4A3F6B),
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Is this email real or fake? 🤔',
          style: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF3D2C8D),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _choiceButton(
                label: '✅ Real Email',
                color: const Color(0xFF00C9A7),
                onTap: () => _answer(false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _choiceButton(
                label: '🎣 Fake / Phishing',
                color: const Color(0xFFFF6B9D),
                onTap: () => _answer(true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _choiceButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildResultPanel() {
    final bool correct = _selectedAnswer == _current.isPhishing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: correct ? const Color(0xFFE6FBF7) : const Color(0xFFFFEBF3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: correct
                  ? const Color(0xFF00C9A7).withOpacity(0.4)
                  : const Color(0xFFFF6B9D).withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                correct ? '🎉 Correct!' : '😅 Not quite!',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: correct ? const Color(0xFF00A383) : const Color(0xFFD63075),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _current.explanation,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: correct ? const Color(0xFF1A6B58) : const Color(0xFF8B1A4A),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _awardingXp
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D2C8D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 4,
                    shadowColor: const Color(0xFF3D2C8D).withOpacity(0.4),
                  ),
                  child: Text(
                    _currentIndex < _emails.length - 1
                        ? 'Next Email →'
                        : 'Finish Challenge 🏁',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFinished() {
    final int total = _emails.length;
    final bool perfect = _score == total;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  perfect ? '🏆' : _score >= (total ~/ 2 + 1) ? '🌟' : '💪',
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                Text(
                  perfect
                      ? 'Perfect Score!'
                      : _score >= (total ~/ 2 + 1)
                          ? 'Great Job!'
                          : 'Good Try!',
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3D2C8D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You got $_score out of $total correct!',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B5B8A),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE066), Color(0xFFFFB347)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB347).withOpacity(0.5),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    '✨ +50 XP Earned!',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF4A2800),
                    ),
                  ),
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
                      backgroundColor: const Color(0xFF3D2C8D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 4,
                      shadowColor: const Color(0xFF3D2C8D).withOpacity(0.4),
                    ),
                    child: Text(
                      'Back to Dashboard 🏠',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}