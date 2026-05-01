import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import 'password_lessons.dart';
import 'password_quiz.dart';
import 'password_builder.dart';
import 'password_complete.dart';

class PasswordPowerScreen extends StatefulWidget {
  const PasswordPowerScreen({super.key});

  @override
  State<PasswordPowerScreen> createState() => _PasswordPowerScreenState();
}

class _PasswordPowerScreenState extends State<PasswordPowerScreen> {
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
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Password Power',
          style: TextStyle(color: Color(0xFF1A2E45), fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          if (_currentStep > 0 && _currentStep < 4)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Step $_currentStep of 4',
                  style: const TextStyle(color: Color(0xFF7A9BB5), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return IntroStep(key: const ValueKey(0), onNext: () => setState(() => _currentStep = 1));
      case 1: return LessonStep1(key: const ValueKey(1), onNext: () => setState(() => _currentStep = 2));
      case 2: return LessonStep2(key: const ValueKey(2), onNext: () => setState(() => _currentStep = 3));
      case 3: return LessonStep3(key: const ValueKey(3), onNext: () => setState(() => _currentStep = 4));
      case 4: return LessonStep4(key: const ValueKey(4), onNext: () => setState(() => _currentStep = 5));
      case 5: return QuizStep(key: const ValueKey(5), onComplete: () => setState(() => _currentStep = 6));
      case 6: return BuildPasswordStep(
        key: const ValueKey(6), 
        onComplete: () async {
          await UserService.instance.saveProgress(
            const LessonProgress(
              lessonId: 'password_power',
              stepsCompleted: 4,
              totalSteps: 4,
              stars: 3,
              completed: true,
            ),
          );
          setState(() => _currentStep = 7);
        }
      );
      case 7: return CompleteStep(key: const ValueKey(7), onDone: () => Navigator.pop(context));
      default: return const SizedBox();
    }
  }
}