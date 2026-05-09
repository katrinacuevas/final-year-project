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
  int _selectedIndex = 0;
  bool _saving = false;

  late AnimationController _floatingCtrl;
  late Animation<double> _floatingAnim;
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  final List<Map<String, dynamic>> _avatars = [
    {
      'emoji': '🐱',
      'name': 'Pixel Cat',
      'rarity': 'RARE',
      'rarityColor': const Color(0xFF00D1FF),
      'desc': 'Puzzle-solving cyber expert',
      'color': const Color(0xFFFFC857),
    },
    {
      'emoji': '🦊',
      'name': 'Fox Agent',
      'rarity': 'EPIC',
      'rarityColor': const Color(0xFFBA68C8),
      'desc': 'Fast-thinking internet detective',
      'color': const Color(0xFFFF8A65),
    },
    {
      'emoji': '🐸',
      'name': 'Frog Scout',
      'rarity': 'COMMON',
      'rarityColor': const Color(0xFF81C784),
      'desc': 'Explorer of hidden secrets',
      'color': const Color(0xFF81C784),
    },
    {
      'emoji': '🧙',
      'name': 'Cyber Wizard',
      'rarity': 'EPIC',
      'rarityColor': const Color(0xFFBA68C8),
      'desc': 'Master of online tricks',
      'color': const Color(0xFFBA68C8),
    },
    {
      'emoji': '🤖',
      'name': 'Bot Defender',
      'rarity': 'RARE',
      'rarityColor': const Color(0xFF00D1FF),
      'desc': 'Blocks sneaky scammers',
      'color': const Color(0xFF4FC3F7),
    },
    {
      'emoji': '👾',
      'name': 'Pixel Beast',
      'rarity': 'LEGENDARY',
      'rarityColor': const Color(0xFFFFD700),
      'desc': 'Elite cyber guardian',
      'color': const Color(0xFF6C63FF),
    },
    {
      'emoji': '🧑‍🚀',
      'name': 'Space Agent',
      'rarity': 'RARE',
      'rarityColor': const Color(0xFF00D1FF),
      'desc': 'Protects the cyber galaxy',
      'color': const Color(0xFFFFB74D),
    },
    {
      'emoji': '🦸',
      'name': 'Cyber Hero',
      'rarity': 'EPIC',
      'rarityColor': const Color(0xFFBA68C8),
      'desc': 'Stops online villains',
      'color': const Color(0xFFF06292),
    },
  ];

  final List<String> _mascotMessages = [
    "Pixel Cat — that's me!\nA purrfect choice, agent! 🐱",
    "Fox Agent! Cunning and clever —\njust like a real detective!",
    "Frog Scout reporting for duty!\nReady to leap into action!",
    "Cyber Wizard! Ancient powers\nmeet modern cyber skills!",
    "Bot Defender! No scammer\nstands a chance against you!",
    "Pixel Beast — LEGENDARY status!\nThe ultimate cyber guardian!",
    "Space Agent! Protecting\nthe galaxy from online threats!",
    "Cyber Hero! Villains beware —\nyou're on the case!",
  ];

  @override
  void initState() {
    super.initState();

    _floatingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatingAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingCtrl, curve: Curves.easeInOut),
    );

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    SoundService.playClick();
    setState(() => _saving = true);

    try {
      final av = _avatars[_selectedIndex];

      final profile = UserProfile(
        uid: UserService.instance.uid!,
        username: widget.username,
        avatarIndex: _selectedIndex,
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
          pageBuilder: (_, __, ___) => const WelcomeFlash(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() => _saving = false);
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
    final selected = _avatars[_selectedIndex];
    final selectedColor = selected['color'] as Color;
    final rarityColor = selected['rarityColor'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF161B2E),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF00D1FF)
                                        .withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.arrow_back_rounded,
                                  color: Color(0xFF00D1FF), size: 20),
                            ),
                          ).animate().scale(),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D1FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      const Color(0xFF00D1FF).withOpacity(0.4)),
                            ),
                            child: Row(children: [
                              const Icon(Icons.person_pin_rounded,
                                  color: Color(0xFF00D1FF), size: 14),
                              const SizedBox(width: 6),
                              Text('AGENT SETUP — STEP 2 OF 2',
                                  style: GoogleFonts.fredoka(
                                      color: const Color(0xFF00D1FF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _floatingAnim,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(0, _floatingAnim.value),
                              child: child,
                            ),
                            child: SizedBox(
                              width: 100,
                              height: 100,
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
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: Container(
                                key: ValueKey(_selectedIndex),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161B2E),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                  border: Border.all(
                                      color: const Color(0xFF00D1FF)
                                          .withOpacity(0.3),
                                      width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF00D1FF)
                                            .withOpacity(0.08),
                                        blurRadius: 12),
                                  ],
                                ),
                                child: Text(
                                  _mascotMessages[_selectedIndex],
                                  style: GoogleFonts.fredoka(
                                      fontSize: 13,
                                      color: Colors.white,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'CHOOSE YOUR\nCYBER PARTNER',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ).animate().fade().slideY(begin: 0.2),
                      const SizedBox(height: 6),
                      Text(
                        widget.username,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          color: const Color(0xFFFFC857),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ).animate().fade(),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _floatingAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _floatingAnim.value * 0.5),
                          child: child,
                        ),
                        child: AnimatedBuilder(
                          animation: _glowAnim,
                          builder: (_, child) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: selectedColor
                                      .withOpacity(0.5 * _glowAnim.value),
                                  blurRadius: 35,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              gradient: LinearGradient(
                                colors: [
                                  selectedColor,
                                  const Color(0xFF161B2E),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                  color: selectedColor.withOpacity(0.6),
                                  width: 2.5),
                            ),
                            child: Center(
                              child: Text(
                                selected['emoji'] as String,
                                style: const TextStyle(fontSize: 68),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          key: ValueKey(_selectedIndex),
                          children: [
                            Text(
                              selected['name'] as String,
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: rarityColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: rarityColor.withOpacity(0.6)),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      selected['rarity'] == 'LEGENDARY'
                                          ? Icons.auto_awesome
                                          : selected['rarity'] == 'EPIC'
                                              ? Icons.diamond_rounded
                                              : selected['rarity'] == 'RARE'
                                                  ? Icons.star_rounded
                                                  : Icons.circle,
                                      color: rarityColor,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      selected['rarity'] as String,
                                      style: GoogleFonts.fredoka(
                                        color: rarityColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selected['desc'] as String,
                              style: GoogleFonts.fredoka(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _avatars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (_, i) {
                      final av = _avatars[i];
                      final isSelected = i == _selectedIndex;
                      final avColor = av['color'] as Color;
                      final avRarity = av['rarityColor'] as Color;

                      return GestureDetector(
                        onTap: () {
                          SoundService.playClick();
                          setState(() => _selectedIndex = i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: isSelected
                                ? avColor.withOpacity(0.18)
                                : const Color(0xFF161B2E),
                            border: Border.all(
                              color: isSelected
                                  ? avColor
                                  : const Color(0xFF00D1FF).withOpacity(0.1),
                              width: isSelected ? 2.5 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: avColor.withOpacity(0.35),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: isSelected ? 1.15 : 1.0,
                                child: Text(
                                  av['emoji'] as String,
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                av['name'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: GoogleFonts.fredoka(
                                  color: isSelected ? Colors.white : Colors.white54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: avRarity.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  av['rarity'] as String,
                                  style: GoogleFonts.fredoka(
                                    color: isSelected ? avRarity : avRarity.withOpacity(0.5),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Icon(Icons.check_circle_rounded,
                                      color: avColor, size: 14),
                                ).animate().scale(),
                            ],
                          ),
                        ).animate().fade().slideY(
                              begin: 0.2,
                              delay: Duration(milliseconds: i * 60),
                            ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                  child: AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (_, child) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D1FF)
                                .withOpacity(0.35 * _glowAnim.value),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _finish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D1FF),
                          disabledBackgroundColor:
                              const Color(0xFF00D1FF).withOpacity(0.3),
                          foregroundColor: const Color(0xFF0D1117),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)),
                          elevation: 0,
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Color(0xFF0D1117), strokeWidth: 2.5))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.rocket_launch_rounded,
                                      size: 20),
                                  const SizedBox(width: 10),
                                  Text('Deploy Agent →',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                      ),
                    ),
                  ).animate().fade().scale(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D1FF).withOpacity(0.04)
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