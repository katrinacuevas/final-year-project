// ========================================================================
// username_screen.dart 
// ------------------------------------------------------------------------
// step 1 of the setup flow 
// lets the user pick a username before moving onto the avatar selection screen
//  - text input with live availability checking via user_service 
//  - debounced backend calls to avoid spamming the button 
//  - suggested usernames for quick selection 
//  - cat mascot reacts to input state with mood + message 
//  - navigate to avatar_screen on success
// ========================================================================

import 'dart:async';
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
  // controller for the username text field 
  final TextEditingController _ctrl = TextEditingController();

  // animation controller and animation for the glowing border/button effect 
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  // state flags to track loading, navigation, input and username availability 
  bool _checking = false; // true while checking username availability
  bool _navigating = false; // true while transitioning to the next screen (avatar)
  bool _hasText = false; // true when the text field is not empty 
  bool? _isAvailable; // null = unknown, true = available, false = taken

  // debounce timer to delay availability checks while the user is still typing
  Timer? _debounce;

  // pre-defined username suggestions 
  final List<String> _suggestions = [
    'ShadowAgent7', 'CipherCat', 'PixelPro',
    'NeonDetective', 'MischeviousFox', 'MysticHero',
  ];

  @override
  void initState() {
    super.initState();
    // looping glow animation that pulses 
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    // listen for changes in the text field to trigger availability checks
    _ctrl.addListener(_onTextChanged);
  }

  // called on every key stroke, resets availability state and starts a debounce 
  // availability check so the backend is not spammed on every character 
  void _onTextChanged() {
    final text = _ctrl.text.trim();
    setState(() { 
      _hasText = text.isNotEmpty; 
      _isAvailable = null; // reset while re-checking
    });

    _debounce?.cancel();
    if (text.isEmpty) return;

    setState(() => _checking = true);
    
    // only check availability once the user pauses typing for 600ms
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final taken = await UserService.instance.isUsernameTaken(text);
        if (!mounted) return;
        // ignore the result if the user has already changed the text 
        if (_ctrl.text.trim() != text) return;
        setState(() {
          _checking = false;
          _isAvailable = !taken;
        });
        if (!taken) {
          SoundService.playCatHappy();
        } else {
          SoundService.playCatIncorrect();
        }
      } catch (_) {
        // on error silently reset 
        if (!mounted) return;
        setState(() { 
          _checking = false; 
          _isAvailable = null; 
        });
      }
    });
  }

  // begin mission button tap, play a click sound
  // navigate to avatar_screen with a slide transition
  Future<void> _next() async {
    if (_checking || _navigating) return; // prevent double-taps 
    if (_isAvailable == false) return; // block if username is taken 

    SoundService.playClick();
    setState(() => _navigating = true);

    // delay to let the loading indicator render befire pushing the route
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, _, _) => AvatarScreen(username: _ctrl.text.trim()),
      // slide in from the right 
      transitionsBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ));
  }

  // return the appropriate message for the cat mascot based on current input state 
  String get _mascotMessage {
    if (!_hasText) return "Hi! I'm Byte 🐱\nEvery great detective needs a secret codename!";
    if (_checking) return "Running identity check through HQ database...";
    if (_isAvailable == true) return "Identity confirmed! That codename is all yours! 🕵️";
    if (_isAvailable == false) return "Another agent has that name!\nTry a different codename!";
    return "Looking good, agent! Hit go when you're ready!";
  }

  // return a mood for the cat mascot based on current input state 
  CatMood get _mascotMood {
    if (!_hasText) return CatMood.happy;
    if (_checking) return CatMood.thinking;
    if (_isAvailable == true) return CatMood.excited;
    if (_isAvailable == false) return CatMood.sad;
    return CatMood.cheeky;
  }

  @override
  void dispose() {
    // clean up controllers and timers to prevent memory leaks 
    _ctrl.dispose(); 
    _glowCtrl.dispose(); 
    _debounce?.cancel();
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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(children: [
              // ----- step indicator badge -----
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
              const SizedBox(height: 30),

              // ----- cat mascot -----
              // swap message and mood based on input state
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: CatMascot(
                  key: ValueKey(_mascotMessage), // key forces rebuild on message change 
                  message: _mascotMessage,
                  accentColor: const Color(0xFF00D1FF),
                  mood: _mascotMood,
                  size: 200,
                ),
              ),

              // ----- screen title -----
              const SizedBox(height: 3),
              Text('CREATE YOUR SECRET CODENAME',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700, height: 1.1),
              ).animate().fade().slideY(begin: 0.2),
              const SizedBox(height: 6),
              // ----- safety tip typewrite animation -----
              SizedBox(
                height: 34,
                child: DefaultTextStyle(
                  style: GoogleFonts.fredoka(fontSize: 14, color: const Color(0xFF00D1FF), fontWeight: FontWeight.w600),
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
              const SizedBox(height: 12),

              // ----- input card with animated glow border -----
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFF00D1FF).withValues(alpha: 0.15 * _glowAnim.value), blurRadius: 24, spreadRadius: 2)],
                  ),
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B2E), borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('YOUR CODENAME',
                      style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    // ----- text field -----
                    // border colour reflects availability state
                    TextField(
                      controller: _ctrl,
                      autofocus: true,
                      style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true, fillColor: const Color(0xFF0D1117),
                        hintText: 'e.g. ShadowAgent7',
                        hintStyle: GoogleFonts.fredoka(color: Colors.white24, fontSize: 18),
                        prefixIcon: const Icon(Icons.manage_accounts_rounded, color: Color(0xFF00D1FF), size: 20),
                        // suffix icon shows a spinner, tick or cross depending on state
                        suffixIcon: _checking
                            ? const Padding(padding: EdgeInsets.all(12),
                                child: SizedBox(width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00D1FF))))
                            : _isAvailable == true
                                ? const Icon(Icons.verified_user_rounded, color: Color(0xFF00E676))
                                : _isAvailable == false
                                    ? const Icon(Icons.block_rounded, color: Color(0xFFFF6B6B))
                                    : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        // enabled border changes colour based on availability result 
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _hasText 
                              ? (_isAvailable == true 
                                ? const Color(0xFF00E676) 
                                : _isAvailable == false 
                                  ? const Color(0xFFFF6B6B) 
                                  : const Color(0xFF00D1FF)) 
                              : Colors.transparent,
                            width: 2
                          )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _isAvailable == true 
                              ? const Color(0xFF00E676) 
                              : _isAvailable == false 
                                ? const Color(0xFFFF6B6B) 
                                : const Color(0xFF00D1FF),
                            width: 2
                          )),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12
                        ),
                      ),
                      onSubmitted: (_) => _next(), // allow submit via keyboard
                    ),
                    const SizedBox(height: 12),
                    // ----- suggestion usernames -----
                    // tapping gills the text field
                    Text('SUGGESTED CODENAMES',
                      style: GoogleFonts.fredoka(color: Colors.white38, fontSize: 11, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    // render username suggestions in a 2-row x 3-column grid 
                    Column(
                      children: [
                        for (int row = 0; row < 2; row++) ...[
                          if (row > 0) const SizedBox(height: 6),
                          Row(
                            children: List.generate(3, (col) {
                              final e = _suggestions[row * 3 + col];
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: col > 0 ? 6 : 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      SoundService.playClick();
                                      // fill field and move cursor to end
                                      _ctrl.text = e;
                                      _ctrl.selection = TextSelection.fromPosition(TextPosition(offset: e.length));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00D1FF).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: const Color(0xFF00D1FF).withValues(alpha: 0.3)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(e,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredoka(color: const Color(0xFF00D1FF), fontWeight: FontWeight.w600, fontSize: 12.5)),
                                      ),
                                    // staggered scale-in animation 
                                  ).animate().scale(delay: Duration(milliseconds: (row * 3 + col) * 60)),
                                ),
                              );
                            }),
                          ),
                        ],
                      ],
                    ),
                  ]),
                ),
              ).animate().fade().slideY(begin: 0.3),
              const SizedBox(height: 14),

              // ----- begin mission button -----
              // glow when the user can proceed
              SizedBox(
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _glowAnim,
                  builder: (_, child) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      // only show the glow when the button is active 
                      boxShadow: _hasText && _isAvailable != false
                          ? [BoxShadow(color: const Color(0xFF00D1FF).withValues(alpha: 0.4 * _glowAnim.value), blurRadius: 20, spreadRadius: 1)]
                          : [],
                    ),
                    child: child,
                  ),
                  child: ElevatedButton(
                    // disbaled when there is no text, username is taken, or navigating
                    onPressed: _hasText && _isAvailable != false && !_navigating ? _next : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D1FF),
                      disabledBackgroundColor: const Color(0xFF00D1FF).withValues(alpha: 0.3),
                      foregroundColor: const Color(0xFF0D1117),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                    ),
                    // show spinner while navigating otherwise show label and icon 
                    child: _navigating
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(color: Color(0xFF0D1117), strokeWidth: 2.5))
                        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Icon(Icons.rocket_launch_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text('Begin Mission →', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700)),
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