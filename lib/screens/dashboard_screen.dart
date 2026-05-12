import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    refresh();
  }

  Future<void> refresh() async {
    await UserService.instance.loadAllProgress();
    if (mounted) setState(() {});
  }

  Widget animateIn(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Interval((index * 0.1).clamp(0.0, 0.5), 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: DashboardGridPainter())),
        SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: const Color(0xFF00D1FF),
            backgroundColor: const Color(0xFF161B2E),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: ListenableBuilder(
                listenable: UserService.instance,
                builder: (context, child) {
                  final passwordProgress = UserService.instance.getProgress('password_power');
                  final phishingProgress = UserService.instance.getProgress('phishing_detective');

                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    animateIn(const WelcomeCard(), 0),
                    const SizedBox(height: 14),


                    animateIn(const DailyChallengeCard(), 2),
                    const SizedBox(height: 24),
                    animateIn(
                      Row(children: [
                        const Icon(Icons.bolt_rounded, color: Color(0xFF00D1FF), size: 16),
                        const SizedBox(width: 6),
                        Text('LEARNING TASKS',
                          style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 12,
                            fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                      ]),
                      3,
                    ),
                    const SizedBox(height: 12),
                    animateIn(
                      LearningTaskCard(
                        emoji: '🔐',
                        accentColor: const Color(0xFFFFC857),
                        title: 'Password Power',
                        subtitle: 'Learn to create a strong password!',
                        progress: passwordProgress?.stepsCompleted ?? 0,
                        totalLessons: passwordProgress?.totalSteps ?? 6,
                        onTap: () async {
                          SoundService.playClick();
                          await Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) => const PasswordPowerScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                FadeTransition(opacity: animation, child: child),
                          ));
                          refresh();
                        },
                      ),
                      4,
                    ),
                    const SizedBox(height: 12),
                    animateIn(
                      LearningTaskCard(
                        emoji: '🎣',
                        accentColor: const Color(0xFF4FC3F7),
                        title: 'Phishing Detective',
                        subtitle: 'Become an expert at spotting fake messages!',
                        progress: phishingProgress?.stepsCompleted ?? 0,
                        totalLessons: phishingProgress?.totalSteps ?? 6,
                        onTap: () async {
                          SoundService.playClick();
                          await Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) => const PhishingDetectiveScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                FadeTransition(opacity: animation, child: child),
                          ));
                          refresh();
                        },
                      ),
                      5,
                    ),
                  ]);
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class DashboardGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}