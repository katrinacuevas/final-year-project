// ========================================================================
// learning_task.dart
// ------------------------------------------------------------------------
// course card displayed on the courses screen
// shows the lesson emoji, title, progress bar and a start/continue button
// card is dimmed and non-tappable once the lesson is fully completed
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningTaskCard extends StatefulWidget {
  final String emoji;
  final Color accentColor;
  final String title;
  final String subtitle;
  final int progress;
  final int totalLessons;
  final VoidCallback onTap;

  const LearningTaskCard({
    super.key,
    required this.emoji,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.totalLessons,
    required this.onTap,
  });

  @override
  State<LearningTaskCard> createState() => _LearningTaskCardState();
}

class _LearningTaskCardState extends State<LearningTaskCard> {
  // tracks the pressed state for the scale-down tap feedback
  double scale = 1.0;

  // ----- computed state helpers -----
  bool get isCompleted =>
      widget.progress >= widget.totalLessons && widget.totalLessons > 0;
  bool get isStarted => widget.progress > 0;
  double get progressFraction => widget.totalLessons > 0
      ? (widget.progress / widget.totalLessons).clamp(0.0, 1.0)
      : 0.0;

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accentColor;

    return GestureDetector(
      // scale the card down slightly on press for a tactile feeling
      onTapDown: (details) => setState(() => scale = 0.97),
      onTapUp: (details) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      // completed lessons are not tappable — no point reopening them
      onTap: isCompleted ? null : widget.onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Opacity(
          // dim completed cards so they feel "done" rather than interactive
          opacity: isCompleted ? 0.7 : 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF161B2E),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                // completed cards get a green border, others use the lesson's accent colour
                color: isCompleted
                    ? const Color(0xFF00E676).withValues(alpha: 0.4)
                    : accent.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ----- lesson icon -----
                    // uses a gradient from the accent colour to dark so each lesson
                    // has a distinct identity without needing separate images
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
                        // hero tag lets the emoji animate across to the lesson screen on open
                        child: Hero(
                          tag: 'hero_${widget.title}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // ----- title and status badge -----
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // status pill: DONE / IN PROGRESS / START
                              // colour changes to match the current state
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? const Color(0xFF00E676).withValues(alpha: 0.15)
                                      : isStarted
                                          ? accent.withValues(alpha: 0.15)
                                          : const Color(0xFF00D1FF).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isCompleted
                                        ? const Color(0xFF00E676).withValues(alpha: 0.5)
                                        : isStarted
                                            ? accent.withValues(alpha: 0.4)
                                            : const Color(0xFF00D1FF).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  isCompleted
                                      ? '✓ DONE'
                                      : isStarted
                                          ? 'IN PROGRESS'
                                          : 'START',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: isCompleted
                                        ? const Color(0xFF00E676)
                                        : isStarted
                                            ? accent
                                            : const Color(0xFF00D1FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
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

                // ----- progress counter -----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.progress} / ${widget.totalLessons} lessons',
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
                // animates from 0 each time the widget builds so filling up feels rewarding
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: progressFraction),
                  builder: (context, value, child) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 7,
                      backgroundColor: accent.withValues(alpha: 0.12),
                      // goes green when complete, otherwise stays as the lesson's accent colour
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? const Color(0xFF00E676) : accent,
                      ),
                    ),
                  ),
                ),

                // ----- start/continue button -----
                // only shown for incomplete lessons — completed ones don't need it
                if (!isCompleted) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D1FF),
                        foregroundColor: const Color(0xFF0D1117),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.rocket_launch_rounded, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            isStarted ? 'Continue →' : 'Start Lesson →',
                            style: GoogleFonts.fredoka(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
