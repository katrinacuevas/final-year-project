import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_year_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';
import '../widgets/cat_mascot.dart';
import 'avatar_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});
  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> with TickerProviderStateMixin {
  final TextEditingController _ctrl = TextEditingController();
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;
  bool _checking = false;
  bool _navigating = false;
  bool _hasText = false;
  bool? _isAvailable;
  Timer? _debounce;

  final List<String> _suggestions = [
    'ShadowAgent7', 'CipherCat', 'PixelPro',
    'NeonDetective', 'CovertFox', 'MysticProbe',
  ];

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _ctrl.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _ctrl.text.trim();
    setState(() { _hasText = text.isNotEmpty; _isAvailable = null; });
    _debounce?.cancel();
    if (text.isEmpty) return;
    setState(() => _checking = true);
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final taken = await UserService.instance.isUsernameTaken(text);
        if (!mounted) return;
        if (_ctrl.text.trim() != text) return;
        setState(() { _checking = false; _isAvailable = !taken; });
      } catch (_) {
        if (!mounted) return;
        setState(() { _checking = false; _isAvailable = null; });
      }
    });
  }

  bool _looksUnsafe(String text) {
    final lower = text.toLowerCase();
    final realNames = ['john', 'emma', 'jack', 'oliver', 'harry', 'sophia', 'charlie'];
    return realNames.any((e) => lower.contains(e)) || RegExp(r'19|20|201').hasMatch(lower);
  }

  Future<void> _next() async {
    if (_checking || _navigating) return;
    if (_isAvailable == false) return;
    SoundService.playClick();
    setState(() => _navigating = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => AvatarScreen(username: _ctrl.text.trim()),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ));
  }

  String get _mascotMessage {
    if (!_hasText) return "Hi! I'm Byte 🐱\nEvery great detective needs a secret codename!";
    if (_checking) return "Running identity check through HQ database...";
    if (_looksUnsafe(_ctrl.text.trim())) return "⚠️ Never use your real name!\nPick a cool codename instead!";
    if (_isAvailable == true) return "Identity confirmed! That codename is all yours! 🕵️";
    if (_isAvailable == false) return "Another agent has that name!\nTry a different codename!";
    return "Looking good, agent! Hit go when you're ready!";
  }

  CatMood get _mascotMood {
    if (!_hasText) return CatMood.happy;
    if (_checking) return CatMood.thinking;
    if (_looksUnsafe(_ctrl.text.trim())) return CatMood.sad;
    if (_isAvailable == true) return CatMood.excited;
    if (_isAvailable == false) return CatMood.sad;
    return CatMood.cheeky;
  }

  @override
  void dispose() {
    _ctrl.dispose(); _glowCtrl.dispose(); _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.shield, color: Color(0xFF00D1FF), size: 14),
                    const SizedBox(width: 6),
                    Text('AGENT SETUP — STEP 1 OF 2',
                      style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 12,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ]),
                ),
              ]),
              const SizedBox(height: 24),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: CatMascot(
                  key: ValueKey(_mascotMessage),
                  message: _mascotMessage,
                  accentColor: const Color(0xFF00D1FF),
                  mood: _mascotMood,
                  size: 90,
                ),
              ),

              const SizedBox(height: 24),
              Text('CREATE YOUR\nSECRET CODENAME',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700, height: 1.1),
              ).animate().fade().slideY(begin: 0.2),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: DefaultTextStyle(
                  style: GoogleFonts.fredoka(fontSize: 17, color: const Color(0xFF00D1FF), fontWeight: FontWeight.w600),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText('Every great detective needs a codename!', speed: const Duration(milliseconds: 80)),
                      TypewriterAnimatedText('Never use your real name online!', speed: const Duration(milliseconds: 80)),
                      TypewriterAnimatedText('Pick something cool and mysterious!', speed: const Duration(milliseconds: 80)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: const Color(0xFF00D1FF).withValues(alpha: 0.15 * _glowAnim.value), blurRadius: 24, spreadRadius: 2)],
                  ),
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B2E), borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('YOUR CODENAME',
                      style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ctrl,
                      autofocus: true,
                      style: GoogleFonts.fredoka(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true, fillColor: const Color(0xFF0D1117),
                        hintText: 'e.g. ShadowAgent7',
                        hintStyle: GoogleFonts.fredoka(color: Colors.white24, fontSize: 20),
                        prefixIcon: const Icon(Icons.manage_accounts_rounded, color: Color(0xFF00D1FF), size: 22),
                        suffixIcon: _checking
                            ? const Padding(padding: EdgeInsets.all(12),
                                child: SizedBox(width: 20, height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00D1FF))))
                            : _isAvailable == true
                                ? const Icon(Icons.verified_user_rounded, color: Color(0xFF00E676))
                                : _isAvailable == false
                                    ? const Icon(Icons.block_rounded, color: Color(0xFFFF6B6B))
                                    : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: _hasText ? (_isAvailable == true ? const Color(0xFF00E676) : _isAvailable == false ? const Color(0xFFFF6B6B) : const Color(0xFF00D1FF)) : Colors.transparent,
                            width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: _isAvailable == true ? const Color(0xFF00E676) : _isAvailable == false ? const Color(0xFFFF6B6B) : const Color(0xFF00D1FF),
                            width: 2)),
                      ),
                      onSubmitted: (_) => _next(),
                    ),
                    const SizedBox(height: 18),
                    Text('SUGGESTED CODENAMES',
                      style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _suggestions.map((e) => GestureDetector(
                        onTap: () {
                          SoundService.playClick();
                          _ctrl.text = e;
                          _ctrl.selection = TextSelection.fromPosition(TextPosition(offset: e.length));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.3)),
                          ),
                          child: Text(e, style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ).animate().scale(delay: Duration(milliseconds: Random().nextInt(400)))).toList(),
                    ),
                  ]),
                ),
              ).animate().fade().slideY(begin: 0.3),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _glowAnim,
                  builder: (_, child) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: _hasText && _isAvailable != false
                          ? [BoxShadow(color: const Color(0xFF00D1FF).withValues(alpha: 0.4 * _glowAnim.value), blurRadius: 20, spreadRadius: 1)]
                          : [],
                    ),
                    child: child,
                  ),
                  child: ElevatedButton(
                    onPressed: _hasText && _isAvailable != false && !_navigating ? _next : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D1FF),
                      disabledBackgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.3),
                      foregroundColor: const Color(0xFF0D1117),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 0,
                    ),
                    child: _navigating
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(color: Color(0xFF0D1117), strokeWidth: 2.5))
                        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Icon(Icons.rocket_launch_rounded, size: 20),
                            const SizedBox(width: 10),
                            Text('Begin Mission →', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700)),
                          ]),
                  ),
                ),
              ).animate().fade().scale(),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF00D1FF).withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}