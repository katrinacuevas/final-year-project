import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';

const List<Map<String, dynamic>> _kCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'subtitle': 'Learning to create super strong, secure passwords!',
    'totalSteps': 4,
    'xpReward': 100,
    'color': Color(0xFFFFE4E1),
    'progressColor': Color(0xFFFF7043),
    'accentColor': Color(0xFFFF5722),
    'headerColor': Color(0xFFFF8A65),
    'courseEmoji': '🔒',
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key',       'desc': 'Started your first lesson'},
      {'step': 2, 'emoji': '🛡️', 'name': 'Shield Up',       'desc': 'Halfway through the course'},
      {'step': 4, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'subtitle': 'Becoming an expert at spotting fake messages!',
    'totalSteps': 6,
    'xpReward': 150,
    'color': Color(0xFFE8F5E9),
    'progressColor': Color(0xFF43A047),
    'accentColor': Color(0xFF2E7D32),
    'headerColor': Color(0xFF66BB6A),
    'courseEmoji': '🔍',
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes',   'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective',    'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Super Sleuth', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'subtitle': 'Investigating suspicious offers that are too good to be true!',
    'totalSteps': 6,
    'xpReward': 200,
    'color': Color(0xFFFFF8E1),
    'progressColor': Color(0xFFFFB300),
    'accentColor': Color(0xFFFF8F00),
    'headerColor': Color(0xFFFFCA28),
    'courseEmoji': '🎁',
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious',   'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster',  'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting',
    'subtitle': 'Learning to spot people who pretend to be someone else!',
    'totalSteps': 5,
    'xpReward': 180,
    'color': Color(0xFFF3E5F5),
    'progressColor': Color(0xFF8E24AA),
    'accentColor': Color(0xFF6A1B9A),
    'headerColor': Color(0xFFAB47BC),
    'courseEmoji': '🎭',
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious',       'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off',      'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

const List<Map<String, dynamic>> _kSpecialBadges = [
  {'id': 'first_lesson', 'emoji': '🚀', 'name': 'Blast Off!',   'desc': 'Complete your first step',  'color': Color(0xFFBBDEFB)},
  {'id': 'all_courses',  'emoji': '🌟', 'name': 'All Star',     'desc': 'Complete every course',     'color': Color(0xFFFFF9C4)},
  {'id': 'level_2',      'emoji': '⚡', 'name': 'Power Up',     'desc': 'Reach Level 2',             'color': Color(0xFFFFE0B2)},
  {'id': 'level_3',      'emoji': '🔥', 'name': 'On Fire',      'desc': 'Reach Level 3',             'color': Color(0xFFFFCCBC)},
  {'id': 'xp_300',       'emoji': '💎', 'name': 'XP Collector', 'desc': 'Earn 300 XP total',         'color': Color(0xFFB2EBF2)},
  {'id': 'xp_1000',      'emoji': '👑', 'name': 'XP Champion',  'desc': 'Earn 1000 XP total',        'color': Color(0xFFE8D5FB)},
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

  int get _totalSteps =>
      _kCourses.fold(0, (s, c) => s + (c['totalSteps'] as int));

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

  double get _overallProgress =>
      _totalSteps == 0 ? 0 : (_completedSteps / _totalSteps).clamp(0.0, 1.0);

  Set<String> get _earnedSpecialIds {
    final svc = UserService.instance;
    final earned = <String>{};
    if (_completedSteps > 0)                   earned.add('first_lesson');
    if (_completedCourses == _kCourses.length) earned.add('all_courses');
    if (svc.level >= 2)                        earned.add('level_2');
    if (svc.level >= 3)                        earned.add('level_3');
    if (svc.xp >= 300)                         earned.add('xp_300');
    if (svc.xp >= 1000)                        earned.add('xp_1000');
    return earned;
  }

  List<Map<String, dynamic>> get _filtered {
    switch (_selectedFilter) {
      case 'Completed':
        return _kCourses.where((c) =>
          UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false
        ).toList();
      case 'In progress':
        return _kCourses.where((c) {
          final p = UserService.instance.getProgress(c['lessonId'] as String);
          return p != null && !p.completed && p.stepsCompleted > 0;
        }).toList();
      case 'Not Complete':
        return _kCourses.where((c) =>
          !(UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false)
        ).toList();
      default:
        return _kCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildStatsCard(),
                      const SizedBox(height: 16),
                      _buildFilterTabs(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ..._filtered.map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _AchievementCard(course: c),
                            )),
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
                            const SizedBox(height: 16),
                            _buildSpecialBadgesSection(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final xp = UserService.instance.xp;
    final level = UserService.instance.level;
    final pct = (_overallProgress * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2E45), Color(0xFF2C5282)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1A2E45).withOpacity(0.3),
            blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              const Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
              const SizedBox(width: 6),
              Text('Level $level',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('⭐ $xp XP',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          width: 130, height: 130,
          child: Stack(alignment: Alignment.center, children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _overallProgress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (_, v, __) => SizedBox(
                width: 130, height: 130,
                child: CircularProgressIndicator(
                  value: v, strokeWidth: 13,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                ),
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$pct%', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Complete', style: TextStyle(fontSize: 13, color: Colors.white70)),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StatPill(label: '$_completedCourses/${_kCourses.length}', sub: 'courses'),
          const SizedBox(width: 10),
          _StatPill(label: '$_completedSteps/$_totalSteps', sub: 'steps'),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _completedCourses == _kCourses.length
                ? '🏆 All courses completed!'
                : '🎯 Keep learning to unlock more badges!',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ]),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Completed', 'In progress', 'Not Complete'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A2E45) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1A2E45) : Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(20),
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

  Widget _buildSpecialBadgesSection() {
    final earned = _earnedSpecialIds;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
          blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('✨', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          const Text('Special Badges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E45))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E45).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${earned.length}/${_kSpecialBadges.length}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                color: Color(0xFF1A2E45))),
          ),
        ]),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.88,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _kSpecialBadges.map((b) {
            final isEarned = earned.contains(b['id'] as String);
            return _SpecialBadgeTile(badge: b, earned: isEarned);
          }).toList(),
        ),
      ]),
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

  @override
  Widget build(BuildContext context) {
    final lessonId = widget.course['lessonId'] as String;
    final totalSteps = widget.course['totalSteps'] as int;
    final color = widget.course['color'] as Color;
    final progressColor = widget.course['progressColor'] as Color;
    final accentColor = widget.course['accentColor'] as Color;
    final headerColor = widget.course['headerColor'] as Color;
    final milestones = widget.course['milestones'] as List;

    final p = UserService.instance.getProgress(lessonId);
    final steps = p?.stepsCompleted ?? 0;
    final completed = p?.completed ?? false;
    final fraction = totalSteps == 0 ? 0.0 : (steps / totalSteps).clamp(0.0, 1.0);
    final pct = (fraction * 100).round();
    final badgesEarned = milestones.where((m) => steps >= (m['step'] as int)).length;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: accentColor.withOpacity(0.15),
            blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              color: headerColor.withOpacity(0.35),
              child: Row(children: [
                Text(widget.course['courseEmoji'] as String,
                  style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.course['title'] as String,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E45))),
                ),
                if (completed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Done ✓',
                      style: TextStyle(color: progressColor, fontSize: 11,
                        fontWeight: FontWeight.bold)),
                  ),
              ]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.course['subtitle'] as String,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text('$badgesEarned',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: accentColor)),
                  Text(' / ${milestones.length} badges',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$pct%',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor)),
                ),
              ]),
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: fraction),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                builder: (_, v, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: v, minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completed ? Colors.green.shade500 : progressColor),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_expanded ? 'Hide badges' : 'View badges 🏅',
                    style: TextStyle(fontSize: 12, color: accentColor,
                      fontWeight: FontWeight.w700)),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: accentColor, size: 22),
                  ),
                ]),
              ),
            ]),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Divider(color: accentColor.withOpacity(0.2), thickness: 1.5),
                const SizedBox(height: 10),
                Row(children: milestones.asMap().entries.map((e) {
                  final m = e.value as Map<String, dynamic>;
                  final earned = steps >= (m['step'] as int);
                  return Expanded(child: _MilestoneBadge(
                    emoji: m['emoji'] as String,
                    name: m['name'] as String,
                    desc: m['desc'] as String,
                    earned: earned,
                    accentColor: accentColor,
                    progressColor: progressColor,
                  ));
                }).toList()),
              ]),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ]),
      ),
    );
  }
}

class _MilestoneBadge extends StatelessWidget {
  final String emoji, name, desc;
  final bool earned;
  final Color accentColor, progressColor;

  const _MilestoneBadge({
    required this.emoji,
    required this.name,
    required this.desc,
    required this.earned,
    required this.accentColor,
    required this.progressColor,
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
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: earned ? accentColor.withOpacity(0.15) : Colors.grey.shade100,
              ),
              child: Center(child: Text(
                earned ? emoji : '🔒',
                style: const TextStyle(fontSize: 40))),
            ),
            const SizedBox(height: 14),
            Text(name, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                color: Color(0xFF1A2E45))),
            const SizedBox(height: 6),
            Text(desc, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF7A9BB5))),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: earned ? progressColor.withOpacity(0.12) : const Color(0xFFEFF4FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                earned ? '✅ Unlocked!' : '🔒 Keep going to unlock',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: earned ? progressColor : const Color(0xFF9AABBF)),
              )),
          ]),
        ),
      ),
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 60, height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: earned ? accentColor.withOpacity(0.18) : Colors.white.withOpacity(0.6),
            border: Border.all(
              color: earned ? accentColor : Colors.grey.shade300,
              width: earned ? 2.5 : 1.5),
            boxShadow: earned
                ? [BoxShadow(color: accentColor.withOpacity(0.35),
                    blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(child: Text(
            earned ? emoji : '🔒',
            style: TextStyle(fontSize: earned ? 28 : 22))),
        ),
        const SizedBox(height: 6),
        Text(name, textAlign: TextAlign.center, maxLines: 2,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
            color: earned ? const Color(0xFF1A2E45) : Colors.grey.shade400)),
        if (earned)
          Text('✓', style: TextStyle(fontSize: 11, color: progressColor, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _SpecialBadgeTile extends StatelessWidget {
  final Map<String, dynamic> badge;
  final bool earned;
  const _SpecialBadgeTile({required this.badge, required this.earned});

  @override
  Widget build(BuildContext context) {
    final tileColor = badge['color'] as Color;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: earned ? tileColor : Colors.grey.shade100),
              child: Center(child: Text(
                earned ? badge['emoji'] as String : '🔒',
                style: const TextStyle(fontSize: 38)))),
            const SizedBox(height: 14),
            Text(badge['name'] as String, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                color: Color(0xFF1A2E45))),
            const SizedBox(height: 6),
            Text(badge['desc'] as String, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF7A9BB5))),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: earned ? tileColor.withOpacity(0.4) : const Color(0xFFEFF4FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                earned ? '✅ Unlocked!' : '🔒 Keep going to unlock',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: earned ? const Color(0xFF1A2E45) : const Color(0xFF9AABBF))),
            ),
          ]),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: earned ? tileColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: earned
              ? [BoxShadow(color: tileColor.withOpacity(0.4),
                  blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(earned ? badge['emoji'] as String : '🔒',
            style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(badge['name'] as String, textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                color: earned ? const Color(0xFF1A2E45) : Colors.grey.shade400))),
          if (earned)
            const Text('✓', style: TextStyle(fontSize: 11, color: Colors.green,
              fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label, sub;
  const _StatPill({required this.label, required this.sub});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.18),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
      const SizedBox(width: 4),
      Text(sub, style: const TextStyle(fontSize: 11, color: Colors.white70)),
    ]),
  );
}
