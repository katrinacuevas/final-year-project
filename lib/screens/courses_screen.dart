import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/services/user_service.dart';
import 'baiting/baiting_screen.dart';
import 'phishing/phishing_screen.dart';
import 'pretexting/pretexting_screen.dart';
import 'password/password_screen.dart';
import '../widgets/learning_task.dart';

const List<Map<String, dynamic>> _kCoursesMeta = [
  {
    'lessonId': 'password_power',
    'emoji': '🔒',
    'title': 'Password Power',
    'subtitle': 'Create passwords so strong, no hacker can crack them!',
    'totalSteps': 4,
    'iconColor': Color(0xFFFFB347),
    'bgColor': Color(0xFFFFF3E0),
  },
  {
    'lessonId': 'phishing_detective',
    'emoji': '🎣',
    'title': 'Phishing Detective',
    'subtitle': 'Become an expert at spotting fake messages!',
    'totalSteps': 6,
    'iconColor': Color(0xFF26A69A),
    'bgColor': Color(0xFFE0F2F1),
  },
  {
    'lessonId': 'baiting_pro',
    'emoji': '🎁',
    'title': 'Baiting Pro',
    'subtitle': 'Investigate offers that are too good to be true!',
    'totalSteps': 6,
    'iconColor': Color(0xFFFF7F7F),
    'bgColor': Color(0xFFFFEBEB),
  },
  {
    'lessonId': 'pretexting',
    'emoji': '🎭',
    'title': 'Pretexting',
    'subtitle': 'Learn how tricksters pretend to be someone else!',
    'totalSteps': 5,
    'iconColor': Color(0xFFB39DDB),
    'bgColor': Color(0xFFF0EBFF),
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
    setState(() => _loading = true);
    await UserService.instance.loadAllProgress();
    await UserService.instance.refreshProfile();
    if (mounted) setState(() => _loading = false);
  }

  Widget _screenFor(String lessonId) {
    switch (lessonId) {
      case 'password_power':      return const PasswordPowerScreen();
      case 'phishing_detective':  return const PhishingDetectiveScreen();
      case 'baiting_pro':         return const BaitingScreen();
      case 'pretexting':          return const PretextingScreen();
      default:                    return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Courses',
                        style: GoogleFonts.quicksand(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A2E45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pick a topic and start learning!',
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: const Color(0xFF7A9BB5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(),
                      const SizedBox(height: 20),
                      ..._kCoursesMeta.map((course) {
                        final lessonId = course['lessonId'] as String;
                        final p = UserService.instance.getProgress(lessonId);
                        final steps = p?.stepsCompleted ?? 0;
                        final total = course['totalSteps'] as int;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: LearningTaskCard(
                            emoji: course['emoji'] as String,
                            iconColor: course['iconColor'] as Color,
                            bgColor: course['bgColor'] as Color,
                            title: course['title'] as String,
                            subtitle: course['subtitle'] as String,
                            progress: steps,
                            totalLessons: total,
                            onTap: () async {
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
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    int completedCount = 0;
    int totalStepsAll = 0;
    int completedStepsAll = 0;

    for (final c in _kCoursesMeta) {
      final p = UserService.instance.getProgress(c['lessonId'] as String);
      final total = c['totalSteps'] as int;
      totalStepsAll += total;
      completedStepsAll += p?.stepsCompleted ?? 0;
      if (p?.completed ?? false) completedCount++;
    }

    return Row(children: [
      _SummaryChip(
        emoji: '📚',
        label: '${_kCoursesMeta.length} Courses',
        color: const Color(0xFFDEEAF8),
      ),
      const SizedBox(width: 8),
      _SummaryChip(
        emoji: '✅',
        label: '$completedCount Completed',
        color: const Color(0xFFD5F5E3),
      ),
      const SizedBox(width: 8),
      _SummaryChip(
        emoji: '⚡',
        label: '$completedStepsAll/$totalStepsAll Steps',
        color: const Color(0xFFFFFDE7),
      ),
    ]);
  }
}

class _SummaryChip extends StatelessWidget {
  final String emoji, label;
  final Color color;
  const _SummaryChip({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 13)),
      const SizedBox(width: 5),
      Text(label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
          color: Color(0xFF1A2E45))),
    ]),
  );
}