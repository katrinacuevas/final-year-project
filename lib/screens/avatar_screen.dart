import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_year_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';
import '../widgets/cat_mascot.dart';
import 'welcome_screen.dart';

class AvatarScreen extends StatefulWidget {
  final String username; // passed from username_screen
  const AvatarScreen({super.key, required this.username});
  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> with TickerProviderStateMixin {
  int selectedIndex = 0; // index of the currently selected avatar 
  bool saving = false; // true while the profile is being saved to the backend

  // animation controller and animation for the glowing border/button effect
  late AnimationController glowCtrl;
  late Animation<double> glowAnim;

  // ----- avatar data -----
  // each entry holds the emoji, display name and accent colour
  final List<Map<String, dynamic>> avatars = [
    {'emoji': '🐱', 'name': 'Pixel Cat', 'color': const Color(0xFFFFC857)},
    {'emoji': '🦊', 'name': 'Fox Agent', 'color': const Color(0xFFFF8A65)},
    {'emoji': '🐸', 'name': 'Frog Scout', 'color': const Color(0xFF81C784)},
    {'emoji': '🤖', 'name': 'Bot Defender', 'color': const Color(0xFF4FC3F7)},
    {'emoji': '👾', 'name': 'Pixel Beast', 'color': const Color(0xFF6C63FF)},
    {'emoji': '🐉', 'name': 'Data Dragon', 'color': const Color(0xFFEF5350)},
  ];

  // ----- mascot messages -----
  // one message per avatar shown in the cat mascot speech bubble 
  final List<String> mascotMessages = [
    "Pixel Cat — that's me!\nA purrfect choice, agent! 🐱",
    "Fox Agent! Cunning and clever —\njust like a real detective!",
    "Frog Scout reporting for duty!\nReady to leap into action!",
    "Bot Defender! No scammer\nstands a chance against you!",
    "Pixel Beast! The ultimate\ncyber guardian is ready!",
    "Data Dragon! Breathing fire\nat anyone who steals data!",
  ];

  // ----- mascot moods -----
  final List<CatMood> mascotMoods = [
    CatMood.happy, CatMood.cheeky, CatMood.excited,
    CatMood.proud, CatMood.excited, CatMood.cheeky,
  ];

  @override
  void initState() {
    super.initState();
    // looping glow animation that pulses 
    glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { 
    // clean up animation controller to prevent memory leaks 
    glowCtrl.dispose(); 
    super.dispose(); 
  }

  // ----- finish / save profile -----
  // build a userProfile from the selected avatar and username 
  // save to the backend then navigate to the welcome flash screen
  Future<void> finish() async {
    if (saving) return; // prevent double-taps 
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
        // convert colour to hex string for storage 
        avatarColour: '0x${((av['color'] as Color).toARGB32().toRadixString(16)).padLeft(8, '0')}',
      );
      await UserService.instance.saveProfile(profile);
      if (!mounted) return;
      // clear the navigation stack so the user cant go back to setup 
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) => const WelcomeFlash(),
          // fade transition into the welcome screen
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    } catch (e) {
      // on error re-enable the button and show a snackbar with the error message 
      setState(() => saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = avatars[selectedIndex];
    final selectedColor = selected['color'] as Color; // accent colour for selected avatar

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: GridPainter())),
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(children: [
              // ----- top bar -----
              // back button and step indicator badge 
              Row(children: [
                GestureDetector(
                  onTap: () { SoundService.playClick(); Navigator.pop(context); },
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B2E), borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF00D1FF), size: 18),
                  ),
                ).animate().scale(),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.person_pin_rounded, color: Color(0xFF00D1FF), size: 14),
                    const SizedBox(width: 6),
                    Text('AGENT SETUP — STEP 2 OF 2',
                      style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 12,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ]),
                ),
              ]),
              const SizedBox(height: 10),

              // ----- cat mascot -----
              // messae and mood update when the selected avatar changes 
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: CatMascot(
                  key: ValueKey(selectedIndex), // key forces rebuild on avatar change 
                  message: mascotMessages[selectedIndex],
                  accentColor: selectedColor,
                  mood: mascotMoods[selectedIndex],
                  size: 200,
                ),
              ),

              // ----- screen title -----
              const SizedBox(height: 8),
              Text('CHOOSE YOUR CYBER PARTNER',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, height: 1.1),
              ).animate().fade().slideY(begin: 0.2),
              const SizedBox(height: 6),
              // ----- tip typewriter animation -----
              SizedBox(
                height: 30,
                child: DefaultTextStyle(
                  style: GoogleFonts.fredoka(fontSize: 13, color: const Color(0xFF00D1FF), fontWeight: FontWeight.w600),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText('Your partner fights scammers by your side!', speed: const Duration(milliseconds: 75)),
                      TypewriterAnimatedText('Pick the one that matches your style!', speed: const Duration(milliseconds: 75)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ----- avatar selection card -----
              // glow colour updates to match the selected avatar's accent colour
              AnimatedBuilder(
                animation: glowAnim,
                builder: (context, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: selectedColor.withValues(alpha: 0.18 * glowAnim.value), blurRadius: 28, spreadRadius: 2)],
                  ),
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B2E), borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('YOUR CYBER PARTNER',
                      style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text('PICK YOUR PARTNER',
                      style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
                    const SizedBox(height: 8),

                    // ----- avatar grid -----
                    // 3-column grid, selected card glows with its accent colour
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: avatars.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.05),
                      itemBuilder: (context, i) {
                        final av = avatars[i];
                        final isSelected = i == selectedIndex;
                        final avColor = av['color'] as Color;
                        return GestureDetector(
                          onTap: () { SoundService.playClick(); SoundService.playCatHappy(); setState(() => selectedIndex = i); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              // highlight selected card with accent colour tint 
                              color: isSelected ? avColor.withValues(alpha: 0.18) : const Color(0xFF0D1117),
                              border: Border.all(
                                color: isSelected ? avColor : const Color(0xFF00D1FF).withValues(alpha: 0.12),
                                width: isSelected ? 2.5 : 1.5),
                              boxShadow: isSelected ? [BoxShadow(color: avColor.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 1)] : [],
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: isSelected ? 1.1 : 1.0,
                                child: Text(av['emoji'] as String, style: const TextStyle(fontSize: 28)),
                              ),
                              const SizedBox(height: 4),
                              Text(av['name'] as String,
                                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.fredoka(
                                  color: isSelected ? Colors.white : Colors.white54,
                                  fontSize: 10, fontWeight: FontWeight.w600)),
                            ]),
                          // staggered fade-in animation per card 
                          ).animate().fade().slideY(begin: 0.2, delay: Duration(milliseconds: i * 55)),
                        );
                      },
                    ),
                  ]),
                ),
              ).animate().fade().slideY(begin: 0.3),
              const SizedBox(height: 12),

              // ----- deploy agent button -----
              // always glows and show a spinner whilst saving
              SizedBox(
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: glowAnim,
                  builder: (context, child) => Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: const Color(0xFF00D1FF).withValues(alpha: 0.4 * glowAnim.value), blurRadius: 20, spreadRadius: 1)]),
                    child: child,
                  ),
                  child: ElevatedButton(
                    // disabled whilst saving to prevent double submission 
                    onPressed: saving ? null : finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D1FF),
                      disabledBackgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.3),
                      foregroundColor: const Color(0xFF0D1117),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                    ),
                    // show spinner while saving otherwise show label and icon
                    child: saving
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Color(0xFF0D1117), strokeWidth: 2.5))
                        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Icon(Icons.rocket_launch_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text('Deploy Agent →', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700)),
                          ]),
                  ),
                ),
              ).animate().fade().scale(),
              const SizedBox(height: 8),
            ]),
          ),
        ),
      ]),
    );
  }
}

// cyan grid over dark background 
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}