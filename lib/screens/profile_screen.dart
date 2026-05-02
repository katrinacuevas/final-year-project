import 'package:flutter/material.dart';
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
  final List<bool> _ruleExpanded = List.generate(ProfileData.safetyRules.length, (_) => false);

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

    Color avatarBg;
    try {
      avatarBg = Color(int.parse(profile?.avatarColour ?? "0xFFFFE4B5"));
    } catch (e) {
      avatarBg = const Color(0xFFFFE4B5);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: const Color(0xFFEFF4FB), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.settings, color: Color(0xFF7A9BB5), size: 22),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: avatarBg, 
                            shape: BoxShape.circle, 
                            border: Border.all(color: _getLevelColor(level), width: 3) 
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 54, height: 1))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(color: _getLevelColor(level), borderRadius: BorderRadius.circular(20)),
                          child: Text('⭐ Level $level', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: totalProgress,
                              minHeight: 10,
                              backgroundColor: const Color(0xFFEFF4FB),
                              borderRadius: BorderRadius.circular(10),
                              valueColor: AlwaysStoppedAnimation<Color>(_getLevelColor(level)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('$xp / $nextXp XP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7A9BB5))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: const Color(0xFFEFF4FB), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          StatItem(value: xp.toString(), label: 'XP Earned', emoji: '⚡'),
                          const VertDivider(),
                          const StatItem(value: '6', label: 'Lessons', emoji: '📖'),
                          const VertDivider(),
                          const StatItem(value: '4', label: 'Badges', emoji: '🏅'),
                          const VertDivider(),
                          const StatItem(value: '5', label: 'Day Streak', emoji: '🔥'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _SectionHeader(title: 'Tasks completed:'),
              Carousel(
                itemCount: ProfileData.completedTasks.length,
                currentPage: _taskPage,
                onPageChanged: (p) => setState(() => _taskPage = p),
                itemBuilder: (i) => TaskCard(task: ProfileData.completedTasks[i]),
              ),

              const SizedBox(height: 20),

              _SectionHeader(title: 'Badges earned:'),
              Carousel(
                itemCount: ProfileData.badges.length,
                currentPage: _badgePage,
                onPageChanged: (p) => setState(() => _badgePage = p),
                itemBuilder: (i) => BadgeCard(badge: ProfileData.badges[i]),
              ),

              const SizedBox(height: 20),

              _SectionHeader(title: 'My safety rules'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
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
                            onTap: () => setState(() => _ruleExpanded[i] = !_ruleExpanded[i]),
                          ),
                          if (i != ProfileData.safetyRules.length - 1)
                            const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEFF4FB)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w800, 
            color: Color(0xFF1A2E45)
          ),
        ),
      ),
    );
  }
}