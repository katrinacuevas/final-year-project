import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Map<String, dynamic>> _courses = const [
    {
      'emoji': '🎁',
      'title': 'Baiting',
      'subtitle': 'Investigate offers that are too good to be true!',
      'completed': 1,
      'total': 8,
      'color': Color(0xFFFF7F7F),
      'bgColor': Color(0xFFFFEBEB),
      'lessons': [
        {'title': 'What is Baiting?', 'done': true},
        {'title': 'Spotting a Trap', 'done': false},
        {'title': 'Free Offers Online', 'done': false},
        {'title': 'USB Drives & Devices', 'done': false},
        {'title': 'Prize Scams', 'done': false},
        {'title': 'Fake Downloads', 'done': false},
        {'title': 'Real vs Fake Rewards', 'done': false},
        {'title': 'Final Challenge', 'done': false},
      ],
    },
    {
      'emoji': '🔍',
      'title': 'Phishing',
      'subtitle': 'Become an expert at spotting fake messages!',
      'completed': 0,
      'total': 6,
      'color': Color(0xFF7EC8E3),
      'bgColor': Color(0xFFE3F4FB),
      'lessons': [
        {'title': 'What is Phishing?', 'done': false},
        {'title': 'Fake Emails', 'done': false},
        {'title': 'Suspicious Links', 'done': false},
        {'title': 'Chat Scams', 'done': false},
        {'title': 'Spotting Red Flags', 'done': false},
        {'title': 'Final Challenge', 'done': false},
      ],
    },
    {
      'emoji': '🎭',
      'title': 'Pretexting',
      'subtitle': 'Learn how tricksters pretend to be someone else!',
      'completed': 0,
      'total': 5,
      'color': Color(0xFFB39DDB),
      'bgColor': Color(0xFFF0EBFF),
      'lessons': [
        {'title': 'What is Pretexting?', 'done': false},
        {'title': 'Fake Identities', 'done': false},
        {'title': 'Impersonation Online', 'done': false},
        {'title': 'Trust Your Instincts', 'done': false},
        {'title': 'Final Challenge', 'done': false},
      ],
    },
    {
      'emoji': '🔒',
      'title': 'Password Power',
      'subtitle': 'Create passwords so strong, no hacker can crack them!',
      'completed': 0,
      'total': 4,
      'color': Color(0xFFFFB347),
      'bgColor': Color(0xFFFFF3E0),
      'lessons': [
        {'title': 'Why Passwords Matter', 'done': false},
        {'title': 'Weak vs Strong', 'done': false},
        {'title': 'The 4 Rules', 'done': false},
        {'title': 'Build Your Password', 'done': false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Courses',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                  const SizedBox(height: 4),
                  const Text('Choose a topic and start learning!',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7A9BB5))),
                  const SizedBox(height: 14),
                  // summary chips
                  Row(children: [
                    _SummaryChip(emoji: '📚', label: '4 Courses', color: const Color(0xFFDEEAF8)),
                    const SizedBox(width: 10),
                    _SummaryChip(emoji: '✅', label: '1 Started', color: const Color(0xFFD5F5E3)),
                    const SizedBox(width: 10),
                    _SummaryChip(emoji: '🔥', label: '5 Day Streak', color: const Color(0xFFFFEDD5)),
                  ]),
                ],
              ),
            ),

            // ── course list ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) => _CourseCard(course: _courses[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── course card (expandable) ────────────────────────────────────────
class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const _CourseCard({required this.course});

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _expandAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _animController.forward() : _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    final int completed = c['completed'] as int;
    final int total = c['total'] as int;
    final double progress = completed / total;
    final Color accentColor = c['color'] as Color;
    final Color bgColor = c['bgColor'] as Color;
    final List lessons = c['lessons'] as List;
    final bool isStarted = completed > 0;
    final bool isDone = completed == total;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          // ── banner image area ──
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: _expanded ? Radius.zero : const Radius.circular(20),
              bottomRight: _expanded ? Radius.zero : const Radius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              height: 110,
              color: bgColor,
              child: Stack(
                children: [
                  // decorative circles
                  Positioned(right: -20, top: -20,
                    child: Container(width: 100, height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.15)))),
                  Positioned(left: -10, bottom: -20,
                    child: Container(width: 70, height: 70,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.10)))),
                  // main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // big emoji
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Center(child: Text(c['emoji'] as String, style: const TextStyle(fontSize: 34))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                Text(c['title'] as String,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                                const SizedBox(width: 8),
                                if (isDone)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Done!', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                                  ),
                              ]),
                              const SizedBox(height: 4),
                              Text('$completed / $total lessons',
                                style: TextStyle(fontSize: 12, color: accentColor, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        // expand chevron
                        GestureDetector(
                          onTap: _toggle,
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
                            child: AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF7A9BB5), size: 20),
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

          // ── progress + subtitle + button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['subtitle'] as String,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7A9BB5), height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progress', style: TextStyle(fontSize: 11, color: Color(0xFF9AABBF), fontWeight: FontWeight.w600)),
                    Text('$completed/$total', style: const TextStyle(fontSize: 11, color: Color(0xFF9AABBF), fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE0EAF4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDone ? const Color(0xFF2ECC71) : accentColor),
                  ),
                ),
              ],
            ),
          ),

          // ── start / continue button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDone ? const Color(0xFF2ECC71) : accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isDone ? '🔄 Review' : isStarted ? '▶  Continue' : '▶  Start Course',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          // ── expandable lessons list ──
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(height: 1, color: Color(0xFFEFF4FB)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(children: [
                    const Text('📋', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    const Text('Lessons', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                  ]),
                ),
                ...lessons.asMap().entries.map((e) {
                  final lesson = e.value as Map<String, dynamic>;
                  final bool done = lesson['done'] as bool;
                  final bool isNext = !done && (e.key == 0 || (lessons[e.key - 1] as Map)['done'] == true);
                  return _LessonRow(
                    number: e.key + 1,
                    title: lesson['title'] as String,
                    done: done,
                    isNext: isNext,
                    accentColor: accentColor,
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── individual lesson row ────────────────────────────────────────────
class _LessonRow extends StatelessWidget {
  final int number;
  final String title;
  final bool done;
  final bool isNext;
  final Color accentColor;

  const _LessonRow({
    required this.number,
    required this.title,
    required this.done,
    required this.isNext,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          // number / check circle
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: done
                ? const Color(0xFF2ECC71)
                : isNext
                  ? accentColor
                  : const Color(0xFFEFF4FB),
              shape: BoxShape.circle,
              border: Border.all(
                color: done
                  ? const Color(0xFF2ECC71)
                  : isNext
                    ? accentColor
                    : const Color(0xFFCDD8E3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: done
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('$number',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isNext ? Colors.white : const Color(0xFF9AABBF),
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                color: done
                  ? const Color(0xFF7A9BB5)
                  : isNext
                    ? const Color(0xFF1A2E45)
                    : const Color(0xFF9AABBF),
                decoration: done ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFF9AABBF),
              )),
          ),
          if (isNext)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Up next', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: accentColor)),
            ),
          if (done)
            const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
        ],
      ),
    );
  }
}

// ── summary chip ─────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final String emoji, label;
  final Color color;
  const _SummaryChip({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
      ]),
    );
  }
}