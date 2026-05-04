import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';
import '../widgets/profile_data.dart';
import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _taskPage = 0;
  int _badgePage = 0;
  final List<bool> _ruleExpanded =
      List.generate(ProfileData.safetyRules.length, (_) => false);

  Color _getLevelColor(int level) {
    if (level >= 5) return Colors.orange;
    if (level >= 4) return Colors.cyan;
    if (level >= 3) return Colors.green;
    if (level >= 2) return Colors.purple;
    if (level >= 1) return Colors.pink;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final svc = UserService.instance;
    final profile = svc.profile;

    final String name = profile?.username ?? "Explorer";
    final String emoji = profile?.avatarEmoji ?? "👤";
    final int xp = svc.xp;
    final int level = svc.level;
    final int nextXp = svc.xpNeededForNextLevel;

    double totalProgress = nextXp > 0 ? (xp / nextXp).clamp(0.0, 1.0) : 1.0;
    final Color currentLevelColor = _getLevelColor(level);
    final Color lightLevelColor = currentLevelColor.withValues(alpha: 0.1);

    Color avatarBg;
    try {
      avatarBg = Color(int.parse(profile?.avatarColour ?? "0xFFFFE4B5"));
    } catch (e) {
      avatarBg = const Color(0xFFFFE4B5);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: lightLevelColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: currentLevelColor.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: avatarBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentLevelColor,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.quicksand(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A2E45),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentLevelColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '⭐ Level $level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level Progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: currentLevelColor,
                          ),
                        ),
                        Text(
                          '$xp / $nextXp XP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: currentLevelColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: totalProgress,
                        minHeight: 12,
                        backgroundColor: const Color(0xFFF0F4F8),
                        valueColor: AlwaysStoppedAnimation<Color>(currentLevelColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'Tasks Completed'),
              Carousel(
                itemCount: ProfileData.completedTasks.length,
                currentPage: _taskPage,
                onPageChanged: (p) => setState(() => _taskPage = p),
                itemBuilder: (i) => TaskCard(task: ProfileData.completedTasks[i]),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'Badges Earned'),
              Carousel(
                itemCount: ProfileData.badges.length,
                currentPage: _badgePage,
                onPageChanged: (p) => setState(() => _badgePage = p),
                itemBuilder: (i) => BadgeCard(badge: ProfileData.badges[i]),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'My Safety Rules'),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: ProfileData.safetyRules.asMap().entries.map((e) {
                    final i = e.key;
                    final rule = e.value;
                    return Column(
                      children: [
                        RuleAccordion(
                          icon: rule['icon']!,
                          title: rule['title']!,
                          detail: rule['detail']!,
                          expanded: _ruleExpanded[i],
                          onTap: () =>
                              setState(() => _ruleExpanded[i] = !_ruleExpanded[i]),
                        ),
                        if (i != ProfileData.safetyRules.length - 1)
                          const Divider(
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                            color: Color(0xFFF0F4F8),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1F355E),
        ),
      ),
    );
  }
}