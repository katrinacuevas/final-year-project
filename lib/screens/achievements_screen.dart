import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';

const List<Map<String, dynamic>> achievementCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'subtitle': 'Learning to create super strong, secure passwords!',
    'totalSteps': 6,
    'xpReward': 100,
    'accentColor': Color(0xFFFFC857),
    'courseEmoji': '🔐',
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key', 'desc': 'Started your first lesson'},
      {'step': 3, 'emoji': '🛡️', 'name': 'Shield Up', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'subtitle': 'Becoming an expert at spotting fake messages!',
    'totalSteps': 6,
    'xpReward': 150,
    'accentColor': Color(0xFF4FC3F7),
    'courseEmoji': '🎣',
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes', 'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Super Sleuth', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'subtitle': 'Investigating suspicious offers that are too good to be true!',
    'totalSteps': 6,
    'xpReward': 200,
    'accentColor': Color(0xFFFF8A65),
    'courseEmoji': '🎁',
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious', 'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster', 'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting',
    'subtitle': 'Learning to spot people who pretend to be someone else!',
    'totalSteps': 5,
    'xpReward': 180,
    'accentColor': Color(0xFFBA68C8),
    'courseEmoji': '🎭',
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious', 'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off', 'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String selectedFilter = 'All';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    await UserService.instance.loadAllProgress();
    await UserService.instance.refreshProfile();
    if (mounted) setState(() => loading = false);
  }

  int get totalSteps =>
      achievementCourses.fold(0, (s, c) => s + (c['totalSteps'] as int));

  int get completedSteps {
    int t = 0;
    for (final c in achievementCourses) {
      t += UserService.instance
              .getProgress(c['lessonId'] as String)
              ?.stepsCompleted ??
          0;
    }
    return t;
  }

  int get completedCourses => achievementCourses
      .where((c) =>
          UserService.instance
              .getProgress(c['lessonId'] as String)
              ?.completed ??
          false)
      .length;

  double get overallProgress =>
      totalSteps == 0 ? 0 : (completedSteps / totalSteps).clamp(0.0, 1.0);

  List<Map<String, dynamic>> get filtered {
    switch (selectedFilter) {
      case 'Completed':
        return achievementCourses
            .where((c) =>
                UserService.instance
                    .getProgress(c['lessonId'] as String)
                    ?.completed ??
                false)
            .toList();
      case 'In Progress':
        return achievementCourses.where((c) {
          final p =
              UserService.instance.getProgress(c['lessonId'] as String);
          return p != null && !p.completed && p.stepsCompleted > 0;
        }).toList();
      case 'Not Started':
        return achievementCourses.where((c) {
          final p =
              UserService.instance.getProgress(c['lessonId'] as String);
          return p == null || p.stepsCompleted == 0;
        }).toList();
      default:
        return achievementCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: AchievementsGridPainter())),
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
                              const Icon(Icons.emoji_events_rounded,
                                  color: Color(0xFF00D1FF), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'ACHIEVEMENTS',
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
                          buildStatsCard(),
                          const SizedBox(height: 16),
                          buildFilterTabs(),
                          const SizedBox(height: 16),
                          ...filtered.asMap().entries.map((entry) {
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                  milliseconds: 400 + (entry.key * 100)),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 30 * (1 - value)),
                                  child: child,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: AchievementCard(course: entry.value),
                              ),
                            );
                          }),
                          if (filtered.isEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      selectedFilter == 'Completed'
                                          ? '🎯'
                                          : selectedFilter == 'In Progress'
                                              ? '🚀'
                                              : '🎉',
                                      style: const TextStyle(fontSize: 48),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      selectedFilter == 'Completed'
                                          ? 'No courses completed yet\nKeep going, agent! 💪'
                                          : selectedFilter == 'In Progress'
                                              ? 'No courses in progress yet!\nStart a lesson to begin.'
                                              : 'All courses started! 🎉',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.fredoka(
                                        fontSize: 16,
                                        color: Colors.white38,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget buildStatsCard() {
    final pct = (overallProgress * 100).round();
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
          Text(
            'OVERALL PROGRESS',
            style: GoogleFonts.fredoka(
              color: const Color(0xFF00D1FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: overallProgress),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, child) => SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: v,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor:
                          const Color(0xFF00D1FF).withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overallProgress >= 1.0
                            ? const Color(0xFF00E676)
                            : const Color(0xFF00D1FF),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$pct%',
                      style: GoogleFonts.fredoka(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Complete',
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        color: Colors.white38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatPill(
                label: '$completedCourses / ${achievementCourses.length}',
                sub: 'courses',
              ),
              const SizedBox(width: 10),
              StatPill(
                label: '$completedSteps / $totalSteps',
                sub: 'steps',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFilterTabs() {
    final filters = ['All', 'Completed', 'In Progress', 'Not Started'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                SoundService.playClick();
                setState(() => selectedFilter = f);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00D1FF)
                      : const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00D1FF)
                        : const Color(0xFF00D1FF).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  f,
                  style: GoogleFonts.fredoka(
                    color: isSelected
                        ? const Color(0xFF0D1117)
                        : Colors.white54,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AchievementCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const AchievementCard({super.key, required this.course});

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  bool expanded = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final String lessonId = widget.course['lessonId'] as String;
    final Color accent = widget.course['accentColor'] as Color;
    final List milestones = widget.course['milestones'] as List;

    final p = UserService.instance.getProgress(lessonId);
    final int steps = p?.stepsCompleted ?? 0;
    final int totalSteps = widget.course['totalSteps'] as int;
    final double progressFraction =
        totalSteps > 0 ? (steps / totalSteps).clamp(0.0, 1.0) : 0.0;
    final bool isCompleted = steps >= totalSteps && totalSteps > 0;
    final int badgesEarned =
        milestones.where((m) => steps >= (m['step'] as int)).length;

    return GestureDetector(
      onTapDown: (details) => setState(() => isPressed = true),
      onTapUp: (details) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        SoundService.playClick();
        setState(() => expanded = !expanded);
      },
      child: AnimatedScale(
        scale: isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF00E676).withValues(alpha: 0.4)
                  : accent.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                        widget.course['courseEmoji'] as String,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.course['title'] as String,
                                style: GoogleFonts.fredoka(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                '🏅 $badgesEarned / ${milestones.length}',
                                style: GoogleFonts.fredoka(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.course['subtitle'] as String,
                          style: GoogleFonts.fredoka(
                            fontSize: 13,
                            color: Colors.white54,
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
                  Text(
                    '$steps / $totalSteps steps',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? const Color(0xFF00E676) : accent,
                    ),
                  ),
                  Text(
                    '${(progressFraction * 100).toInt()}%',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? const Color(0xFF00E676) : accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: progressFraction),
                builder: (context, value, child) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 7,
                    backgroundColor: accent.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF00E676) : accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expanded ? 'Hide badges' : 'View badges',
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      color: const Color(0xFF00D1FF).withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF00D1FF).withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Divider(
                      color: const Color(0xFF00D1FF).withValues(alpha: 0.12),
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'BADGES',
                      style: GoogleFonts.fredoka(
                        color: Colors.white38,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: milestones.asMap().entries.map((e) {
                        final m = e.value as Map<String, dynamic>;
                        final earned = steps >= (m['step'] as int);
                        return Expanded(
                          child: MilestoneBadge(
                            emoji: m['emoji'] as String,
                            name: m['name'] as String,
                            desc: m['desc'] as String,
                            earned: earned,
                            accent: accent,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MilestoneBadge extends StatelessWidget {
  final String emoji, name, desc;
  final bool earned;
  final Color accent;

  const MilestoneBadge({
    super.key,
    required this.emoji,
    required this.name,
    required this.desc,
    required this.earned,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: const Color(0xFF161B2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: earned
                  ? accent.withValues(alpha: 0.4)
                  : const Color(0xFF00D1FF).withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: earned
                            ? [accent, const Color(0xFF0D1117)]
                            : [
                                Colors.white12,
                                const Color(0xFF0D1117),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: earned
                            ? accent.withValues(alpha: 0.6)
                            : Colors.white12,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        earned ? emoji : '🔒',
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.white54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: earned
                        ? accent.withValues(alpha: 0.15)
                        : const Color(0xFF00D1FF).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: earned
                          ? accent.withValues(alpha: 0.5)
                          : const Color(0xFF00D1FF).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    earned ? '✅  Unlocked!' : '🔒  Keep going to unlock',
                    style: GoogleFonts.fredoka(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: earned ? accent : Colors.white38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: earned
                    ? [accent.withValues(alpha: 0.3), const Color(0xFF0D1117)]
                    : [Colors.white.withValues(alpha: 0.04), const Color(0xFF0D1117)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: earned
                    ? accent.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.1),
                width: earned ? 2 : 1.5,
              ),
              boxShadow: earned
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                earned ? emoji : '🔒',
                style: TextStyle(fontSize: earned ? 28 : 22),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.fredoka(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: earned ? Colors.white : Colors.white24,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class StatPill extends StatelessWidget {
  final String label, sub;

  const StatPill({
    super.key,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00D1FF),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            sub,
            style: GoogleFonts.fredoka(
              fontSize: 12,
              color: const Color(0xFF00D1FF).withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsGridPainter extends CustomPainter {
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