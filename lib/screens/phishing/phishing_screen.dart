import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';
import 'phishing_widgets.dart';
import 'phishing_lessons.dart';
import 'phishing_chat_sim.dart';
import 'phishing_quiz.dart';
import 'phishing_complete.dart';

// ─── Main Screen ──────────────────────────────────────────────────────────────

class PhishingDetectiveScreen extends StatefulWidget {
  const PhishingDetectiveScreen({super.key});
  @override
  State<PhishingDetectiveScreen> createState() => _PhishingDetectiveScreenState();
}

class _PhishingDetectiveScreenState extends State<PhishingDetectiveScreen> {
  int currentStep = 0;
  static const int totalSteps = PhishingScreenConstants.totalSteps;
  int _quizScore = 0;
  int _quizTotal = 0;

  void goNext() => setState(() => currentStep++);
  void goBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showProgress = currentStep >= 1 && currentStep <= totalSteps;
    final bool isComplete = currentStep == totalSteps + 1;
    return Scaffold(
      backgroundColor: kPhishingBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: PhishingGridPainter())),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                if (!isComplete)
                  GestureDetector(
                    onTap: () { SoundService.playClick(); goBack(); },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kPhishingCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: kPhishingAccent.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: kPhishingAccent, size: 20),
                    ),
                  ).animate().scale(),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: kPhishingAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPhishingAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🎣', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      showProgress ? 'LESSON $currentStep OF $totalSteps' : 'PHISHING DETECTIVE',
                      style: GoogleFonts.fredoka(
                        color: kPhishingAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            if (showProgress)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: PhishingLessonProgressBar(current: currentStep, total: totalSteps),
              ),
            const SizedBox(height: 4),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
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
    switch (currentStep) {
      case 0:
        return PhishingIntroStep(key: const ValueKey(0), onNext: goNext);
      case 1:
        return PhishingLesson1(key: const ValueKey(1), onNext: goNext);
      case 2:
        return PhishingLesson2(key: const ValueKey(2), onNext: goNext);
      case 3:
        return PhishingLesson3(key: const ValueKey(3), onNext: goNext);
      case 4:
        return PhishingLesson4(key: const ValueKey(4), onNext: goNext);
      case 5:
        return PhishingChatSimActivity(key: const ValueKey(5), onNext: goNext);
      case 6:
        return PhishingQuizStep(
          key: const ValueKey(6),
          onComplete: (s, t) {
            setState(() { _quizScore = s; _quizTotal = t; currentStep++; });
          },
        );
      case 7:
        return PhishingCompleteStep(
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