import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';

const List<Map<String, dynamic>> _kCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'emoji': '🔒',
    'iconColor': Color(0xFFFFB347),
    'bgColor': Color(0xFFFFF3E0),
    'totalSteps': 4,
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key',       'desc': 'Started your first lesson'},
      {'step': 2, 'emoji': '🛡️', 'name': 'Shield Up',       'desc': 'Halfway through the course'},
      {'step': 4, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'emoji': '🎣',
    'iconColor': Color(0xFF26A69A),
    'bgColor': Color(0xFFE0F2F1),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes',   'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective',    'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Super Sleuth', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'emoji': '🎁',
    'iconColor': Color(0xFFFF7F7F),
    'bgColor': Color(0xFFFFEBEB),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious',   'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster',  'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting',
    'emoji': '🎭',
    'iconColor': Color(0xFFB39DDB),
    'bgColor': Color(0xFFF0EBFF),
    'totalSteps': 5,
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious',       'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off',      'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

const List<Map<String, String>> _kSafetyRules = [
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
    'detail': 'Free prizes, gift cards, and "you\'ve won!" messages are almost always scams designed to trick you.',
  },
  {
    'icon': '🎭',
    'title': 'Verify who you\'re talking to',
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
  bool _loading = true;
  int _taskPage = 0;
  int _badgePage = 0;
  final List<bool> _ruleExpanded =
      List.generate(_kSafetyRules.length, (_) => false);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await UserService.instance.loadAllProgress();
    await UserService.instance.refreshProfile();
    if (mounted) setState(() => _loading = false);
  }

  Color _getLevelColor(int level) {
    if (level >= 5) return Colors.orange;
    if (level >= 4) return Colors.cyan;
    if (level >= 3) return Colors.green;
    if (level >= 2) return Colors.purple;
    if (level >= 1) return Colors.pink;
    return Colors.blue;
  }

  List<Map<String, dynamic>> get _earnedBadges {
    final List<Map<String, dynamic>> badges = [];
    for (final course in _kCourses) {
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
            'iconColor': course['iconColor'],
            'bgColor': course['bgColor'],
            'courseTitle': course['title'],
          });
        }
      }
    }
    return badges;
  }

  List<Map<String, dynamic>> get _completedCourses {
    return _kCourses.where((course) {
      final p =
          UserService.instance.getProgress(course['lessonId'] as String);
      return p?.completed ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final svc = UserService.instance;
    final profile = svc.profile;

    final String name = profile?.username ?? 'Explorer';
    final String emoji = profile?.avatarEmoji ?? '👤';
    final int xp = svc.xp;
    final int level = svc.level;
    final int nextXp = svc.xpNeededForNextLevel;
    final double totalProgress =
        nextXp > 0 ? (xp / nextXp).clamp(0.0, 1.0) : 1.0;
    final Color levelColor = _getLevelColor(level);
    final Color lightLevelColor = levelColor.withOpacity(0.1);

    Color avatarBg;
    try {
      avatarBg =
          Color(int.parse(profile?.avatarColour ?? '0xFFFFE4B5'));
    } catch (_) {
      avatarBg = const Color(0xFFFFE4B5);
    }

    final badges = _earnedBadges;
    final completed = _completedCourses;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                              color: levelColor.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(
                                color: avatarBg,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: levelColor, width: 4),
                              ),
                              child: Center(
                                child: Text(emoji,
                                    style: const TextStyle(
                                        fontSize: 50)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                    color: levelColor,
                                    borderRadius:
                                        BorderRadius.circular(20),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Level Progress',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: levelColor)),
                                Text('$xp / $nextXp XP',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: levelColor)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: totalProgress,
                                minHeight: 12,
                                backgroundColor:
                                    const Color(0xFFF0F4F8),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        levelColor),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),
                      _SectionHeader(title: 'Tasks Completed'),
                      const SizedBox(height: 4),

                      SizedBox(
                        height: 130,
                        child: completed.isEmpty
                            ? Center(
                                child: Text(
                                  'No courses completed yet — keep going! 💪',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500),
                                ),
                              )
                            : PageView.builder(
                                itemCount: completed.length,
                                onPageChanged: (p) =>
                                    setState(() => _taskPage = p),
                                itemBuilder: (_, i) {
                                  final course = completed[i];
                                  final iconColor =
                                      course['iconColor'] as Color;
                                  final bgColor =
                                      course['bgColor'] as Color;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: iconColor
                                                .withOpacity(0.15),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(children: [
                                        Container(
                                          width: 56, height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: iconColor
                                                    .withOpacity(0.2),
                                                blurRadius: 8,
                                                offset:
                                                    const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              course['emoji'] as String,
                                              style: const TextStyle(
                                                  fontSize: 28),
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
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                course['title']
                                                    as String,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    color: Color(
                                                        0xFF1A2E45)),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: iconColor
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                ),
                                                child: Text(
                                                  '✅ Completed!',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: iconColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (completed.length > 1) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            completed.length,
                            (i) => AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3),
                              width: _taskPage == i ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _taskPage == i
                                    ? const Color(0xFF1A2E45)
                                    : Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),
                      _SectionHeader(title: 'Badges Earned'),
                      const SizedBox(height: 4),

                      badges.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Complete lessons to earn badges! 🏅',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500),
                              ),
                            )
                          : SizedBox(
                              height: 130,
                              child: PageView.builder(
                                itemCount: badges.length,
                                onPageChanged: (p) =>
                                    setState(() => _badgePage = p),
                                itemBuilder: (_, i) {
                                  final badge = badges[i];
                                  final iconColor =
                                      badge['iconColor'] as Color;
                                  final bgColor =
                                      badge['bgColor'] as Color;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: iconColor
                                                .withOpacity(0.15),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(children: [
                                        Container(
                                          width: 56, height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: iconColor
                                                    .withOpacity(0.4),
                                                width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: iconColor
                                                    .withOpacity(0.2),
                                                blurRadius: 8,
                                                offset:
                                                    const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              badge['emoji'] as String,
                                              style: const TextStyle(
                                                  fontSize: 28),
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
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                badge['name'] as String,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    color: Color(
                                                        0xFF1A2E45)),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                badge['desc'] as String,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        Color(0xFF5A7A95),
                                                    height: 1.3),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                badge['courseTitle']
                                                    as String,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: iconColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                              ),
                            ),
                      if (badges.length > 1) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            badges.length,
                            (i) => AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3),
                              width: _badgePage == i ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _badgePage == i
                                    ? const Color(0xFF1A2E45)
                                    : Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),
                      _SectionHeader(title: 'My Safety Rules'),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: _kSafetyRules
                              .asMap()
                              .entries
                              .map((e) {
                            final i = e.key;
                            final rule = e.value;
                            return Column(
                              children: [
                                _RuleAccordion(
                                  icon: rule['icon']!,
                                  title: rule['title']!,
                                  detail: rule['detail']!,
                                  expanded: _ruleExpanded[i],
                                  onTap: () => setState(() =>
                                      _ruleExpanded[i] =
                                          !_ruleExpanded[i]),
                                ),
                                if (i !=
                                    _kSafetyRules.length - 1)
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

class _RuleAccordion extends StatelessWidget {
  final String icon, title, detail;
  final bool expanded;
  final VoidCallback onTap;

  const _RuleAccordion({
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
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(icon,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2E45))),
              ),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF9AABBF), size: 22),
              ),
            ]),
            if (expanded) ...[
              const SizedBox(height: 10),
              Text(detail,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5A7A95),
                      height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}