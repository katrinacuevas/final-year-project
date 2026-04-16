import 'package:flutter/material.dart';
import '../screens/password_screen.dart';
import '../screens/phishing_screen.dart';
import '../widgets/welcome_card.dart';
import '../widgets/daily_challenge.dart';
import '../widgets/learning_task.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SingleChildScrollView(
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
            // Password power card
            LearningTaskCard(
              icon: Icons.lock,
              iconColor: Colors.orange,
              title: 'Password Power',
              subtitle: 'Learn to create a strong password!',
              progress: 1,
              totalLessons: 1,
              stars: 1,
              duration: '10 mins',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordPowerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Phishing detective card
            LearningTaskCard(
              icon: Icons.search,
              iconColor: Colors.grey,
              title: 'Phishing Detective',
              subtitle: 'Become an expert at spotting fake messages!',
              progress: 3,
              totalLessons: 6,
              stars: 3,
              duration: '20 mins',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhishingDetectiveScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Baiting pro card
            LearningTaskCard(
              icon: Icons.card_giftcard,
              iconColor: Colors.red,
              title: 'Baiting Pro',
              subtitle: 'Investigate offers that are too good to be true!',
              progress: 2,
              totalLessons: 5,
              stars: 2,
              duration: '22 mins',
              onTap: () {
                // Add navigation for baiting screen when ready
                // Navigator.push(...);
              },
            ),
          ],
        ),
      ),
    );
  }
}