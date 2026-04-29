import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/welcome_card.dart';
import '../widgets/daily_challenge.dart';
import '../widgets/learning_task.dart';
import '../screens/password_screen.dart';
import '../screens/phishing_screen.dart';
import '../screens/baiting_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = UserService.instance.profile;
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = _userProfile?.username ?? "Explorer";

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
            Text(
              'Learning tasks for $displayName',
              style: const TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2E45),
              ),
            ),
            const SizedBox(height: 16),
            
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BaitingScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}