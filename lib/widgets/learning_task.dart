import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningTaskCard extends StatefulWidget {
  final String emoji;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final int progress;
  final int totalLessons;
  final List<String> stepsList;
  final VoidCallback onTap;

  const LearningTaskCard({
    super.key,
    required this.emoji,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.totalLessons,
    required this.stepsList,
    required this.onTap,
  });

  @override
  State<LearningTaskCard> createState() => _LearningTaskCardState();
}

class _LearningTaskCardState extends State<LearningTaskCard> {
  double _scale = 1.0;

  bool get _isCompleted => widget.progress >= widget.totalLessons && widget.totalLessons > 0;
  bool get _isStarted => widget.progress > 0;
  double get _progressFraction => widget.totalLessons > 0 ? (widget.progress / widget.totalLessons).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: _isCompleted ? null : widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Opacity(
          opacity: _isCompleted ? 0.85 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.iconColor.withValues(alpha: 0.15),
                    ),
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
                                BoxShadow(
                                  color: widget.iconColor.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Hero(
                                tag: 'hero_${widget.title}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(widget.emoji, style: const TextStyle(fontSize: 34)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A2E45),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF4A6580), height: 1.4),
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
                            '${widget.progress} / ${widget.totalLessons} lessons',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.iconColor),
                          ),
                          Text(
                            '${(_progressFraction * 100).toInt()}%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.iconColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0, end: _progressFraction),
                        builder: (context, value, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(alpha: 0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(widget.iconColor),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      if (!_isCompleted)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.iconColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              _isStarted ? 'Continue' : 'Start Lesson',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
      ),
    );
  }
}