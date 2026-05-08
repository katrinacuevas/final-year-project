import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';

const List<Map<String, dynamic>> _kCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'subtitle': 'Learning to create super strong, secure passwords!',
    'totalSteps': 4,
    'xpReward': 100,
    'bgColor': Color(0xFFFFF3E0),
    'iconColor': Color(0xFFFFB347),
    'progressColor': Color(0xFFFFB347),
    'accentColor': Color(0xFFFF5722),
    'courseEmoji': '🔒',
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key', 'desc': 'Started your first lesson'},
      {'step': 2, 'emoji': '🛡️', 'name': 'Shield Up', 'desc': 'Halfway through the course'},
      {'step': 4, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'subtitle': 'Becoming an expert at spotting fake messages!',
    'totalSteps': 6,
    'xpReward': 150,
    'bgColor': Color(0xFFE0F2F1),
    'iconColor': Color(0xFF26A69A),
    'progressColor': Color(0xFF26A69A),
    'accentColor': Color(0xFF2E7D32),
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
    'bgColor': Color(0xFFFFEBEB),
    'iconColor': Color(0xFFFF7F7F),
    'progressColor': Color(0xFFFF7F7F),
    'accentColor': Color(0xFFFF5252),
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
    'bgColor': Color(0xFFF0EBFF),
    'iconColor': Color(0xFFB39DDB),
    'progressColor': Color(0xFFB39DDB),
    'accentColor': Color(0xFF7C4DFF),
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
  String _selectedFilter = 'All';
  bool _loading = true;

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

  int get _totalSteps => _kCourses.fold(0, (s, c) => s + (c['totalSteps'] as int));

  int get _completedSteps {
    int t = 0;
    for (final c in _kCourses) {
      t += UserService.instance.getProgress(c['lessonId'] as String)?.stepsCompleted ?? 0;
    }
    return t;
  }

  int get _completedCourses => _kCourses
      .where((c) => UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false)
      .length;

  double get _overallProgress => _totalSteps == 0 ? 0 : (_completedSteps / _totalSteps).clamp(0.0, 1.0);

  List<Map<String, dynamic>> get _filtered {
    switch (_selectedFilter) {
      case 'Completed':
        return _kCourses.where((c) => UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false).toList();
      case 'In progress':
        return _kCourses.where((c) {
          final p = UserService.instance.getProgress(c['lessonId'] as String);
          return p != null && !p.completed && p.stepsCompleted > 0;
        }).toList();
      case 'Not Complete':
        return _kCourses.where((c) => !(UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false)).toList();
      default:
        return _kCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 240, 197),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCard(),
                      const SizedBox(height: 10),
                      _buildFilterTabs(),
                      const SizedBox(height: 16),
                      ..._filtered.asMap().entries.map((entry) {
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 400 + (entry.key * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _AchievementCard(course: entry.value),
                          ),
                        );
                      }),
                      if (_filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              _selectedFilter == 'Completed'
                                  ? 'No courses completed yet — keep going! 💪'
                                  : _selectedFilter == 'In progress'
                                      ? 'No courses started yet!'
                                      : 'All courses complete! 🎉',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final pct = (_overallProgress * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(alignment: Alignment.center, children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _overallProgress),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                builder: (_, v, __) => SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: v,
                    strokeWidth: 13,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFF0F4FF),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
                  ),
                ),
              ),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('$pct%',
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF1A2E45))),
                const Text('Complete',
                    style: TextStyle(fontSize: 13, color: Color(0xFF7A9BB5), fontWeight: FontWeight.w600)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatPill(
                  label: '$_completedCourses / ${_kCourses.length}',
                  sub: 'courses',
                  bgColor: const Color(0xFFE3F0FC),
                  textColor: const Color(0xFF1565C0)),
              const SizedBox(width: 10),
              _StatPill(
                  label: '$_completedSteps / $_totalSteps',
                  sub: 'steps',
                  bgColor: const Color(0xFFE3F0FC),
                  textColor: const Color(0xFF1565C0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Completed', 'In progress', 'Not Complete'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () async {
                SoundService.playClick();
                setState(() => _selectedFilter = f);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A2E45) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1A2E45) : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [BoxShadow(color: const Color(0xFF1A2E45).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Text(f,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AchievementCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const _AchievementCard({required this.course});

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard> {
  bool _expanded = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final lessonId = widget.course['lessonId'] as String;
    final bgColor = widget.course['bgColor'] as Color;
    final iconColor = widget.course['iconColor'] as Color;
    final accentColor = widget.course['accentColor'] as Color;
    final milestones = widget.course['milestones'] as List;

    final p = UserService.instance.getProgress(lessonId);
    final steps = p?.stepsCompleted ?? 0;
    final badgesEarned = milestones.where((m) => steps >= (m['step'] as int)).length;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        SoundService.playClick();
        setState(() => _expanded = !_expanded);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.18),
                blurRadius: 16,
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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(0.12)),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(0.08)),
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
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(color: iconColor.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.course['courseEmoji'] as String,
                              style: const TextStyle(fontSize: 34),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.course['title'] as String,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: iconColor.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '🏅 $badgesEarned / ${milestones.length}',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accentColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.course['subtitle'] as String,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF4A6580), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          _expanded ? 'Hide badges' : 'View badges',
                          style: TextStyle(fontSize: 12, color: iconColor, fontWeight: FontWeight.w700),
                        ),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.keyboard_arrow_down, color: iconColor, size: 22),
                        ),
                      ]),
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Divider(color: iconColor.withOpacity(0.2), thickness: 1.5),
                          const SizedBox(height: 10),
                          Row(
                            children: milestones.asMap().entries.map((e) {
                              final m = e.value as Map<String, dynamic>;
                              final earned = steps >= (m['step'] as int);
                              return Expanded(
                                child: _MilestoneBadge(
                                  emoji: m['emoji'] as String,
                                  name: m['name'] as String,
                                  desc: m['desc'] as String,
                                  earned: earned,
                                  accentColor: accentColor,
                                  iconColor: iconColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  final String emoji, name, desc;
  final bool earned;
  final Color accentColor, iconColor;

  const _MilestoneBadge({
    required this.emoji,
    required this.name,
    required this.desc,
    required this.earned,
    required this.accentColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(scale: value, child: child),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: earned ? accentColor.withOpacity(0.15) : Colors.grey.shade100,
                ),
                child: Center(child: Text(earned ? emoji : '🔒', style: const TextStyle(fontSize: 40))),
              ),
            ),
            const SizedBox(height: 14),
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            const SizedBox(height: 6),
            Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF7A9BB5))),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: earned ? accentColor.withOpacity(0.12) : const Color(0xFFEFF4FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                earned ? '✅ Unlocked!' : '🔒 Keep going to unlock',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: earned ? accentColor : const Color(0xFF9AABBF)),
              ),
            ),
          ]),
        ),
      ),
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: earned ? iconColor.withOpacity(0.18) : Colors.white.withOpacity(0.6),
            border: Border.all(color: earned ? iconColor : Colors.grey.shade300, width: earned ? 2.5 : 1.5),
            boxShadow: earned ? [BoxShadow(color: iconColor.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          child: Center(child: Text(earned ? emoji : '🔒', style: TextStyle(fontSize: earned ? 28 : 22))),
        ),
        const SizedBox(height: 6),
        Text(name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: earned ? const Color(0xFF1A2E45) : Colors.grey.shade400)),
      ]),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label, sub;
  final Color bgColor, textColor;
  const _StatPill({
    required this.label,
    required this.sub,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: textColor.withOpacity(0.2), width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor)),
          const SizedBox(width: 4),
          Text(sub, style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.7), fontWeight: FontWeight.w600)),
        ]),
      );
}