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
    _refresh();
  }

  Future<void> _refresh() async {
    await UserService.instance.loadAllProgress();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
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
                  const WelcomeCard(),
                  const SizedBox(height: 10),
                  const DailyChallengeCard(),
                  const SizedBox(height: 10),
                  Text(
                    'Learning Tasks',
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F355E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LearningTaskCard(
                    emoji: '🔒',
                    iconColor: const Color(0xFFFFB347),
                    bgColor: const Color(0xFFFFF3E0),
                    title: 'Password Power',
                    subtitle: 'Learn to create a strong password!',
                    progress: passwordProgress?.stepsCompleted ?? 0,
                    totalLessons: passwordProgress?.totalSteps ?? 4,
                    onTap: () async {
                      SoundService.playClick();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordPowerScreen(),
                        ),
                      );
                      _refresh();
                    },
                  ),
                  const SizedBox(height: 12),
                  LearningTaskCard(
                    emoji: '🎣',
                    iconColor: const Color(0xFF26A69A),
                    bgColor: const Color(0xFFE0F2F1),
                    title: 'Phishing Detective',
                    subtitle: 'Become an expert at spotting fake messages!',
                    progress: phishingProgress?.stepsCompleted ?? 0,
                    totalLessons: phishingProgress?.totalSteps ?? 6,
                    onTap: () async {
                      SoundService.playClick();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhishingDetectiveScreen(),
                        ),
                      );
                      _refresh();
                    },
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