// ========================================================================
// achievements_screen.dart 
// ------------------------------------------------------------------------
// main achievements screen with two tabs: 
//  1. my progress - overall progress ring, filter chips and a scrollable 
//    list of AchievementCardds 
//  2. leaderboard - top 10 users ranked by XP, fetched from Firestore, 
//     with a podium preview for the top 3 
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/services/user_service.dart';
import '../../services/sound_service.dart';
import 'achievements_data.dart';
import 'achievement_card.dart';
import 'leaderboard_row.dart';

class AchievementsScreen extends StatefulWidget {
  final Function(String)? onCatMessage; // callback to update the cat mascot message 
  const AchievementsScreen({super.key, this.onCatMessage});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All'; // active filter chip on the progress tab
  bool loading = true; // true while progress data is loading
  bool leaderboardLoading = true; // true while leaderboard is loading 
  bool _leaderboardGreetingShown = false; // ensures the cat greeting fires only once 
  List<LeaderboardEntry> leaderboardEntries = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // listen for tab changes to trigger the leaderboard greeting and data load 
    _tabController.addListener(() {
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        // show the cat mascot greeting the first time the leaderboard tab is opened
        if (!_leaderboardGreetingShown) {
          _leaderboardGreetingShown = true;
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              widget.onCatMessage?.call(
                '🌍 Welcome to the leaderboard!\nSee how you rank against other cyber detectives — keep earning XP to climb higher! 🏆',
              );
            }
          });
        }
        // load leaderboard data only if it hasnt been fetched yet 
        if (leaderboardEntries.isEmpty) _loadLeaderboard();
      }
    });
    // load progress data on screen open 
    load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ----- load progress -----
   // refreshes all lesson progress and user profile from UserService 
  Future<void> load() async {
    setState(() => loading = true);
    await UserService.instance.loadAllProgress();
    await UserService.instance.refreshProfile();
    if (mounted) setState(() => loading = false);
  }

  // ----- load leaderboard -----
  // fetch the top 10 users from Firestore ordered by XP descending 
  Future<void> _loadLeaderboard() async {
    setState(() => leaderboardLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('xp', descending: true)
          .limit(10)
          .get();

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          username: (data['username'] as String?) ?? 'Agent',
          avatarEmoji: (data['avatarEmoji'] as String?) ?? '🧒',
          avatarColour: (data['avatarColour'] as String?) ?? '0xFF00D1FF',
          xp: (data['xp'] as int?) ?? 0,
          level: (data['level'] as int?) ?? 0,
        );
      }).toList();

      if (mounted) {
        setState(() {
          leaderboardEntries = entries;
          leaderboardLoading = false;
        });
      }
    } catch (_) {
      // on error silently stop loading, list stays empty 
      if (mounted) setState(() => leaderboardLoading = false);
    }
  }

  // clear entries and re-fetch to support pull-to-refresh
  Future<void> _refreshLeaderboard() async {
    leaderboardEntries = [];
    await _loadLeaderboard();
  }

  // ----- progress stats -----
  // total possible steps across all courses 
  int get totalSteps =>
      achievementCourses.fold(0, (s, c) => s + (c['totalSteps'] as int));

  // steps the user has completed across all courses 
  int get completedSteps {
    int t = 0;
    for (final c in achievementCourses) {
      t += UserService.instance.getProgress(c['lessonId'] as String)?.stepsCompleted ?? 0;
    }
    return t;
  }

  // number of fully completed courses 
  int get completedCourses => achievementCourses
      .where((c) =>
          UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false)
      .length;

  // overall fraction of steps ciompleted
  double get overallProgress =>
      totalSteps == 0 ? 0 : (completedSteps / totalSteps).clamp(0.0, 1.0);

  // ----- filtered course list -----
  // return a subset of courses based on the selected filter chip
  List<Map<String, dynamic>> get filtered {
    switch (selectedFilter) {
      case 'Completed':
        return achievementCourses
            .where((c) =>
                UserService.instance.getProgress(c['lessonId'] as String)?.completed ?? false)
            .toList();
      case 'In Progress':
        return achievementCourses.where((c) {
          final p = UserService.instance.getProgress(c['lessonId'] as String);
          return p != null && !p.completed && p.stepsCompleted > 0;
        }).toList();
      case 'Not Started':
        return achievementCourses.where((c) {
          final p = UserService.instance.getProgress(c['lessonId'] as String);
          return p == null || p.stepsCompleted == 0;
        }).toList();
      default:
        // all - no filter applied 
        return achievementCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          // cyan grid background
          Positioned.fill(child: CustomPaint(painter: AchievementsGridPainter())),
          SafeArea(
            child: Column(
              children: [
                // ----- screen header -----
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events_rounded,
                          color: Color(0xFF00D1FF), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'ACHIEVEMENTS',
                        style: GoogleFonts.fredoka(
                          color: const Color(0xFF00D1FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ----- tab bar -----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTabBar(),
                ),
                const SizedBox(height: 16),
                // ----- tab views -----
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAchievementsTab(),
                      _buildLeaderboardTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----- tab bar -----
  // custom styled tab bar with a solid cyan indicator 
  Widget _buildTabBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => SoundService.playClick(),
        indicator: BoxDecoration(
          color: const Color(0xFF00D1FF),
          borderRadius: BorderRadius.circular(11),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF0D1117),
        unselectedLabelColor: Colors.white38,
        labelStyle: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: '🏆  My Progress'),
          Tab(text: '🌍  Leaderboard'),
        ],
      ),
    );
  }

  // ----- achievements tab -----
  // show the stats card, filter chips and a list of AchievementCards 
  Widget _buildAchievementsTab() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF00D1FF),
          backgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.1),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: load,
      color: const Color(0xFF00D1FF),
      backgroundColor: const Color(0xFF161B2E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildFilterTabs(),
            const SizedBox(height: 16),

            // staggered fade + slide-up animation for each card 
            ...filtered.asMap().entries.map((entry) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 400 + (entry.key * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: AchievementCard(course: entry.value),
                ),
              );
            }),
            // ----- empty state -----
            // shown when the active filter returns no courses 
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        selectedFilter == 'Completed'
                            ? '🎯'
                            : selectedFilter == 'In Progress'
                                ? '🚀'
                                : '🎉',
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        selectedFilter == 'Completed'
                            ? 'No courses completed yet\nKeep going, agent! 💪'
                            : selectedFilter == 'In Progress'
                                ? 'No courses in progress yet!\nStart a lesson to begin.'
                                : 'All courses started! 🎉',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          color: Colors.white38,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ----- leaderboard tab -----
  // fetches on first open, highlights the current users own row 
  Widget _buildLeaderboardTab() {
    if (leaderboardLoading && leaderboardEntries.isEmpty) {
      _loadLeaderboard();
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF00D1FF),
          backgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.1),
        ),
      );
    }

    final myUsername = UserService.instance.profile?.username ?? '';

    return RefreshIndicator(
      onRefresh: _refreshLeaderboard,
      color: const Color(0xFF00D1FF),
      backgroundColor: const Color(0xFF161B2E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          children: [
            _buildLeaderboardHeader(),
            const SizedBox(height: 16),
            // ----- empty state -----
            if (leaderboardEntries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      const Text('🌍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'No agents yet!\nBe the first to earn XP 🚀',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          color: Colors.white38,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // staggered fade + slide-up for each leaderboard row 
              ...leaderboardEntries.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final e = entry.value;
                final isMe = e.username == myUsername; // highlight the current user 
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (entry.key * 60)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LeaderboardRow(rank: rank, entry: e, isMe: isMe),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ----- leaderboard header -----
  // show a podium preview of the top 3 users
  Widget _buildLeaderboardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            '🌍  GLOBAL LEADERBOARD',
            style: GoogleFonts.fredoka(
              color: const Color(0xFF00D1FF),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Top agents ranked by XP earned',
            style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // podium arranged as 2nd, 1st, 3rd (centre = tallest)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _podiumPreview(leaderboardEntries, 1), // 2nd place (left)
              const SizedBox(width: 8),
              _podiumPreview(leaderboardEntries, 0), // 1st place (middle)
              const SizedBox(width: 8),
              _podiumPreview(leaderboardEntries, 2), // 3rd place (right)
            ],
          ),
        ],
      ),
    );
  }

  // ----- podium preview -----
  // single podium columnn with avatar, medal, username and XP bar 
  Widget _podiumPreview(List<LeaderboardEntry> entries, int index) {
    if (entries.length <= index) return const SizedBox(width: 80);

    final e = entries[index];
    final isFirst = index == 0;
    final medals = ['🥇', '🥈', '🥉'];
    final medalIndex = index == 0 ? 0 : index == 1 ? 1 : 2;
    final heights = [80.0, 64.0, 52.0]; // podium bar heights 
    final avatarColour = Color(int.parse(e.avatarColour));

    return Column(
      children: [
        // crown above 1st place 
        if (isFirst) Text('👑', style: TextStyle(fontSize: isFirst ? 20 : 16)),
        if (isFirst) const SizedBox(height: 4),
        Container(
          width: isFirst ? 64 : 52,
          height: isFirst ? 64 : 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarColour.withValues(alpha: 0.15),
            border: Border.all(
              color: avatarColour.withValues(alpha: 0.6),
              width: isFirst ? 2.5 : 2,
            ),
          ),
          child: Center(
            child: Text(
              e.avatarEmoji,
              style: TextStyle(fontSize: isFirst ? 28 : 22),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(medals[medalIndex], style: TextStyle(fontSize: isFirst ? 20 : 16)),
        const SizedBox(height: 2),
        SizedBox(
          width: 72,
          child: Text(
            e.username,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(
              fontSize: isFirst ? 12 : 11,
              fontWeight: FontWeight.w700,
              color: isFirst ? Colors.white : Colors.white70,
            ),
          ),
        ),
        // podium bar, height varies by rank position
        Container(
          margin: const EdgeInsets.only(top: 3),
          height: heights[medalIndex],
          width: isFirst ? 64 : 52,
          decoration: BoxDecoration(
            color: isFirst
                ? const Color(0xFFFFC857).withValues(alpha: 0.15)
                : index == 1
                    ? Colors.white.withValues(alpha: 0.07)
                    : const Color(0xFFFF8A65).withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(
              color: isFirst
                  ? const Color(0xFFFFC857).withValues(alpha: 0.4)
                  : index == 1
                      ? Colors.white.withValues(alpha: 0.15)
                      : const Color(0xFFFF8A65).withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              '${e.xp} XP',
              style: GoogleFonts.fredoka(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isFirst
                    ? const Color(0xFFFFC857)
                    : index == 1
                        ? Colors.white54
                        : const Color(0xFFFF8A65),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ----- stats card -----
  // circular progress ring with overall completion percentage 
  // two statpills showing course and step counts 
  Widget _buildStatsCard() {
    final pct = (overallProgress * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            'OVERALL PROGRESS',
            style: GoogleFonts.fredoka(
              color: const Color(0xFF00D1FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // animated ring that fills form 0 to the current progress
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: overallProgress),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, child) => SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: v,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      backgroundColor:
                          const Color(0xFF00D1FF).withValues(alpha: 0.1),
                      // turns green when all courses are completed 
                      valueColor: AlwaysStoppedAnimation<Color>(
                        overallProgress >= 1.0
                            ? const Color(0xFF00E676)
                            : const Color(0xFF00D1FF),
                      ),
                    ),
                  ),
                ),
                // percentage label in the centre of the ring 
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$pct%',
                      style: GoogleFonts.fredoka(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Complete',
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        color: Colors.white38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // courses completed and steps completed pills side by side 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatPill(
                label: '$completedCourses / ${achievementCourses.length}',
                sub: 'courses',
              ),
              const SizedBox(width: 10),
              StatPill(
                label: '$completedSteps / $totalSteps',
                sub: 'steps',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----- filter chips -----
  // horizontal scrollable row of filter options 
  // tapping a chip updates selectedFilter and rebuilds the card list 
  Widget _buildFilterTabs() {
    final filters = ['All', 'Completed', 'In Progress', 'Not Started'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                SoundService.playClick();
                setState(() => selectedFilter = f);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  // selected chip is filled cyan, others are outlined
                  color: isSelected
                      ? const Color(0xFF00D1FF)
                      : const Color(0xFF161B2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00D1FF)
                        : const Color(0xFF00D1FF).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  f,
                  style: GoogleFonts.fredoka(
                    color: isSelected ? const Color(0xFF0D1117) : Colors.white54,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AchievementsGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
