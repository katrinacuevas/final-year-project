import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../screens/dashboard_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/profile_screen.dart';
import '../services/sound_service.dart';
import 'cat_messages.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late PageController pageController;

  bool _bubbleVisible = false;
  bool _hasAutoShown = false;
  Timer? _bubbleTimer;
  final Set<int> _visitedTabs = {};
  bool _shownAfterFirstTap = false;
  late AnimationController _lottieCtrl;

  static const List<Color> _tabAccents = [
    Color(0xFF00D1FF),
    Color(0xFF00D1FF),
    Color(0xFFFFD700),
    Color(0xFFBA68C8),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _lottieCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted && !_hasAutoShown) {
          _hasAutoShown = true;
          _visitedTabs.add(0);
          _openBubble(
            autoClose: true,
            message: CatMessages.tabIntro(0),
          );
        }
      });
    });
  }

  String _currentMessage = '';

  void _openBubble({bool autoClose = false, String? message}) {
    if (!mounted) return;
    _currentMessage = message ?? _currentMessage;
    setState(() => _bubbleVisible = true);
    _bubbleTimer?.cancel();
    if (autoClose) {
      _bubbleTimer = Timer(const Duration(seconds: 5), _closeBubble);
    }
  }

  void _closeBubble() {
    if (!mounted) return;
    _bubbleTimer?.cancel();
    setState(() => _bubbleVisible = false);
  }

  void _onCatTapped() {
    SoundService.playClick();
    if (_bubbleVisible) {
      _closeBubble();
    } else {
      if (!_shownAfterFirstTap) {
        _shownAfterFirstTap = true;
        _openBubble(message: CatMessages.afterFirstTap());
      } else {
        _openBubble(message: CatMessages.randomAfterFirstVisit());
      }
    }
  }

  void onTabTapped(int index) {
    if (currentIndex != index) {
      SoundService.playClick();
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
      _closeBubble();
      if (!_visitedTabs.contains(index)) {
        _visitedTabs.add(index);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _openBubble(
            autoClose: true,
            message: CatMessages.tabIntro(index),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    _lottieCtrl.dispose();
    _bubbleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int safeIndex = currentIndex.clamp(0, _tabAccents.length - 1);
    final Color accent = _tabAccents[safeIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (i) => setState(() => currentIndex = i),
            children: const [
              DashboardScreen(),
              CoursesScreen(),
              AchievementsScreen(),
              ProfileScreen(),
            ],
          ),

          // Speech bubble — positioned just above and to the right of the cat
          Positioned(
            left: 90,
            bottom: 62,
            child: IgnorePointer(
              ignoring: !_bubbleVisible,
              child: AnimatedOpacity(
                opacity: _bubbleVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedScale(
                  scale: _bubbleVisible ? 1.0 : 0.85,
                  alignment: Alignment.bottomLeft,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B2E),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border.all(color: accent.withValues(alpha: 0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentMessage,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Cat — your exact left/bottom values preserved
          Positioned(
            left: -18,
            bottom: -44.5,
            child: GestureDetector(
              onTap: _onCatTapped,
              child: SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/animations/cat.json',
                  controller: _lottieCtrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161B2E),
          border: Border(
            top: BorderSide(
                color: const Color(0xFF00D1FF).withValues(alpha: 0.15), width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home_rounded,         label: 'Home',    index: 0),
                _buildNavItem(icon: Icons.menu_book_rounded,    label: 'Lessons', index: 1),
                _buildNavItem(icon: Icons.emoji_events_rounded, label: 'Badges',  index: 2),
                _buildNavItem(icon: Icons.person_rounded,       label: 'Profile', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D1FF).withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Icon(icon,
              color: isSelected
                  ? const Color(0xFF00D1FF)
                  : Colors.white.withValues(alpha: 0.3),
              size: 26),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: GoogleFonts.fredoka(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF00D1FF)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            child: Text(label),
          ),
        ]),
      ),
    );
  }
}