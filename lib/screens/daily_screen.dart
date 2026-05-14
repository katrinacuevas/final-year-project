import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';

// ─── Challenge 1: Spot the Fake (Phishing) ───────────────────────────────────

class _Message {
  final String sender, body;
  const _Message(this.sender, this.body);
}

const _spotReal = _Message('Roblox', 'Hi! Your 100 Robux from the developer reward have been added. Thanks for playing!');
const _spotFake = _Message('R0blox-Fr33', '🚨 YOUR ACCOUNT WILL BE DELETED IN 1 HOUR! Click NOW to save it → free-r0bux.xyz');
const _spotFakeIsB = true; // B is the fake one
const _spotHint = '"R0blox-Fr33" uses zeros instead of letters — a classic fake name trick! Real Roblox never threatens to delete your account or sends you to random websites.';

// ─── Challenge 2: What Would You Do? (Baiting) ───────────────────────────────

class _ChatMsg { final String from, body; const _ChatMsg(this.from, this.body); }
class _ChatChoice {
  final String emoji, label, feedback;
  final bool best;
  const _ChatChoice({required this.emoji, required this.label, required this.feedback, required this.best});
}

const _chatMsgs = [
  _ChatMsg('GamePrize_Bot', '🎉 CONGRATS! You\'ve been randomly selected to WIN a FREE gaming PC!'),
  _ChatMsg('GamePrize_Bot', 'Just send us your full name, home address and school — we\'ll deliver it tomorrow! 📦'),
];

const _chatChoices = [
  _ChatChoice(
    emoji: '📨', label: 'Send my details — I want the prize!',
    feedback: 'Careful! Real competitions never contact you out of nowhere asking for your home address. This is a baiting trap designed to get your personal info. Never share your address online!',
    best: false,
  ),
  _ChatChoice(
    emoji: '🛡️', label: 'Close it and tell a trusted adult',
    feedback: 'Brilliant! You can\'t win something you never entered. Closing it and telling a parent or teacher is always the safest move. You spotted the bait! 🎣',
    best: true,
  ),
  _ChatChoice(
    emoji: '🤔', label: 'Ask them to prove the prize is real',
    feedback: 'Good instinct to be suspicious! But scammers can seem very convincing. The safest thing is always to close it and tell an adult rather than chatting with them.',
    best: false,
  ),
];

// ─── Challenge 3: Safe or Risky? (Pretexting) ────────────────────────────────

class _Scenario {
  final String emoji, text;
  final bool risky;
  final String feedback;
  const _Scenario({required this.emoji, required this.text, required this.risky, required this.feedback});
}

const _scenarios = [
  _Scenario(
    emoji: '🎮',
    text: 'Someone in a game chat says "I\'m from Roblox support. Give me your password and I\'ll add 1,000 Robux to your account."',
    risky: true,
    feedback: 'RISKY! Real support staff NEVER ask for your password — they don\'t need it. This is pretexting: pretending to be support to steal your account!',
  ),
  _Scenario(
    emoji: '📱',
    text: 'Your mum texts you from her usual number saying she\'ll be 10 minutes late picking you up from school.',
    risky: false,
    feedback: 'SAFE! A normal message from a known, trusted person using their real number. Nothing suspicious here!',
  ),
  _Scenario(
    emoji: '🏫',
    text: 'You get a message saying "Hi, I\'m your new teacher. I need your home address for school records — reply here."',
    risky: true,
    feedback: 'RISKY! Schools never collect home addresses by text message. Someone is pretending to be a teacher to find out where you live!',
  ),
  _Scenario(
    emoji: '🎮',
    text: 'Your friend Jake sends you a message asking if you want to play Minecraft after school, like you do every week.',
    risky: false,
    feedback: 'SAFE! A normal message from someone you know well, about something you regularly do together. No red flags!',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});
  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  int _step = 0; // 0=ch1, 1=ch2, 2=ch3, 3=done

  // Ch1 state
  bool? _spotPickedB; // true=picked B, false=picked A
  bool _spotAnswered = false;

  // Ch2 state
  int? _chatPick;
  bool _chatAnswered = false;

  // Ch3 state
  int _sortIdx = 0;
  int _sortScore = 0;
  bool _sortAnswered = false;
  bool? _sortCorrect;

  int _totalScore = 0;

  static const _accentColors = [Color(0xFF4FC3F7), Color(0xFFFF8A65), Color(0xFFBA68C8)];
  static const _stepLabels = ['Spot the Fake', 'What Would You Do?', 'Safe or Risky?'];
  static const _stepIcons = ['🎣', '💬', '🛡️'];

  @override
  void initState() {
    super.initState();
    final p = UserService.instance.getProgress('daily_challenge');
    final saved = p?.stepsCompleted ?? 0;
    if (saved < 3) _step = saved;
  }

  Color get _accent => _step < 3 ? _accentColors[_step] : const Color(0xFFFFC857);

  Future<void> _advance() async {
    final newStep = _step + 1;
    setState(() => _step = newStep);
    await UserService.instance.saveProgress(LessonProgress(
      lessonId: 'daily_challenge',
      stepsCompleted: newStep,
      totalSteps: 3,
      stars: newStep >= 3 ? (_totalScore >= 5 ? 3 : _totalScore >= 3 ? 2 : 1) : 1,
      completed: newStep >= 3,
    ));
    if (newStep >= 3) {
      await UserService.instance.addXp('daily_challenge', 75);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Column(children: [
        _buildTopBar(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: _step == 0 ? _buildCh1()
                  : _step == 1 ? _buildCh2()
                  : _step == 2 ? _buildCh3()
                  : _buildComplete(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        color: const Color(0xFF0D1117),
        child: Column(children: [
          Row(children: [
            GestureDetector(
              onTap: () { SoundService.playClick(); Navigator.pop(context); },
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white70, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Daily Challenge',
                style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            if (_step < 3)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.4)),
                ),
                child: Text('${_step + 1} / 3',
                  style: GoogleFonts.fredoka(color: _accent, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
          ]),
          if (_step < 3) ...[
            const SizedBox(height: 12),
            Row(children: List.generate(3, (i) {
              final done = i < _step;
              final active = i == _step;
              return Expanded(child: Padding(
                padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                child: Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: done ? _accentColors[i] : active ? _accentColors[i].withValues(alpha: 0.4) : Colors.white12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('${_stepIcons[i]} ${_stepLabels[i]}',
                    style: GoogleFonts.fredoka(
                      fontSize: 10,
                      color: done ? _accentColors[i] : active ? Colors.white70 : Colors.white24,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    )),
                ]),
              ));
            })),
          ],
        ]),
      ),
    );
  }

  // ── Challenge 1: Spot the Fake ──────────────────────────────────────────────

  Widget _buildCh1() {
    const accent = Color(0xFF4FC3F7);
    final bool? pickedFake = _spotAnswered
        ? (_spotPickedB == _spotFakeIsB)
        : null;

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _challengeHeader('🎣', 'Spot the Fake!', 'One of these messages is a phishing trick. Can you work out which one?', accent),
          const SizedBox(height: 20),
          Text('MESSAGE A', style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          _messageCard(
            msg: _spotReal,
            picked: _spotAnswered && _spotPickedB == false,
            isFake: false,
            answered: _spotAnswered,
            accent: accent,
            onTap: _spotAnswered ? null : () {
              SoundService.playCatIncorrect();
              setState(() { _spotPickedB = false; _spotAnswered = true; });
            },
          ),
          const SizedBox(height: 14),
          Text('MESSAGE B', style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          _messageCard(
            msg: _spotFake,
            picked: _spotAnswered && _spotPickedB == true,
            isFake: true,
            answered: _spotAnswered,
            accent: accent,
            onTap: _spotAnswered ? null : () {
              SoundService.playCatHappy();
              setState(() { _spotPickedB = true; _spotAnswered = true; _totalScore++; });
            },
          ),
        ]),
      ),
      if (_spotAnswered)
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _feedbackPanel(
            correct: pickedFake == true,
            accent: accent,
            explanation: _spotHint,
            buttonLabel: 'Next Challenge →',
            onNext: _advance,
          ).animate().slideY(begin: 0.3, end: 0, duration: 300.ms).fadeIn(),
        ),
    ]);
  }

  Widget _messageCard({
    required _Message msg,
    required bool picked,
    required bool isFake,
    required bool answered,
    required Color accent,
    required VoidCallback? onTap,
  }) {
    Color borderColor = Colors.white12;
    Color bgColor = const Color(0xFF161B2E);
    if (answered) {
      if (isFake) { borderColor = const Color(0xFFFF5252).withValues(alpha: 0.7); bgColor = const Color(0xFFFF5252).withValues(alpha: 0.08); }
      else { borderColor = const Color(0xFF00E676).withValues(alpha: 0.7); bgColor = const Color(0xFF00E676).withValues(alpha: 0.08); }
    } else if (picked) {
      borderColor = accent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: answered ? 2 : 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('📧', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Text(msg.sender,
                  style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
            const Spacer(),
            if (answered)
              Icon(isFake ? Icons.cancel_rounded : Icons.check_circle_rounded,
                color: isFake ? const Color(0xFFFF5252) : const Color(0xFF00E676), size: 20),
          ]),
          const SizedBox(height: 10),
          Text(msg.body,
            style: GoogleFonts.fredoka(
              color: answered && isFake ? const Color(0xFFFF5252) : Colors.white,
              fontSize: 15, height: 1.4, fontWeight: FontWeight.w500)),
          if (!answered) ...[
            const SizedBox(height: 12),
            Center(child: Text('Tap if this looks suspicious 👆',
              style: GoogleFonts.fredoka(color: Colors.white24, fontSize: 12))),
          ],
        ]),
      ),
    );
  }

  // ── Challenge 2: What Would You Do? ────────────────────────────────────────

  Widget _buildCh2() {
    const accent = Color(0xFFFF8A65);
    final answered = _chatAnswered;

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 220),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _challengeHeader('💬', 'What Would You Do?', 'A message pops up while you\'re gaming. Read it carefully — then pick what you\'d do!', accent),
          const SizedBox(height: 20),
          // Chat bubble UI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('GamePrize_Bot',
                    style: GoogleFonts.fredoka(color: accent, fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('Unknown sender', style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11)),
                ]),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF5252).withValues(alpha: 0.3)),
                  ),
                  child: Text('⚠️ Unknown', style: GoogleFonts.fredoka(color: const Color(0xFFFF5252), fontSize: 10)),
                ),
              ]),
              const SizedBox(height: 14),
              ..._chatMsgs.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(e.value.body,
                      style: GoogleFonts.fredoka(color: Colors.white, fontSize: 14, height: 1.4)),
                  ),
                ),
              )),
            ]),
          ),
          const SizedBox(height: 20),
          if (!answered) ...[
            Text('What do you do?',
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          ..._chatChoices.asMap().entries.map((e) {
            final i = e.key;
            final c = e.value;
            final picked = _chatPick == i;
            Color bg = const Color(0xFF161B2E);
            Color border = Colors.white12;
            Color tc = Colors.white70;
            if (answered && picked) {
              if (c.best) { bg = const Color(0xFF00E676).withValues(alpha: 0.1); border = const Color(0xFF00E676).withValues(alpha: 0.6); tc = const Color(0xFF00E676); }
              else { bg = const Color(0xFFFF5252).withValues(alpha: 0.1); border = const Color(0xFFFF5252).withValues(alpha: 0.6); tc = const Color(0xFFFF5252); }
            } else if (answered && c.best && !(_chatChoices[_chatPick!].best)) {
              bg = const Color(0xFF00E676).withValues(alpha: 0.05); border = const Color(0xFF00E676).withValues(alpha: 0.3); tc = const Color(0xFF00E676).withValues(alpha: 0.6);
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: answered ? null : () {
                  if (c.best) { SoundService.playCatHappy(); setState(() { _totalScore++; }); }
                  else { SoundService.playCatIncorrect(); }
                  setState(() { _chatPick = i; _chatAnswered = true; });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Row(children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(c.label,
                      style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: tc))),
                    if (answered && picked)
                      Icon(c.best ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: c.best ? const Color(0xFF00E676) : const Color(0xFFFF5252), size: 20),
                  ]),
                ),
              ),
            );
          }),
        ]),
      ),
      if (_chatAnswered)
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _feedbackPanel(
            correct: _chatChoices[_chatPick!].best,
            accent: accent,
            explanation: _chatChoices[_chatPick!].feedback,
            buttonLabel: 'Last Challenge →',
            onNext: _advance,
          ).animate().slideY(begin: 0.3, end: 0, duration: 300.ms).fadeIn(),
        ),
    ]);
  }

  // ── Challenge 3: Safe or Risky? ─────────────────────────────────────────────

  Widget _buildCh3() {
    const accent = Color(0xFFBA68C8);
    final scenario = _scenarios[_sortIdx];
    final done = _sortIdx >= _scenarios.length;

    if (done) {
      return _buildSortComplete(accent);
    }

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 220),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _challengeHeader('🛡️', 'Safe or Risky?',
            'Read each situation and decide: is it safe or risky? ${_sortIdx + 1} of ${_scenarios.length}', accent),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: ValueKey(_sortIdx),
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF161B2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.5),
              ),
              child: Column(children: [
                Text(scenario.emoji, style: const TextStyle(fontSize: 52)),
                const SizedBox(height: 16),
                Text(scenario.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(color: Colors.white, fontSize: 16, height: 1.5, fontWeight: FontWeight.w500)),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          if (!_sortAnswered) ...[
            Row(children: [
              Expanded(child: _sortButton('✅ SAFE', false, const Color(0xFF00E676), accent)),
              const SizedBox(width: 12),
              Expanded(child: _sortButton('⚠️ RISKY', true, const Color(0xFFFF5252), accent)),
            ]),
          ],
          // Progress dots
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_scenarios.length, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == _sortIdx ? 20 : 8, height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: i < _sortIdx ? accent : i == _sortIdx ? accent.withValues(alpha: 0.5) : Colors.white12,
            ),
          ))),
        ]),
      ),
      if (_sortAnswered)
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _feedbackPanel(
            correct: _sortCorrect!,
            accent: accent,
            explanation: scenario.feedback,
            buttonLabel: _sortIdx < _scenarios.length - 1 ? 'Next Scenario →' : 'See Results! 🎉',
            onNext: () {
              if (_sortIdx < _scenarios.length - 1) {
                setState(() { _sortIdx++; _sortAnswered = false; _sortCorrect = null; });
              } else {
                _advance();
              }
            },
          ).animate().slideY(begin: 0.3, end: 0, duration: 300.ms).fadeIn(),
        ),
    ]);
  }

  Widget _sortButton(String label, bool isRisky, Color color, Color accent) {
    return GestureDetector(
      onTap: () {
        final correct = isRisky == _scenarios[_sortIdx].risky;
        if (correct) { SoundService.playCatHappy(); setState(() { _sortScore++; _totalScore++; }); }
        else { SoundService.playCatIncorrect(); }
        setState(() { _sortAnswered = true; _sortCorrect = correct; });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Center(child: Text(label,
          style: GoogleFonts.fredoka(color: color, fontSize: 17, fontWeight: FontWeight.w700))),
      ),
    );
  }

  Widget _buildSortComplete(Color accent) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_sortScore >= 3 ? '🏆' : '💪', style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 12),
        Text('$_sortScore / ${_scenarios.length} correct!',
          style: GoogleFonts.fredoka(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _advance,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0,
          ),
          child: Text('See Results! 🎉', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
        )),
      ]),
    ));
  }

  // ── Complete screen ──────────────────────────────────────────────────────────

  Widget _buildComplete() {
    final total = 1 + 1 + _scenarios.length; // max possible
    final stars = _totalScore >= total - 1 ? 3 : _totalScore >= total ~/ 2 + 1 ? 2 : 1;
    final perfect = stars == 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 20),
        Text(perfect ? '🏆' : stars == 2 ? '🌟' : '💪', style: const TextStyle(fontSize: 80))
            .animate().scale(curve: Curves.elasticOut, duration: 800.ms),
        const SizedBox(height: 16),
        Text(perfect ? 'Perfect! You\'re a cyber hero!' : stars == 2 ? 'Great job, agent!' : 'Good effort today!',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('You spotted fakes, dodged baits, and sorted risky from safe.',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(color: Colors.white54, fontSize: 14, height: 1.5)),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFC857).withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('✨', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text('+75 XP', style: GoogleFonts.fredoka(color: const Color(0xFFFFC857), fontSize: 28, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) =>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(i < stars ? '⭐' : '☆', style: const TextStyle(fontSize: 34)),
              ))),
            const SizedBox(height: 8),
            Text(perfect ? '3 Stars — Amazing detective work!' : '$stars Stars — Keep it up!',
              style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('What you practised today:', style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _practisedRow('🎣', 'Spotting fake sender names & urgency tricks'),
            _practisedRow('💬', 'Recognising baiting messages with fake prizes'),
            _practisedRow('🛡️', 'Telling safe messages from pretexting traps'),
          ]),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () { SoundService.playClick(); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC857),
              foregroundColor: const Color(0xFF0D1117),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 0,
            ),
            child: Text('Back to Dashboard 🏠',
              style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _practisedRow(String icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(color: Colors.white54, fontSize: 13))),
    ]),
  );

  // ── Shared widgets ───────────────────────────────────────────────────────────

  Widget _challengeHeader(String icon, String title, String subtitle, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.fredoka(color: Colors.white60, fontSize: 13, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _feedbackPanel({
    required bool correct,
    required Color accent,
    required String explanation,
    required String buttonLabel,
    required VoidCallback onNext,
  }) {
    final catMsg = '${correct ? "Purrfect! ✅" : "Not quite! 😿"} $explanation';
    final btnColor = correct ? const Color(0xFF00E676) : accent;
    final btnFg = correct ? const Color(0xFF0D1117) : Colors.white;

    return _DailyCatPanel(
      message: catMsg,
      accentColor: accent,
      button: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () { SoundService.playClick(); onNext(); },
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: btnFg,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(buttonLabel,
            style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

// ─── Reusable cat feedback panel for daily challenges ─────────────────────────

class _DailyCatPanel extends StatefulWidget {
  final Widget button;
  final String message;
  final Color accentColor;
  const _DailyCatPanel({required this.button, required this.message, required this.accentColor});
  @override
  State<_DailyCatPanel> createState() => _DailyCatPanelState();
}

class _DailyCatPanelState extends State<_DailyCatPanel> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161B2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SizedBox(
        height: 180,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
          Positioned(
            left: -18, bottom: 15,
            child: ClipRect(
              child: SizedBox(
                width: 160, height: 160,
                child: Lottie.asset('assets/animations/cat.json', controller: _ctrl, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            left: 130, bottom: 80,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 210),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1848),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16)),
                border: Border.all(color: widget.accentColor.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Text(widget.message,
                style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500)),
            ),
          ),
        ]),
      ),
    );
  }
}
