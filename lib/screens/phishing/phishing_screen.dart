import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import '../../models/difficulty_level.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';
import 'phishing_lessons.dart';
import 'phishing_chat_sim.dart';
import 'phishing_quiz.dart';
import 'phishing_complete.dart';

class PhishingDetectiveScreen extends StatefulWidget {
  final DifficultyLevel difficulty;
  const PhishingDetectiveScreen({super.key, this.difficulty = DifficultyLevel.easy});
  @override
  State<PhishingDetectiveScreen> createState() => _PhishingDetectiveScreenState();
}

class _PhishingDetectiveScreenState extends State<PhishingDetectiveScreen> {
  int currentStep = 0;
  static const int totalSteps = 7; // 7 lessons
  int _quizScore = 0;
  int _quizTotal = 0;

  void _goNext() => setState(() => currentStep++);
  void _goBack() {
    if (currentStep > 0) setState(() => currentStep--);
    else Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = currentStep >= 1 && currentStep <= totalSteps;
    final bool isComplete   = currentStep == 10;

    return Scaffold(
      backgroundColor: kPhishingBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: PhishingGridPainter())),
        SafeArea(child: Column(children: [

          // ── Top bar ──────────────────────────────────────────────────────────
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              if (!isComplete)
                GestureDetector(
                  onTap: () { SoundService.playClick(); _goBack(); },
                  child: Container(width: 42, height: 42,
                    decoration: BoxDecoration(color: kPhishingCard, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kPhishingAccent.withValues(alpha: 0.3))),
                    child: const Icon(Icons.arrow_back_rounded, color: kPhishingAccent, size: 20)),
                ).animate().scale(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: kPhishingAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🎣', style: TextStyle(fontSize: 12)), const SizedBox(width: 6),
                  Text(showProgress ? 'LESSON $currentStep OF $totalSteps' : 'PHISHING DETECTIVE',
                    style: GoogleFonts.fredoka(color: kPhishingAccent, fontSize: 12,
                      fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                ]),
              ),
            ])),

          // ── Progress bar (lessons 1–7 only) ──────────────────────────────────
          if (showProgress)
            Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: PhishingProgressBar(current: currentStep, total: totalSteps)),
          const SizedBox(height: 4),

          // ── Step content ─────────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: anim, child: child)),
              child: _buildStep(),
            ),
          ),
        ])),
      ]),
    );
  }

  // ── Step router ─────────────────────────────────────────────────────────────
  Widget _buildStep() {
    switch (currentStep) {
      case 0:  return PhishingIntroStep(key: const ValueKey(0),  onNext: _goNext);
      case 1:  return PhishingLesson1(key: const ValueKey(1),    onNext: _goNext);
      case 2:  return PhishingLesson2(key: const ValueKey(2),    onNext: _goNext);
      case 3:  return PhishingLesson3(key: const ValueKey(3),    onNext: _goNext);
      case 4:  return PhishingLesson4(key: const ValueKey(4),    onNext: _goNext);
      case 5:  return PhishingLesson5(key: const ValueKey(5),    onNext: _goNext);
      case 6:  return PhishingLesson6(key: const ValueKey(6),    onNext: _goNext);
      case 7:  return PhishingLesson7(key: const ValueKey(7),    onNext: _goNext);
      case 8:  return PhishingChatSim(key: const ValueKey(8),    onNext: _goNext);
      case 9:  return PhishingQuizStep(key: const ValueKey(9), difficulty: widget.difficulty, onComplete: (s, t) {
        setState(() { _quizScore = s; _quizTotal = t; currentStep++; });
      });
      case 10: return PhishingCompleteStep(
        key: const ValueKey(10),
        score: _quizScore, total: _quizTotal,
        onRetry: () => setState(() => currentStep = 9),
        onDone: () => Navigator.pop(context),
      );
      default: return const SizedBox();
    }
  }
}