import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import 'password/password_screen.dart';
import 'phishing/phishing_screen.dart';
import 'baiting/baiting_screen.dart';
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
    final passwordProgress =
        UserService.instance.getProgress('password_power');
    final phishingProgress =
        UserService.instance.getProgress('phishing_detective');
    final baitingProgress =
        UserService.instance.getProgress('baiting_pro');

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeCard(),
              const SizedBox(height: 16),
              const DailyChallengeCard(),
              const SizedBox(height: 24),
              const Text(
                'Learning tasks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              LearningTaskCard(
                icon: Icons.lock,
                iconColor: Colors.orange,
                title: 'Password Power',
                subtitle: 'Learn to create a strong password!',
                progress: passwordProgress?.stepsCompleted ?? 0,
                totalLessons: passwordProgress?.totalSteps ?? 4,
                stars: passwordProgress?.stars ?? 1,
                duration: '10 mins',
                onTap: () async {
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
                icon: Icons.search,
                iconColor: Colors.grey,
                title: 'Phishing Detective',
                subtitle: 'Become an expert at spotting fake messages!',
                progress: phishingProgress?.stepsCompleted ?? 0,
                totalLessons: phishingProgress?.totalSteps ?? 6,
                stars: phishingProgress?.stars ?? 0,
                duration: '20 mins',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhishingDetectiveScreen(),
                    ),
                  );
                  _refresh();
                },
              ),
              const SizedBox(height: 12),
              LearningTaskCard(
                icon: Icons.card_giftcard,
                iconColor: Colors.red,
                title: 'Baiting Pro',
                subtitle: 'Investigate offers that are too good to be true!',
                progress: baitingProgress?.stepsCompleted ?? 0,
                totalLessons: baitingProgress?.totalSteps ?? 5,
                stars: baitingProgress?.stars ?? 0,
                duration: '22 mins',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BaitingScreen(),
                    ),
                  );
                  _refresh();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}