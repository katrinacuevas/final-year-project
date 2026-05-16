// ========================================================================
// baiting_screen.dart
// ------------------------------------------------------------------------
// main point for the baiting lesson manages step state and routes between 
// lessons, chat sim, quiz and results
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/sound_service.dart';
import 'baiting_theme.dart';
import 'baiting_widgets.dart';
import 'baiting_lessons.dart';
import 'baiting_chat_sim.dart';
import 'baiting_quiz.dart';
import 'baiting_complete.dart';

class BaitingScreen extends StatefulWidget {
  const BaitingScreen({super.key});
  @override
  State<BaitingScreen> createState() => _BaitingScreenState();
}

class _BaitingScreenState extends State<BaitingScreen> {
  int _currentStep = 0;
  static const int _totalLessons = 7;
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
    final bool showProgress = _currentStep >= 1 && _currentStep <= _totalLessons;
    final bool isComplete   = _currentStep == 10;

    return Scaffold(
      backgroundColor: kBaitBg,
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: BaitingGridPainter())),
        SafeArea(child: Column(children: [

          // ----- top bar -----
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              if (!isComplete)
                GestureDetector(
                  onTap: () { SoundService.playClick(); _goBack(); },
                  child: Container(width: 42, height: 42,
                    decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: kBaitCyan.withValues(alpha: 0.3))),
                    child: const Icon(Icons.arrow_back_rounded, color: kBaitCyan, size: 20)),
                ).animate().scale(),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: kBaitAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBaitAccent.withValues(alpha: 0.4))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🎁', style: TextStyle(fontSize: 12)), const SizedBox(width: 6),
                  Text(showProgress ? 'LESSON $_currentStep OF $_totalLessons' : 'BAITING PRO',
                    style: GoogleFonts.fredoka(color: kBaitAccent, fontSize: 12,
                      fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                ]),
              ),
            ])),

          // ----- progress bar -----
          if (showProgress)
            Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: BaitingProgressBar(current: _currentStep, total: _totalLessons)),
          const SizedBox(height: 4),

          // ----- step content -----
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

  // ----- step router -----
  Widget _buildStep() {
    switch (_currentStep) {
      case 0:  return BaitingIntroStep(key: const ValueKey(0),  onNext: _goNext);
      case 1:  return BaitingLesson1(key: const ValueKey(1),    onNext: _goNext);
      case 2:  return BaitingLesson2(key: const ValueKey(2),    onNext: _goNext);
      case 3:  return BaitingLesson3(key: const ValueKey(3),    onNext: _goNext);
      case 4:  return BaitingLesson4(key: const ValueKey(4),    onNext: _goNext);
      case 5:  return BaitingLesson5(key: const ValueKey(5),    onNext: _goNext);
      case 6:  return BaitingLesson6(key: const ValueKey(6),    onNext: _goNext);
      case 7:  return BaitingLesson7(key: const ValueKey(7),    onNext: _goNext);
      case 8:  return BaitingChatSim(key: const ValueKey(8),    onNext: _goNext);
      case 9:  return BaitingQuizStep(key: const ValueKey(9),   onComplete: (s, t) {
        setState(() { _quizScore = s; _quizTotal = t; _currentStep++; });
      });
      case 10: return BaitingCompleteStep(
        key: const ValueKey(10),
        score: _quizScore, total: _quizTotal,
        onRetry: () => setState(() => _currentStep = 9),
        onDone: () => Navigator.pop(context),
      );
      default: return const SizedBox();
    }
  }
}