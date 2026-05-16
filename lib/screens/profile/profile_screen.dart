import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_service.dart';
import 'profile_data.dart';
import 'profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  int taskPage = 0;
  int badgePage = 0;
  late List<bool> ruleExpanded;

  @override
  void initState() {
    super.initState();
    ruleExpanded = List.generate(safetyRules.length, (index) => false);
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    await UserService.instance.loadAllProgress();
    await UserService.instance.refreshProfile();
    if (mounted) setState(() => loading = false);
  }

  List<Map<String, dynamic>> get earnedBadges {
    final List<Map<String, dynamic>> badges = [];
    for (final course in profileCourses) {
      final lessonId = course['lessonId'] as String;
      final milestones = course['milestones'] as List;
      final p = UserService.instance.getProgress(lessonId);
      final steps = p?.stepsCompleted ?? 0;
      for (final m in milestones) {
        final milestone = m as Map<String, dynamic>;
        if (steps >= (milestone['step'] as int)) {
          badges.add({
            'emoji': milestone['emoji'],
            'name': milestone['name'],
            'desc': milestone['desc'],
            'accentColor': course['accentColor'],
            'courseTitle': course['title'],
          });
        }
      }
    }
    return badges;
  }

  List<Map<String, dynamic>> get completedCourses {
    return profileCourses.where((course) {
      final p = UserService.instance.getProgress(course['lessonId'] as String);
      return p?.completed ?? false;
    }).toList();
  }

  Widget _buildPageDots(int count, int activePage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: activePage == i ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: activePage == i
                ? const Color(0xFF00D1FF)
                : const Color(0xFF00D1FF).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final svc = UserService.instance;
    final profile = svc.profile;
    final String name = profile?.username ?? 'Explorer';
    final String avatarEmoji = profile?.avatarEmoji ?? '👤';
    final int xp = svc.xp;
    final int level = svc.level;
    final int nextXp = svc.xpNeededForNextLevel;
    final double totalProgress =
        nextXp > 0 ? (xp / nextXp).clamp(0.0, 1.0) : (xp > 0 ? 1.0 : 0.0);

    Color avatarColor;
    try {
      avatarColor = Color(int.parse(profile?.avatarColour ?? '0xFFFFC857'));
    } catch (e) {
      avatarColor = const Color(0xFFFFC857);
    }

    final badges = earnedBadges;
    final completed = completedCourses;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: ProfileGridPainter())),
          SafeArea(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF00D1FF),
                      backgroundColor:
                          const Color(0xFF00D1FF).withValues(alpha: 0.1),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: load,
                    color: const Color(0xFF00D1FF),
                    backgroundColor: const Color(0xFF161B2E),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_rounded,
                                  color: Color(0xFF00D1FF), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'PROFILE',
                                style: GoogleFonts.fredoka(
                                  color: const Color(0xFF00D1FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) => Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: child,
                              ),
                            ),
                            child: _buildProfileCard(
                              name: name,
                              avatarEmoji: avatarEmoji,
                              avatarColor: avatarColor,
                              level: level,
                              xp: xp,
                              nextXp: nextXp,
                              totalProgress: totalProgress,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const ProfileSectionHeader(title: 'Tasks Completed'),
                          const SizedBox(height: 12),
                          _buildTasksSection(completed),
                          if (completed.length > 1) ...[
                            const SizedBox(height: 10),
                            _buildPageDots(completed.length, taskPage),
                          ],
                          const SizedBox(height: 28),
                          const ProfileSectionHeader(title: 'Badges Earned'),
                          const SizedBox(height: 12),
                          _buildBadgesSection(badges),
                          if (badges.length > 1) ...[
                            const SizedBox(height: 10),
                            _buildPageDots(badges.length, badgePage),
                          ],
                          const SizedBox(height: 28),
                          const ProfileSectionHeader(title: 'My Safety Rules'),
                          const SizedBox(height: 4),
                          _buildSafetyRules(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String avatarEmoji,
    required Color avatarColor,
    required int level,
    required int xp,
    required int nextXp,
    required double totalProgress,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [avatarColor, const Color(0xFF0D1117)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: avatarColor.withValues(alpha: 0.7),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Text(avatarEmoji, style: const TextStyle(fontSize: 50)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFF00D1FF), size: 13),
                    const SizedBox(width: 4),
                    Text(
                      'LEVEL $level',
                      style: GoogleFonts.fredoka(
                        color: const Color(0xFF00D1FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LEVEL PROGRESS',
                style: GoogleFonts.fredoka(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '$xp / $nextXp XP',
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00D1FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeInOutQuart,
            tween: Tween<double>(begin: 0, end: totalProgress),
            builder: (context, value, child) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor:
                    const Color(0xFF00D1FF).withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 1.0
                      ? const Color(0xFF00E676)
                      : const Color(0xFF00D1FF),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection(List<Map<String, dynamic>> completed) {
    if (completed.isEmpty) {
      return SizedBox(
        height: 110,
        child: Center(
          child: Text(
            'No courses completed yet — keep going! 💪',
            style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white38),
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: PageView.builder(
        itemCount: completed.length,
        onPageChanged: (p) => setState(() => taskPage = p),
        itemBuilder: (context, i) {
          final course = completed[i];
          final Color accent = course['accentColor'] as Color;
          return AnimatedScale(
            duration: const Duration(milliseconds: 350),
            scale: taskPage == i ? 1.0 : 0.92,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF00E676).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [accent, const Color(0xFF0D1117)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          course['emoji'] as String,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            course['title'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E676)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF00E676)
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              '✅ Completed!',
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00E676),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgesSection(List<Map<String, dynamic>> badges) {
    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Complete lessons to earn badges! 🏅',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white38),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: PageView.builder(
        itemCount: badges.length,
        onPageChanged: (p) => setState(() => badgePage = p),
        itemBuilder: (context, i) {
          final badge = badges[i];
          final Color accent = badge['accentColor'] as Color;
          return AnimatedScale(
            duration: const Duration(milliseconds: 350),
            scale: badgePage == i ? 1.0 : 0.92,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [accent, const Color(0xFF0D1117)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          badge['emoji'] as String,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge['name'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge['desc'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              fontSize: 12,
                              color: Colors.white54,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            badge['courseTitle'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredoka(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSafetyRules() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: safetyRules.asMap().entries.map((e) {
          final i = e.key;
          final rule = e.value;
          return Column(
            children: [
              RuleAccordion(
                icon: rule['icon']!,
                title: rule['title']!,
                detail: rule['detail']!,
                expanded: ruleExpanded[i],
                onTap: () =>
                    setState(() => ruleExpanded[i] = !ruleExpanded[i]),
              ),
              if (i != safetyRules.length - 1)
                Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: const Color(0xFF00D1FF).withValues(alpha: 0.08),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
