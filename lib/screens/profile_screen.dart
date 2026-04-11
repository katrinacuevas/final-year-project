import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _taskPage = 0;
  int _badgePage = 0;

  final List<bool> _ruleExpanded = [false, false, false, false, false];

  final List<Map<String, dynamic>> _completedTasks = [
    {'emoji': '🔒', 'title': 'Password Power', 'subtitle': 'Completed all 4 lessons', 'color': Color(0xFFFFB347), 'xp': 100},
    {'emoji': '🎁', 'title': 'Baiting Intro', 'subtitle': 'Completed lesson 1 of 8', 'color': Color(0xFFFF7F7F), 'xp': 50},
    {'emoji': '📧', 'title': 'Daily Challenge', 'subtitle': 'Spot the phishing email', 'color': Color(0xFF7EC8E3), 'xp': 50},
  ];

  final List<Map<String, dynamic>> _badges = [
    {'emoji': '🔒', 'title': 'Password Master', 'color': Color(0xFFFFB347)},
    {'emoji': '🔥', 'title': '5 Day Streak', 'color': Color(0xFFFF7F7F)},
    {'emoji': '🛡️', 'title': 'Privacy Pro', 'color': Color(0xFF7EC8E3)},
    {'emoji': '⚡', 'title': 'Quick Learner', 'color': Color(0xFFB39DDB)},
  ];

  final List<Map<String, dynamic>> _safetyRules = [
    {
      'title': 'Never share your password',
      'icon': '🔒',
      'detail': 'Your password is private — not even your best friend should know it. If anyone online asks for it, say NO and tell a trusted adult.',
    },
    {
      'title': 'Don\'t talk to strangers online',
      'icon': '🚫',
      'detail': 'People online might not be who they say they are. Only chat with people you know in real life, and always tell an adult if someone makes you feel uncomfortable.',
    },
    {
      'title': 'If it sounds too good, it\'s probably fake',
      'icon': '🎁',
      'detail': 'Free prizes, free skins, and "secret glitches" are usually tricks to steal your info. Real rewards come from official sources only.',
    },
    {
      'title': 'Never click unknown links',
      'icon': '🔗',
      'detail': 'A dodgy link can install harmful software the moment you click it. Always ask a trusted adult before clicking anything you\'re unsure about.',
    },
    {
      'title': 'Tell a trusted adult if something feels wrong',
      'icon': '🤝',
      'detail': 'If anyone online makes you feel scared, uncomfortable, or confused — stop the conversation and tell a parent, carer, or teacher straight away.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF4FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.settings, color: Color(0xFF7A9BB5), size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Stack(
                      children: [
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4B5),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF4A90D9), width: 3),
                          ),
                          child: const Center(child: Text('🧒', style: TextStyle(fontSize: 54))),
                        ),
                        Positioned(
                          bottom: 2, right: 2,
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90D9),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('User18',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('⭐ Level 2',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('XP Progress',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7A9BB5))),
                            const Text('250 / 500 XP',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7A9BB5))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: 0.5,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFE0EAF4),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90D9)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text('250 XP to go until Level 3!',
                            style: TextStyle(fontSize: 11, color: Color(0xFF9AABBF))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _StatItem(value: '250', label: 'XP Earned', emoji: '⚡'),
                          _VertDivider(),
                          _StatItem(value: '6', label: 'Lessons', emoji: '📖'),
                          _VertDivider(),
                          _StatItem(value: '4', label: 'Badges', emoji: '🏅'),
                          _VertDivider(),
                          _StatItem(value: '5', label: 'Day Streak', emoji: '🔥'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tasks completed:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                    const SizedBox(height: 10),
                    _Carousel(
                      itemCount: _completedTasks.length,
                      currentPage: _taskPage,
                      onPageChanged: (p) => setState(() => _taskPage = p),
                      itemBuilder: (i) {
                        final t = _completedTasks[i];
                        return _TaskCard(task: t);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Badges earned:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                    const SizedBox(height: 10),
                    _Carousel(
                      itemCount: _badges.length,
                      currentPage: _badgePage,
                      onPageChanged: (p) => setState(() => _badgePage = p),
                      itemBuilder: (i) {
                        final b = _badges[i];
                        return _BadgeCard(badge: b);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('My safety rules',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        children: _safetyRules.asMap().entries.map((e) {
                          final i = e.key;
                          final rule = e.value;
                          final isLast = i == _safetyRules.length - 1;
                          return Column(
                            children: [
                              _RuleAccordion(
                                icon: rule['icon'] as String,
                                title: rule['title'] as String,
                                detail: rule['detail'] as String,
                                expanded: _ruleExpanded[i],
                                onTap: () => setState(() => _ruleExpanded[i] = !_ruleExpanded[i]),
                              ),
                              if (!isLast)
                                const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEFF4FB)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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

class _Carousel extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final Widget Function(int) itemBuilder;

  const _Carousel({
    required this.itemCount,
    required this.currentPage,
    required this.onPageChanged,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: controller,
            itemCount: itemCount,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: itemBuilder(i),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == currentPage ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == currentPage ? const Color(0xFF4A90D9) : const Color(0xFFCDD8E3),
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final Color color = task['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(task['emoji'] as String, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(task['title'] as String,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 3),
                Text(task['subtitle'] as String,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7A9BB5))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('+${task['xp']} XP',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFE6A817))),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    final Color color = badge['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [color.withOpacity(0.3), color.withOpacity(0.05)],
                  ),
                ),
              ),
              SizedBox(
                width: 60, height: 60,
                child: Center(child: Text(badge['emoji'] as String, style: const TextStyle(fontSize: 32))),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(badge['title'] as String,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 4),
                Row(children: [
                  const Text('⭐⭐⭐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  const Text('Unlocked!',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF27AE60))),
                ]),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Color(0xFFFFD700), size: 26),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9AABBF), size: 22),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10, left: 30),
                child: Text(detail,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95), height: 1.5)),
              ),
              crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label, emoji;
  const _StatItem({required this.value, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9AABBF), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Container(width: 1, height: 36, color: const Color(0xFFD0DFF0));
}