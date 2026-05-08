import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import 'baiting/baiting_screen.dart';
import 'phishing/phishing_screen.dart';
import 'pretexting/pretexting_screen.dart';
import 'password/password_screen.dart';

const List<Map<String, dynamic>> _kCoursesMeta = [
  {
    'lessonId': 'password_power',
    'emoji': '🔐',
    'title': 'Password Power',
    'subtitle': 'Create passwords so strong, no hacker can crack them!',
    'totalSteps': 4,
    'iconColor': Color(0xFFFFB347),
    'bgColor': Color(0xFFFFF3E0),
    'steps': [
      'Introduction',
      'Why passwords matter',
      'Weak passwords',
      'Strong passwords',
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'emoji': '🔍',
    'title': 'Phishing Detective',
    'subtitle': 'Become an expert at spotting fake messages!',
    'totalSteps': 6,
    'iconColor': Color(0xFF26A69A),
    'bgColor': Color(0xFFE0F2F1),
    'steps': [
      'Introduction',
      'What is phishing',
      'Email scams',
      'Fake links',
      'Spotting signs',
      'Quiz',
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'emoji': '🎣',
    'title': 'Baiting Pro',
    'subtitle': 'Investigate offers that are too good to be true!',
    'totalSteps': 6,
    'iconColor': Color(0xFFFF7F7F),
    'bgColor': Color(0xFFFFEBEB),
    'steps': [
      'Introduction',
      'Too good to be true',
      'Free downloads',
      'USB traps',
      'Real examples',
      'Quiz',
    ],
  },
  {
    'lessonId': 'pretexting',
    'emoji': '🎭',
    'title': 'Pretexting',
    'subtitle': 'Learn how tricksters pretend to be someone else!',
    'totalSteps': 5,
    'iconColor': Color(0xFFB39DDB),
    'bgColor': Color(0xFFF0EBFF),
    'steps': [
      'Introduction',
      'What is pretexting',
      'Common tricks',
      'Real scenarios',
      'Quiz',
    ],
  },
];

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (mounted) setState(() => _loading = true);
    await UserService.instance.loadAllProgress();
    if (mounted) setState(() => _loading = false);
  }

  Widget _screenFor(String lessonId) {
    switch (lessonId) {
      case 'password_power':
        return const PasswordPowerScreen();
      case 'phishing_detective':
        return const PhishingDetectiveScreen();
      case 'baiting_pro':
        return const BaitingScreen();
      case 'pretexting':
        return const PretextingScreen();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 237, 255),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _kCoursesMeta.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CourseCard(
                        course: _kCoursesMeta[index],
                        onStart: (lessonId) async {
                          SoundService.playClick();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _screenFor(lessonId),
                            ),
                          );
                          _refresh();
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final Function(String lessonId) onStart;

  const _CourseCard({
    required this.course,
    required this.onStart,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final lessonId = widget.course['lessonId'] as String;
    final steps = List<String>.from(widget.course['steps']);
    final Color accentColor = widget.course['iconColor'];
    final Color bgColor = widget.course['bgColor'];

    final progressData = UserService.instance.getProgress(lessonId);
    final int progressCount = progressData?.stepsCompleted ?? 0;
    final int totalSteps = progressData?.totalSteps ?? widget.course['totalSteps'];
    final double progressFraction = totalSteps > 0 ? (progressCount / totalSteps).clamp(0.0, 1.0) : 0.0;
    final bool isCompleted = progressCount >= totalSteps && totalSteps > 0;
    final bool isStarted = progressCount > 0;

    return GestureDetector(
      onTap: () {
        SoundService.playClick();
        setState(() => _expanded = !_expanded);
      },
      child: Opacity(
        opacity: isCompleted ? 0.85 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
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
                    color: accentColor.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                left: -10,
                bottom: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(0.10),
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
                                color: accentColor.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.course['emoji'],
                              style: const TextStyle(fontSize: 34),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.course['title'],
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1A2E45),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.course['subtitle'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4A6580),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$progressCount / $totalSteps lessons',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          '${(progressFraction * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressFraction,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (!isCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => widget.onStart(lessonId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isStarted ? 'Continue' : 'Start Lesson',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    if (isCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          ...steps.asMap().entries.map((entry) {
                            final isDone = (entry.key + 1) <= progressCount;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                                    size: 18,
                                    color: isDone ? accentColor : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDone ? const Color(0xFF1A2E45) : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
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