import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import '../screens/daily_screen.dart';

class DailyChallengeCard extends StatefulWidget {
  const DailyChallengeCard({super.key});

  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard> {
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _checkCompleted();
  }

  void _checkCompleted() {
    final progress = UserService.instance.getProgress('daily_challenge');
    setState(() => _completed = progress?.completed ?? false);
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) return const SizedBox.shrink();

    const Color accentColor = Color(0xFFFFB347);
    const Color cardBg = Color(0xFFFFFDE7);

    return GestureDetector(
      onTap: () async {
        SoundService.playClick();
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
        );
        _checkCompleted();
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: -20, top: -20,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              left: -10, bottom: -20,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('⚡', style: TextStyle(fontSize: 34)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Daily Challenge',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7A4500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Spot the Fake Email',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A2E45),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Can you spot which email is trying to trick you?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4A6580),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✨ +50 XP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A4500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        SoundService.playClick();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DailyChallengeScreen()),
                        );
                        _checkCompleted();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Play Now',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}