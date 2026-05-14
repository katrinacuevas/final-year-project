// pretexting_screen.dart
// Thin orchestrator for the Pretexting Detective course.
// Routes steps 0–9 across the split lesson files.
//
// Step 0  → PretextingIntroStep
// Step 1  → PretextingLesson1  (What is Pretexting?)
// Step 2  → PretextingLesson2  (Why Does It Work?)
// Step 3  → PretextingLesson3  (Who Do They Pretend To Be?)
// Step 4  → PretextingLesson4  (Sneaky Online Tricks)
// Step 5  → PretextingLesson5  (Trust Your Gut!)
// Step 6  → PretextingLesson6  (The PAUSE Rule)
// Step 7  → PretextingChatSim  (Chat Simulation)
// Step 8  → PretextingQuizStep (Quiz)
// Step 9  → PretextingCompleteStep (Results)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import '../../models/difficulty_level.dart';
import 'pretexting_theme.dart';
import 'pretexting_widgets.dart';
import 'pretexting_lessons.dart';
import 'pretexting_chat_sim.dart';
import 'pretexting_quiz.dart';
import 'pretexting_complete.dart';

class PretextingScreen extends StatefulWidget {
  final DifficultyLevel difficulty;
  const PretextingScreen({super.key, this.difficulty = DifficultyLevel.easy});
  @override
  State<PretextingScreen> createState() => _PretextingScreenState();
}

class _PretextingScreenState extends State<PretextingScreen> {
  int _currentStep = 0;
  static const int _totalLessons = 6;
  int _quizScore = 0;
  int _quizTotal = 0;

  void _goNext() => setState(() => _currentStep++);

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress =
        _currentStep >= 1 && _currentStep <= _totalLessons;
    final bool isComplete = _currentStep == 9;

    return Scaffold(
      backgroundColor: kPretextBg,
      body: Stack(children: [
        Positioned.fill(
            child: CustomPaint(painter: PretextingGridPainter())),
        SafeArea(
          child: Column(children: [
            // ── Top bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                if (!isComplete)
                  GestureDetector(
                    onTap: () {
                      SoundService.playClick();
                      _goBack();
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kPretextCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: kPretextCyan.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: kPretextCyan, size: 20),
                    ),
                  ).animate().scale(),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: kPretextAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: kPretextAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🎭',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      showProgress
                          ? 'LESSON $_currentStep OF $_totalLessons'
                          : 'PRETEXTING',
                      style: GoogleFonts.fredoka(
                          color: kPretextAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ]),
                ),
              ]),
            ),

            // ── Progress bar (lessons 1–6 only) ────────────────────────────
            if (showProgress)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: PretextingProgressBar(
                    current: _currentStep, total: _totalLessons),
              ),
            const SizedBox(height: 4),

            // ── Step content ───────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0.08, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOutCubic)),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: _buildStep(),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return PretextingIntroStep(
            key: const ValueKey(0), onNext: _goNext);
      case 1:
        return PretextingLesson1(
            key: const ValueKey(1), onNext: _goNext);
      case 2:
        return PretextingLesson2(
            key: const ValueKey(2), onNext: _goNext);
      case 3:
        return PretextingLesson3(
            key: const ValueKey(3), onNext: _goNext);
      case 4:
        return PretextingLesson4(
            key: const ValueKey(4), onNext: _goNext);
      case 5:
        return PretextingLesson5(
            key: const ValueKey(5), onNext: _goNext);
      case 6:
        return PretextingLesson6(
            key: const ValueKey(6), onNext: _goNext);
      case 7:
        return PretextingChatSim(
            key: const ValueKey(7), onNext: _goNext);
      case 8:
        return PretextingQuizStep(
          key: const ValueKey(8),
          difficulty: widget.difficulty,
          onComplete: (s, t) {
            setState(() {
              _quizScore = s;
              _quizTotal = t;
              _currentStep++;
            });
          },
        );
      case 9:
        return PretextingCompleteStep(
          key: const ValueKey(9),
          score: _quizScore,
          total: _quizTotal,
          onRetry: () => setState(() => _currentStep = 8),
          onDone: () => Navigator.pop(context),
        );
      default:
        return const SizedBox();
    }
  }
}
