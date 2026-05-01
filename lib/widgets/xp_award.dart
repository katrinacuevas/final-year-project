import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';

class XpAward {
  static Future<void> show(
    BuildContext context, {
    required String lessonId,
    required int amount,
  }) async {
    final result = await UserService.instance.addXp(lessonId, amount);

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _XpSheet(
        amount: amount,
        alreadyAwarded: result == null,
        levelledUp: result?.levelledUp ?? false,
        newLevel: result?.newLevel ?? UserService.instance.level,
        newXp: result?.newXp ?? UserService.instance.xp,
        xpCeiling: UserService.instance.xpNeededForNextLevel,
        xpProgress: UserService.instance.xpProgress,
      ),
    );
  }
}

class _XpSheet extends StatefulWidget {
  final int amount;
  final bool alreadyAwarded;
  final bool levelledUp;
  final int newLevel;
  final int newXp;
  final int xpCeiling;
  final double xpProgress;

  const _XpSheet({
    required this.amount,
    required this.alreadyAwarded,
    required this.levelledUp,
    required this.newLevel,
    required this.newXp,
    required this.xpCeiling,
    required this.xpProgress,
  });

  @override
  State<_XpSheet> createState() => _XpSheetState();
}

class _XpSheetState extends State<_XpSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = Tween<double>(begin: 0, end: widget.xpProgress)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // level-up banner OR XP earned
          if (widget.levelledUp) ...[
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 10),
            Text(
              'Level Up! You\'re now Level ${widget.newLevel}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2E45),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Keep going — you\'re on a roll! 🚀',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ] else if (widget.alreadyAwarded) ...[
            const Text('✅', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 10),
            const Text('XP already earned for this lesson',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
            const SizedBox(height: 4),
            Text('You can replay lessons for practice — but XP is only awarded once.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ] else ...[
            const Text('⭐', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 10),
            Text(
              '+${widget.amount} XP Earned!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFFE6A817),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // XP bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level ${widget.newLevel}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A90D9)),
              ),
              Text(
                '${widget.newXp} / ${widget.xpCeiling} XP',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _barAnim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _barAnim.value,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.levelledUp
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFF4A90D9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // dismiss button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2E45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Back to Dashboard',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}