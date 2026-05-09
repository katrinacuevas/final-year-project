import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_year_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../services/sound_service.dart';
import 'welcome_screen.dart';

class AvatarScreen extends StatefulWidget {
  final String username;
  const AvatarScreen({super.key, required this.username});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool saving = false;

  late AnimationController floatingCtrl;
  late Animation<double> floatingAnim;
  late AnimationController glowCtrl;
  late Animation<double> glowAnim;

  final List<Map<String, dynamic>> avatars = [
    {
      'emoji': '🐱',
      'name': 'Pixel Cat',
      'desc': 'Puzzle-solving cyber expert',
      'color': const Color(0xFFFFC857),
    },
    {
      'emoji': '🦊',
      'name': 'Fox Agent',
      'desc': 'Fast-thinking internet detective',
      'color': const Color(0xFFFF8A65),
    },
    {
      'emoji': '🐸',
      'name': 'Frog Scout',
      'desc': 'Explorer of hidden secrets',
      'color': const Color(0xFF81C784),
    },
    {
      'emoji': '🤖',
      'name': 'Bot Defender',
      'desc': 'Blocks sneaky scammers',
      'color': const Color(0xFF4FC3F7),
    },
    {
      'emoji': '👾',
      'name': 'Pixel Beast',
      'desc': 'Elite cyber guardian',
      'color': const Color(0xFF6C63FF),
    },
    {
      'emoji': '🐉',
      'name': 'Data Dragon',
      'desc': 'Guardian of secret info',
      'color': const Color(0xFFEF5350),
    },
  ];

  final List<String> mascotMessages = [
    "Pixel Cat — that's me!\nA purrfect choice, agent! 🐱",
    "Fox Agent! Cunning and clever —\njust like a real detective!",
    "Frog Scout reporting for duty!\nReady to leap into action!",
    "Bot Defender! No scammer\nstands a chance against you!",
    "Pixel Beast! The ultimate\ncyber guardian is ready!",
    "Data Dragon! Breathing fire\nat anyone who steals data!",
  ];

  @override
  void initState() {
    super.initState();

    floatingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    floatingAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: floatingCtrl, curve: Curves.easeInOut),
    );

    glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    floatingCtrl.dispose();
    glowCtrl.dispose();
    super.dispose();
  }

  Future<void> finish() async {
    if (saving) return;
    SoundService.playClick();
    setState(() => saving = true);

    try {
      final av = avatars[selectedIndex];

      final profile = UserProfile(
        uid: UserService.instance.uid!,
        username: widget.username,
        avatarIndex: selectedIndex,
        avatarEmoji: av['emoji'] as String,
        avatarName: av['name'] as String,
        avatarColour:
            '0x${((av['color'] as Color).value.toRadixString(16)).padLeft(8, '0')}',
      );

      await UserService.instance.saveProfile(profile);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeFlash(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() => saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = avatars[selectedIndex];
    final selectedColor = selected['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          SoundService.playClick();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B2E),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF00D1FF).withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Color(0xFF00D1FF), size: 20),
                        ),
                      ).animate().scale(),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00D1FF).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_pin_rounded,
                                color: Color(0xFF00D1FF), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'AGENT SETUP — STEP 2 OF 2',
                              style: GoogleFonts.fredoka(
                                color: const Color(0xFF00D1FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedBuilder(
                        animation: floatingAnim,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, floatingAnim.value),
                          child: child,
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Lottie.asset(
                            'assets/animations/cat.json',
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: Container(
                            key: ValueKey(selectedIndex),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F35),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                bottomLeft: Radius.circular(4),
                              ),
                              border: Border.all(
                                color: const Color(0xFF00D1FF).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Text(
                              mascotMessages[selectedIndex],
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'CHOOSE YOUR\nCYBER PARTNER',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ).animate().fade().slideY(begin: 0.2),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 44,
                    child: DefaultTextStyle(
                      style: GoogleFonts.fredoka(
                        fontSize: 17,
                        color: const Color(0xFF00D1FF),
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Your partner fights scammers by your side!',
                            speed: const Duration(milliseconds: 75),
                          ),
                          TypewriterAnimatedText(
                            'Each avatar has a unique cyber power!',
                            speed: const Duration(milliseconds: 75),
                          ),
                          TypewriterAnimatedText(
                            'Pick the one that matches your style!',
                            speed: const Duration(milliseconds: 75),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: glowAnim,
                    builder: (context, child) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor.withValues(
                                alpha: 0.18 * glowAnim.value),
                            blurRadius: 28,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B2E),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFF00D1FF).withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR CYBER PARTNER',
                            style: GoogleFonts.fredoka(
                              color: const Color(0xFF00D1FF),
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              key: ValueKey(selectedIndex),
                              children: [
                                AnimatedBuilder(
                                  animation: glowAnim,
                                  builder: (context, child) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedColor.withValues(
                                              alpha: 0.45 * glowAnim.value),
                                          blurRadius: 28,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: child,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: LinearGradient(
                                        colors: [
                                          selectedColor,
                                          const Color(0xFF0D1117),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: selectedColor.withValues(alpha: 0.7),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selected['emoji'] as String,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selected['name'] as String,
                                        style: GoogleFonts.fredoka(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        selected['desc'] as String,
                                        style: GoogleFonts.fredoka(
                                          color: Colors.white54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'PICK YOUR PARTNER',
                            style: GoogleFonts.fredoka(
                              color: Colors.white38,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: avatars.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, i) {
                              final av = avatars[i];
                              final isSelected = i == selectedIndex;
                              final avColor = av['color'] as Color;

                              return GestureDetector(
                                onTap: () {
                                  SoundService.playClick();
                                  setState(() => selectedIndex = i);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isSelected
                                        ? avColor.withValues(alpha: 0.18)
                                        : const Color(0xFF0D1117),
                                    border: Border.all(
                                      color: isSelected
                                          ? avColor
                                          : const Color(0xFF00D1FF)
                                              .withValues(alpha: 0.12),
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: avColor.withValues(alpha: 0.3),
                                              blurRadius: 14,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedScale(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        scale: isSelected ? 1.15 : 1.0,
                                        child: Text(
                                          av['emoji'] as String,
                                          style: const TextStyle(fontSize: 34),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        av['name'] as String,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: GoogleFonts.fredoka(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white54,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: avColor,
                                            size: 14,
                                          ),
                                        ).animate().scale(),
                                    ],
                                  ),
                                ).animate().fade().slideY(
                                      begin: 0.2,
                                      delay: Duration(milliseconds: i * 55),
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade().slideY(begin: 0.3),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedBuilder(
                      animation: glowAnim,
                      builder: (context, child) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D1FF)
                                  .withValues(alpha: 0.4 * glowAnim.value),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: child,
                      ),
                      child: ElevatedButton(
                        onPressed: saving ? null : finish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D1FF),
                          disabledBackgroundColor:
                              const Color(0xFF00D1FF).withValues(alpha: 0.3),
                          foregroundColor: const Color(0xFF0D1117),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child: saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0D1117),
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.rocket_launch_rounded,
                                      size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Deploy Agent →',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ).animate().fade().scale(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
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