// ========================================================================
// splash_screen.dart 
// ------------------------------------------------------------------------
// display the animated splash screen when the app launches 
// automatically route the user to onboarding or the main app 
// ========================================================================

import 'dart:async';
import 'package:final_year_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'username_screen.dart';
import '../widgets/loading_dots.dart';
import '../widgets/navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ----- animation controllers -----
  late AnimationController ctrl;
  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<double> glowPulse;
  late Animation<double> textFade;
  late Animation<Offset> textSlide;
  late Animation<double> dotsFade;

  @override
  void initState() {
    super.initState();

    // ----- main animation controller -----
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // ----- logo scale animatoon -----
    logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // ----- logo fade animation -----
    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // ----- glow pulse animation -----
    glowPulse = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // ----- title fade animation -----
    textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
      ),
    );

    // ----- title slide animation -----
    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    // ----- loading dots fade animation -----
    dotsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // start all animations 
    ctrl.forward();

    // ----- delayed navigation -----
    Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;

      // check if user already completed profile setup 
      final destination = UserService.instance.hasProfile
          ? const MainNavigationScreen()
          : const UsernameScreen();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),

          // destination screen
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          // fade screen transition
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: SplashGridPainter())),
          Center(
            child: AnimatedBuilder(
              animation: ctrl,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: logoFade,
                      child: ScaleTransition(
                        scale: logoScale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D1FF)
                                    .withValues(alpha: 0.45 * glowPulse.value),
                                blurRadius: 50,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF161B2E),
                              borderRadius: BorderRadius.circular(34),
                              border: Border.all(
                                color: const Color(0xFF00D1FF)
                                    .withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text('🛡️',
                                  style: TextStyle(fontSize: 62)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: textFade,
                      child: SlideTransition(
                        position: textSlide,
                        child: Column(
                          children: [
                            Text(
                              'CyberShield',
                              style: GoogleFonts.fredoka(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D1FF)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF00D1FF)
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.language_rounded,
                                      color: Color(0xFF00D1FF), size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    'STAY SAFE ONLINE',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 13,
                                      color: const Color(0xFF00D1FF),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 52),
                    FadeTransition(
                      opacity: dotsFade,
                      child: const LoadingDots(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SplashGridPainter extends CustomPainter {
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