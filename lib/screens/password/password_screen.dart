import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../services/sound_service.dart';
import '../../models/difficulty_level.dart';
import 'password_theme.dart';
import 'password_widgets.dart';
import 'password_lessons.dart';
import 'password_build.dart';
import 'password_quiz.dart';
import 'password_complete.dart';

class PasswordPowerScreen extends StatefulWidget {
  final DifficultyLevel difficulty;
  const PasswordPowerScreen({super.key, this.difficulty = DifficultyLevel.easy});
  @override
  State<PasswordPowerScreen> createState() => _PasswordPowerScreenState();
}

class _PasswordPowerScreenState extends State<PasswordPowerScreen> {
  int currentStep = 0;
  static const int totalSteps = 6;
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
    final bool isComplete   = currentStep == totalSteps + 1;

    return Scaffold(
      backgroundColor: kPasswordBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: GridPainter())),
        SafeArea(child: Column(children: [

          // ── Top bar ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              if (!isComplete)
                GestureDetector(
                  onTap: () { SoundService.playClick(); _goBack(); },
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: kPasswordCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kPasswordAccent.withValues(alpha: 0.3))),
                    child: const Icon(Icons.arrow_back_rounded, color: kPasswordAccent, size: 20),
                  ),
                ).animate().scale(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: kPasswordAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPasswordAccent.withValues(alpha: 0.4))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🔐', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Text(
                    showProgress
                      ? 'LESSON $currentStep OF $totalSteps'
                      : 'PASSWORD POWER',
                    style: GoogleFonts.fredoka(color: kPasswordAccent, fontSize: 12,
                      fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                ]),
              ),
            ]),
          ),

          // ── Progress bar ─────────────────────────────────────────────────────
          if (showProgress)
            Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: LessonProgressBar(current: currentStep, total: totalSteps)),
          const SizedBox(height: 4),

          // ── Step content ─────────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child)),
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
      case 0:
        return IntroStep(key: const ValueKey(0), onNext: _goNext);
      case 1:
        return LessonStep1(key: const ValueKey(1), onNext: _goNext);
      case 2:
        return LessonStep2(key: const ValueKey(2), onNext: _goNext);
      case 3:
        return LessonStep3(key: const ValueKey(3), onNext: _goNext);
      case 4:
        return LessonStep4(key: const ValueKey(4), onNext: _goNext);
      case 5:
        // Build password first, then quiz
        return BuildPasswordStep(key: const ValueKey(5), onComplete: () async {
          await UserService.instance.saveProgress(const LessonProgress(
            lessonId: 'password_power', stepsCompleted: 6, totalSteps: 6,
            stars: 3, completed: true));
          if (mounted) setState(() => currentStep++);
        });
      case 6:
        return QuizStep(key: const ValueKey(6), difficulty: widget.difficulty, onComplete: (s, t) {
          setState(() { _quizScore = s; _quizTotal = t; currentStep++; });
        });
      case 7:
        return CompleteStep(
          key: const ValueKey(7),
          score: _quizScore,
          total: _quizTotal,
          onRetry: () => setState(() => currentStep = 6),
          onDone: () => Navigator.pop(context),
        );
      default:
        return const SizedBox();
    }
  }
}