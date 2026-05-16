// ========================================================================
// achievement_card.dart 
// ------------------------------------------------------------------------
// displays a single course card on the achievements tab 
// shows the course emoji, title, subtitle, step progress bar, badge count, 
// and an expendable badge row 
// - milestoneBage - individual badge title with a tap-to-preview dialog 
//                   showing earned/locked state 
// - statpill - small pill widget used on the stats card to show course 
//              and step counts 
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../services/sound_service.dart';

class AchievementCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const AchievementCard({super.key, required this.course});

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  bool expanded = false; // controls whether the badge row is visible 
  bool isPressed = false; // the subtle press scale animation 

  @override
  Widget build(BuildContext context) {
    final String lessonId = widget.course['lessonId'] as String;
    final Color accent = widget.course['accentColor'] as Color;
    final List milestones = widget.course['milestones'] as List;

    // fetch live progress from UserService 
    final p = UserService.instance.getProgress(lessonId);
    final int steps = p?.stepsCompleted ?? 0;
    final int totalSteps = widget.course['totalSteps'] as int;
    
    final double progressFraction =
        totalSteps > 0 ? (steps / totalSteps).clamp(0.0, 1.0) : 0.0;
    final bool isCompleted = steps >= totalSteps && totalSteps > 0;

    // count how many milestone steps the user has already passed 
    final int badgesEarned =
        milestones.where((m) => steps >= (m['step'] as int)).length;

    return GestureDetector(
      // track press state for the scale animation 
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        SoundService.playClick();
        setState(() => expanded = !expanded); // toggle badge row 
      },
      child: AnimatedScale(
        scale: isPressed ? 0.98 : 1.0, // subtle press feedback 
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF161B2E),
            borderRadius: BorderRadius.circular(28),
            // completed courses get a green border, others use the accent colour 
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
              // ----- card header -----
              // course icon, title, subtitle and badge count pill
              Row(
                children: [
                  // course emoji in a gradient rounded 
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
                            // badge count pill (e.g. 2 / 3)
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
              // ----- progress row -----
              // step count on the left, percentage on the right 
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
              // ----- progress bar -----
              // animates from 0 to the current fraction on first build
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
                    // completed courses use green, others use the accent colour 
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF00E676) : accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // ----- expand toggle -----
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
              // ----- badge row -----
              // fades in / out with AnimatedCrossFade when expanded toggles 
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
                    // one MilestoneBadge per milestone, earned state based on steps 
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

// ----- milestone badge -----
// tappable badge title that opens a full detail dialog 
// shows a lock emoji when the badge has not yet been earned 
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
      onTap: () {
        SoundService.playClick();
        // open a dialog with a larger preview of the badge 
        showDialog(
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
                  // badge icon springs in with an elastic scale aniamtion 
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
                          // earned = accent gradient, locked = grey gradient
                          colors: earned
                              ? [accent, const Color(0xFF0D1117)]
                              : [Colors.white12, const Color(0xFF0D1117)],
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
                  // unlocked / locked status pill at the bottom of the dialog 
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
        );
      },
      // ----- badge title -----
      // glows with the accent colour when earned, muted when locked 
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
                    : [
                        Colors.white.withValues(alpha: 0.04),
                        const Color(0xFF0D1117),
                      ],
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

// ----- stat pill -----
// small rounded pill used on the stats card to display 
// bold value and a dimmer label side by side e.g 4 / 6 courses 
class StatPill extends StatelessWidget {
  final String label, sub;

  const StatPill({super.key, required this.label, required this.sub});

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
