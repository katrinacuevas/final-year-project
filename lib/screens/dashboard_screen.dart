import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import 'password/password_screen.dart';
import 'phishing/phishing_screen.dart';
import '../widgets/welcome_card.dart';
import '../widgets/daily_challenge.dart';
import '../widgets/learning_task.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await UserService.instance.loadAllProgress();
    if (mounted) setState(() {});
  }

  Widget _animateIn(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Interval((index * 0.1).clamp(0.0, 0.5), 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 241, 255),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: ListenableBuilder(
            listenable: UserService.instance,
            builder: (context, child) {
              final passwordProgress = UserService.instance.getProgress('password_power');
              final phishingProgress = UserService.instance.getProgress('phishing_detective');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _animateIn(const WelcomeCard(), 0),
                  const SizedBox(height: 10),
                  _animateIn(const DailyChallengeCard(), 1),
                  const SizedBox(height: 10),
                  _animateIn(
                    const Text(
                      'Learning Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F355E),
                      ),
                    ),
                    2,
                  ),
                  const SizedBox(height: 16),
                  _animateIn(
                    LearningTaskCard(
                      emoji: '🔐',
                      iconColor: const Color(0xFFFFB347),
                      bgColor: const Color(0xFFFFF3E0),
                      title: 'Password Power',
                      subtitle: 'Learn to create a strong password!',
                      progress: passwordProgress?.stepsCompleted ?? 0,
                      totalLessons: passwordProgress?.totalSteps ?? 4,
                      stepsList: const [],
                      onTap: () async {
                        SoundService.playClick();
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (context, anim, second) => const PasswordPowerScreen(),
                            transitionsBuilder: (context, anim, second, child) => FadeTransition(opacity: anim, child: child),
                          ),
                        );
                        _refresh();
                      },
                    ),
                    3,
                  ),
                  const SizedBox(height: 12),
                  _animateIn(
                    LearningTaskCard(
                      emoji: '🎣',
                      iconColor: const Color(0xFF26A69A),
                      bgColor: const Color(0xFFE0F2F1),
                      title: 'Phishing Detective',
                      subtitle: 'Become an expert at spotting fake messages!',
                      progress: phishingProgress?.stepsCompleted ?? 0,
                      totalLessons: phishingProgress?.totalSteps ?? 6,
                      stepsList: const [],
                      onTap: () async {
                        SoundService.playClick();
                        await Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (context, anim, second) => const PhishingDetectiveScreen(),
                            transitionsBuilder: (context, anim, second, child) => FadeTransition(opacity: anim, child: child),
                          ),
                        );
                        _refresh();
                      },
                    ),
                    4,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}