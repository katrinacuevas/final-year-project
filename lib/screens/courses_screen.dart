import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import 'baiting/baiting_screen.dart';
import 'phishing/phishing_screen.dart';
import 'pretexting/pretexting_screen.dart';
import 'password/password_screen.dart';

const List<Map<String, dynamic>> coursesMeta = [
  {
    'lessonId': 'password_power',
    'emoji': '🔐',
    'title': 'Password Power',
    'subtitle': 'Create passwords so strong, no hacker can crack them!',
    'totalSteps': 6,
    'accentColor': Color(0xFFFFC857),
    'steps': [
      'Why passwords matter', 
      'Spot the weak passwords', 
      'The 4 rules of a strong password', 
      'The passphrase trick', 
      'Build your own password', 
      'Quiz'
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'emoji': '🎣',
    'title': 'Phishing Detective',
    'subtitle': 'Become an expert at spotting fake messages!',
    'totalSteps': 9,
    'accentColor': Color(0xFF4FC3F7),
    'steps': [
      'What is phishing',
      'Who do phishers pretend to be',
      'Spotting fake messages',
      'Red flags to look for',
      'Suspicious links',
      'How to check a link safely',
      'What to do',
      'Chat scenario',
      'Quiz'
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'emoji': '🎁',
    'title': 'Baiting Pro',
    'subtitle': 'Investigate offers that are too good to be true!',
    'totalSteps': 9,
    'accentColor': Color(0xFFFF8A65),
    'steps': [
      'What is baiting',
      'How baiters hook you',
      'Online baiting examples',
      'Real-life baiting examples', 
      'Spot the red flags',
      'Real vs Fake rewards',
      'What to do',
      'Chat scenario',
      'Quiz'
    ],
  },
  {
    'lessonId': 'pretexting',
    'emoji': '🎭',
    'title': 'Pretexting',
    'subtitle': 'Learn how tricksters pretend to be someone else!',
    'totalSteps': 8,
    'accentColor': Color(0xFFBA68C8),
    'steps': [
      'What is pretexting',
      'Why does it work',
      'Who do they pretend to be',
      'Sneaky online tricks',
      'Trust your gut',
      'The PAUSE rule',
      'Chat scenario',
      'Quiz'
    ],
  },
];

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (mounted) setState(() => loading = true);
    await UserService.instance.loadAllProgress();
    if (mounted) setState(() => loading = false);
  }

  Widget screenFor(String lessonId) {
    switch (lessonId) {
      case 'password_power':    return const PasswordPowerScreen();
      case 'phishing_detective': return const PhishingDetectiveScreen();
      case 'baiting_pro':       return const BaitingScreen();
      case 'pretexting':        return const PretextingScreen();
      default:                  return const SizedBox();
    }
  }

  Widget animateIn(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Interval((index * 0.1).clamp(0.0, 0.5), 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: CoursesGridPainter())),
        SafeArea(
          child: loading
              ? Center(child: CircularProgressIndicator(
                  color: const Color(0xFF00D1FF),
                  backgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.1)))
              : RefreshIndicator(
                  onRefresh: refresh,
                  color: const Color(0xFF00D1FF),
                  backgroundColor: const Color(0xFF161B2E),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    itemCount: coursesMeta.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return animateIn(
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                const Icon(Icons.school_rounded, color: Color(0xFF00D1FF), size: 16),
                                const SizedBox(width: 6),
                                Text('LESSONS',
                                  style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 12,
                                    fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                              ]),
                            ]),
                          ),
                          0,
                        );
                      }

                      final courseIndex = index - 1;
                      return animateIn(
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: CourseCard(
                            course: coursesMeta[courseIndex],
                            onStart: (lessonId) async {
                              SoundService.playClick();
                              await Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) => screenFor(lessonId),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                    FadeTransition(opacity: animation, child: child),
                              ));
                              refresh();
                            },
                          ),
                        ),
                        index,
                      );
                    },
                  ),
                ),
        ),
      ]),
    );
  }
}

class CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final Function(String lessonId) onStart;
  const CourseCard({super.key, required this.course, required this.onStart});
  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool expanded = false;
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final String lessonId = widget.course['lessonId'] as String;
    final List<String> steps = List<String>.from(widget.course['steps']);
    final Color accent = widget.course['accentColor'] as Color;
    final progressData = UserService.instance.getProgress(lessonId);
    final int progressCount = progressData?.stepsCompleted ?? 0;
    final int totalSteps = progressData?.totalSteps ?? widget.course['totalSteps'] as int;
    final double progressFraction = totalSteps > 0 ? (progressCount / totalSteps).clamp(0.0, 1.0) : 0.0;
    final bool isCompleted = progressCount >= totalSteps && totalSteps > 0;
    final bool isStarted = progressCount > 0;

    return GestureDetector(
      onTapDown: (details) => setState(() => scale = 0.97),
      onTapUp: (details) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),
      onTap: () { SoundService.playClick(); setState(() => expanded = !expanded); },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Opacity(
          opacity: isCompleted ? 0.75 : 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF161B2E),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isCompleted ? const Color(0xFF00E676).withValues(alpha: 0.4) : accent.withValues(alpha: 0.3),
                width: 1.5),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [accent, const Color(0xFF0D1117)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: accent.withValues(alpha: 0.6), width: 1.5)),
                  child: Center(child: Hero(
                    tag: 'hero_$lessonId',
                    child: Material(color: Colors.transparent,
                      child: Text(widget.course['emoji'] as String, style: const TextStyle(fontSize: 30))),
                  )),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(widget.course['title'] as String,
                      style: GoogleFonts.fredoka(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: isCompleted ? const Color(0xFF00E676).withValues(alpha: 0.15)
                            : isStarted ? accent.withValues(alpha: 0.15)
                            : const Color(0xFF00D1FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCompleted ? const Color(0xFF00E676).withValues(alpha: 0.5)
                              : isStarted ? accent.withValues(alpha: 0.4)
                              : const Color(0xFF00D1FF).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        isCompleted ? '✓ DONE' : isStarted ? 'IN PROGRESS' : 'START',
                        style: GoogleFonts.fredoka(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5,
                          color: isCompleted ? const Color(0xFF00E676) : isStarted ? accent : const Color(0xFF00D1FF))),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(widget.course['subtitle'] as String,
                    style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
                ])),
              ]),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('$progressCount / $totalSteps lessons',
                  style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w600,
                    color: isCompleted ? const Color(0xFF00E676) : accent)),
                Text('${(progressFraction * 100).toInt()}%',
                  style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w600,
                    color: isCompleted ? const Color(0xFF00E676) : accent)),
              ]),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: progressFraction),
                builder: (context, value, child) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: value, minHeight: 7,
                    backgroundColor: accent.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? const Color(0xFF00E676) : accent)),
                ),
              ),
              const SizedBox(height: 16),

              if (!isCompleted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () { SoundService.playClick(); widget.onStart(lessonId); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent, foregroundColor: const Color(0xFF0D1117),
                      elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.rocket_launch_rounded, size: 16),
                      const SizedBox(width: 8),
                      Text(isStarted ? 'Continue →' : 'Start Lesson →',
                        style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),

              if (isCompleted)
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.verified_rounded, color: Color(0xFF00E676), size: 18),
                      const SizedBox(width: 8),
                      Text('Completed!',
                        style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF00E676))),
                    ]),
                  ),
                ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: expanded ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 18),
                  Divider(color: const Color(0xFF00D1FF).withValues(alpha: 0.12), thickness: 1),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  Text('LESSON STEPS',
                    style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  ...steps.asMap().entries.map((entry) {
                    final isDone = (entry.key + 1) <= progressCount;
                    final isCurrent = (entry.key + 1) == progressCount + 1 && !isCompleted;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? const Color(0xFF00E676).withValues(alpha: 0.15)
                                : isCurrent ? accent.withValues(alpha: 0.15)
                                : const Color(0xFF00D1FF).withValues(alpha: 0.05),
                            border: Border.all(
                              color: isDone ? const Color(0xFF00E676).withValues(alpha: 0.6)
                                  : isCurrent ? accent.withValues(alpha: 0.6)
                                  : const Color(0xFF00D1FF).withValues(alpha: 0.15))),
                          child: Center(child: isDone
                              ? const Icon(Icons.check_rounded, size: 13, color: Color(0xFF00E676))
                              : Text('${entry.key + 1}',
                                  style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700,
                                    color: isCurrent ? accent : Colors.white24))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(entry.value,
                          style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w500,
                            color: isDone ? Colors.white : isCurrent ? Colors.white : Colors.white38))),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                            child: Text('NEXT', style: GoogleFonts.fredoka(fontSize: 9, fontWeight: FontWeight.w700, color: accent, letterSpacing: 0.5)),
                          ),
                      ]),
                    );
                  }),
                ]) : const SizedBox(width: double.infinity),
              ),

              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.5), size: 20)),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class CoursesGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}