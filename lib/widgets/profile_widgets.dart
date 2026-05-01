import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String value, label, emoji;
  const StatItem({super.key, required this.value, required this.label, required this.emoji});

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

class VertDivider extends StatelessWidget {
  const VertDivider({super.key});
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: const Color(0xFFD0DFF0));
}

class Carousel extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final Widget Function(int) itemBuilder;

  const Carousel({super.key, required this.itemCount, required this.currentPage, required this.onPageChanged, required this.itemBuilder});

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
            itemBuilder: (_, i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: itemBuilder(i)),
          ),
        ),
        const SizedBox(height: 10),
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

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  const TaskCard({super.key, required this.task});

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
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(task['emoji'] as String, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(task['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 3),
                Text(task['subtitle'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF7A9BB5))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFFFFDE7), borderRadius: BorderRadius.circular(10)),
            child: Text('+${task['xp']} XP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFE6A817))),
          ),
        ],
      ),
    );
  }
}

class BadgeCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  const BadgeCard({super.key, required this.badge});

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
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.05)])),
              ),
              SizedBox(width: 60, height: 60, child: Center(child: Text(badge['emoji'] as String, style: const TextStyle(fontSize: 32)))),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(badge['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 4),
                const Row(children: [
                  Text('⭐⭐⭐', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 6),
                  Text('Unlocked!', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF27AE60))),
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

class RuleAccordion extends StatelessWidget {
  final String icon, title, detail;
  final bool expanded;
  final VoidCallback onTap;

  const RuleAccordion({super.key, required this.icon, required this.title, required this.detail, required this.expanded, required this.onTap});

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
                Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45)))),
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
                child: Text(detail, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95), height: 1.5)),
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