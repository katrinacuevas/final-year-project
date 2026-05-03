import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE066), Color(0xFFFFB347)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB347).withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            'Daily Challenge',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF7A4500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Text('⏱️', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '10 mins',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A4500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Spot the Fake Email 🎣',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4A2800),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Can you tell which email is trying to trick you?',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7A4500),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A2800),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('▶', style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                'Play Now',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                      ),
                      child: Text(
                        '✨ +50 XP',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: const Color(0xFF4A2800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}