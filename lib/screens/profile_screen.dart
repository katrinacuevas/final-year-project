import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';

const List<Map<String, dynamic>> profileCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'emoji': '🔐',
    'accentColor': Color(0xFFFFC857),
    'totalSteps': 4,
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key', 'desc': 'Started your first lesson'},
      {'step': 2, 'emoji': '🛡️', 'name': 'Shield Up', 'desc': 'Halfway through the course'},
      {'step': 4, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'emoji': '🎣',
    'accentColor': Color(0xFF4FC3F7),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes', 'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Super Sleuth', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'emoji': '🎁',
    'accentColor': Color(0xFFFF8A65),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious', 'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster', 'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting',
    'emoji': '🎭',
    'accentColor': Color(0xFFBA68C8),
    'totalSteps': 5,
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious', 'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off', 'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

const List<Map<String, String>> safetyRules = [
  {
    'icon': '🔒',
    'title': 'Keep passwords strong & private',
    'detail': 'Use a mix of letters, numbers and symbols. Never share your password with anyone — not even friends.',
  },
  {
    'icon': '🎣',
    'title': 'Spot fake messages',
    'detail': 'If a message asks you to click a link urgently or give personal info, it might be phishing. Always check with a trusted adult.',
  },
  {
    'icon': '🎁',
    'title': 'If it seems too good, it probably is',
    'detail': "Free prizes, gift cards, and \"you've won!\" messages are almost always scams designed to trick you.",
  },
  {
    'icon': '🎭',
    'title': "Verify who you're talking to",
    'detail': 'Anyone can pretend to be someone else online. Always verify identities before sharing personal information.',
  },
  {
    'icon': '👨‍👩‍👧',
    'title': 'Tell a trusted adult',
    'detail': 'If anything online makes you feel uncomfortable or confused, always tell a parent, guardian or teacher straight away.',
  },
];

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

  Widget buildPageDots(int count, int activePage) {
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
                                'MY PROFILE',
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
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161B2E),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: const Color(0xFF00D1FF)
                                      .withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.elasticOut,
                                    builder: (context, value, child) =>
                                        Transform.scale(
                                            scale: value, child: child),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(28),
                                        gradient: LinearGradient(
                                          colors: [
                                            avatarColor,
                                            const Color(0xFF0D1117),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color:
                                              avatarColor.withValues(alpha: 0.7),
                                          width: 2.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          avatarEmoji,
                                          style:
                                              const TextStyle(fontSize: 50),
                                        ),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00D1FF)
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: const Color(0xFF00D1FF)
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.star_rounded,
                                                color: Color(0xFF00D1FF),
                                                size: 13),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    duration:
                                        const Duration(milliseconds: 1400),
                                    curve: Curves.easeInOutQuart,
                                    tween: Tween<double>(
                                        begin: 0, end: totalProgress),
                                    builder: (context, value, child) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: LinearProgressIndicator(
                                        value: value,
                                        minHeight: 10,
                                        backgroundColor: const Color(0xFF00D1FF)
                                            .withValues(alpha: 0.1),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          value >= 1.0
                                              ? const Color(0xFF00E676)
                                              : const Color(0xFF00D1FF),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          ProfileSectionHeader(title: 'Tasks Completed'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 110,
                            child: completed.isEmpty
                                ? Center(
                                    child: Text(
                                      'No courses completed yet — keep going! 💪',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 14,
                                        color: Colors.white38,
                                      ),
                                    ),
                                  )
                                : PageView.builder(
                                    itemCount: completed.length,
                                    onPageChanged: (p) =>
                                        setState(() => taskPage = p),
                                    itemBuilder: (context, i) {
                                      final course = completed[i];
                                      final Color accent =
                                          course['accentColor'] as Color;
                                      return AnimatedScale(
                                        duration:
                                            const Duration(milliseconds: 350),
                                        scale: taskPage == i ? 1.0 : 0.92,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF161B2E),
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                              border: Border.all(
                                                color: const Color(0xFF00E676)
                                                    .withValues(alpha: 0.4),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        accent,
                                                        const Color(0xFF0D1117),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    border: Border.all(
                                                      color: accent.withValues(
                                                          alpha: 0.6),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      course['emoji'] as String,
                                                      style: const TextStyle(
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        course['title']
                                                            as String,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10,
                                                            vertical: 3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                                  0xFF00E676)
                                                              .withValues(
                                                                  alpha: 0.12),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color: const Color(
                                                                    0xFF00E676)
                                                                .withValues(
                                                                    alpha: 0.4),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          '✅ Completed!',
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFF00E676),
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
                          ),
                          if (completed.length > 1) ...[
                            const SizedBox(height: 10),
                            buildPageDots(completed.length, taskPage),
                          ],
                          const SizedBox(height: 28),
                          ProfileSectionHeader(title: 'Badges Earned'),
                          const SizedBox(height: 12),
                          badges.isEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Complete lessons to earn badges! 🏅',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 14,
                                      color: Colors.white38,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 110,
                                  child: PageView.builder(
                                    itemCount: badges.length,
                                    onPageChanged: (p) =>
                                        setState(() => badgePage = p),
                                    itemBuilder: (context, i) {
                                      final badge = badges[i];
                                      final Color accent =
                                          badge['accentColor'] as Color;
                                      return AnimatedScale(
                                        duration:
                                            const Duration(milliseconds: 350),
                                        scale: badgePage == i ? 1.0 : 0.92,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF161B2E),
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                              border: Border.all(
                                                color: accent.withValues(
                                                    alpha: 0.35),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        accent,
                                                        const Color(0xFF0D1117),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    border: Border.all(
                                                      color: accent.withValues(
                                                          alpha: 0.6),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      badge['emoji'] as String,
                                                      style: const TextStyle(
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        badge['name'] as String,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        badge['desc'] as String,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          fontSize: 12,
                                                          color: Colors.white54,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        badge['courseTitle']
                                                            as String,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                ),
                          if (badges.length > 1) ...[
                            const SizedBox(height: 10),
                            buildPageDots(badges.length, badgePage),
                          ],
                          const SizedBox(height: 28),
                          ProfileSectionHeader(title: 'My Safety Rules'),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF161B2E),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0xFF00D1FF)
                                    .withValues(alpha: 0.2),
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
                                      onTap: () => setState(
                                          () => ruleExpanded[i] = !ruleExpanded[i]),
                                    ),
                                    if (i != safetyRules.length - 1)
                                      Divider(
                                        height: 1,
                                        indent: 20,
                                        endIndent: 20,
                                        color: const Color(0xFF00D1FF)
                                            .withValues(alpha: 0.08),
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
          ),
        ],
      ),
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  final String title;
  const ProfileSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.chevron_right_rounded,
            color: Color(0xFF00D1FF), size: 16),
        const SizedBox(width: 4),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.fredoka(
            color: const Color(0xFF00D1FF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class RuleAccordion extends StatelessWidget {
  final String icon, title, detail;
  final bool expanded;
  final VoidCallback onTap;

  const RuleAccordion({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: expanded
              ? const Color(0xFF00D1FF).withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.5),
                    size: 22,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10, left: 34),
                child: Text(
                  detail,
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.5,
                  ),
                ),
              ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}