import 'package:flutter/material.dart';
import '../services/user_service.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = UserService.instance.profile;
    final String name = profile?.username ?? "Explorer";
    final String emoji = profile?.avatarEmoji ?? "👤";
    
    Color avatarBg;
    try {
      avatarBg = Color(int.parse(profile?.avatarColour ?? "0xFFBBDEFB"));
    } catch (e) {
      avatarBg = const Color(0xFFBBDEFB);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: avatarBg,
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 45,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back, $name!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Level 1', 
                      style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      '200 / 500 XP', 
                      style: TextStyle(color: Colors.white70, fontSize: 12)
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.4, 
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}