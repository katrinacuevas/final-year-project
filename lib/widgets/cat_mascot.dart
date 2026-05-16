// ========================================================================
// cat_mascot.dart
// ------------------------------------------------------------------------
// the app mascot cat widget — three variants available:
//  - catMascot, inline cat with optional speech bubble above
//  - catMascotOverlay, full bottom sheet overlay with tap-to-dismiss
//  - inlineCatBanner, horizontal card with bouncing cat and message text
// ========================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

const Color _kBg   = Color(0xFF0D1117);
const Color _kCard = Color(0xFF161B2E);
const Color _kCyan = Color(0xFF00D1FF);

// ----- cat mood enum -----
enum CatMood { happy, excited, thinking, proud, sad, cheeky }

// ----- cat mascot -----
class CatMascot extends StatefulWidget {
  final String message;
  final Color accentColor;
  final CatMood mood;
  final double size;
  final bool showSpeechBubble;
  final VoidCallback? onTap;

  const CatMascot({
    super.key,
    required this.message,
    this.accentColor = _kCyan,
    this.mood = CatMood.happy,
    this.size = 90,
    this.showSpeechBubble = true,
    this.onTap,
  });

  @override
  State<CatMascot> createState() => _CatMascotState();
}

class _CatMascotState extends State<CatMascot> with TickerProviderStateMixin {
  late AnimationController _lottieCtrl;

  @override
  void initState() {
    super.initState();
    // keep the lottie looping indefinitely so the cat is always animated
    _lottieCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _lottieCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ----- speech bubble -----
        // only rendered when showSpeechBubble is true — some screens (e.g. username)
        // build their own inline bubble to set its exact position
        if (widget.showSpeechBubble) ...[
          _SpeechBubble(message: widget.message, accentColor: widget.accentColor)
              .animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 4),
          CustomPaint(
            painter: _BubbleTailPainter(color: widget.accentColor.withValues(alpha: 0.4)),
            size: const Size(16, 10),
          ),
          const SizedBox(height: 2),
        ],
        // ----- cat lottie -----
        GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Lottie.asset(
              'assets/animations/cat.json',
              controller: _lottieCtrl,
              fit: BoxFit.contain,
            ),
          ),
        ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
      ],
    );
  }
}

// ----- speech bubble -----
class _SpeechBubble extends StatelessWidget {
  final String message;
  final Color accentColor;
  const _SpeechBubble({required this.message, required this.accentColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: _kCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.5),
      boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500),
    ),
  );
}

// ----- bubble tail painter -----
class _BubbleTailPainter extends CustomPainter {
  final Color color;
  const _BubbleTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2 - 6, 0)
      ..lineTo(size.width / 2 + 6, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// ----- cat mascot overlay -----
class CatMascotOverlay extends StatefulWidget {
  final String message;
  final Color accentColor;
  final CatMood mood;
  final VoidCallback? onDismiss;
  final bool autoDismiss;
  final Duration autoDismissAfter;

  const CatMascotOverlay({
    super.key,
    required this.message,
    this.accentColor = _kCyan,
    this.mood = CatMood.happy,
    this.onDismiss,
    this.autoDismiss = false,
    this.autoDismissAfter = const Duration(seconds: 4),
  });

  // ----- static show helper -----
  // mirrors the pattern used in BadgeUnlock and XpAward so call sites are consistent
  static Future<void> show(
    BuildContext context, {
    required String message,
    Color accentColor = _kCyan,
    CatMood mood = CatMood.happy,
    bool autoDismiss = true,
    Duration autoDismissAfter = const Duration(seconds: 4),
  }) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CatMascotOverlay(
        message: message,
        accentColor: accentColor,
        mood: mood,
        autoDismiss: autoDismiss,
        autoDismissAfter: autoDismissAfter,
      ),
    );
  }

  @override
  State<CatMascotOverlay> createState() => _CatMascotOverlayState();
}

class _CatMascotOverlayState extends State<CatMascotOverlay> {
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    // start the countdown if auto-dismiss is requested, cancelled on manual tap
    if (widget.autoDismiss) {
      _dismissTimer = Timer(widget.autoDismissAfter, () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      _dismissTimer?.cancel();
      Navigator.pop(context);
      widget.onDismiss?.call();
    },
    child: Container(
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: widget.accentColor.withValues(alpha: 0.35), width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // drag handle
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: widget.accentColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
        CatMascot(
          message: widget.message,
          accentColor: widget.accentColor,
          mood: widget.mood,
          size: 110,
        ),
        const SizedBox(height: 20),
        Text('Tap anywhere to continue',
          style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white24)),
      ]),
    ),
  );
}


// ----- inline cat banner -----
class InlineCatBanner extends StatefulWidget {
  final String message;
  final Color accentColor;
  final CatMood mood;
  final double catSize;

  const InlineCatBanner({
    super.key,
    required this.message,
    this.accentColor = _kCyan,
    this.mood = CatMood.happy,
    this.catSize = 70,
  });

  @override
  State<InlineCatBanner> createState() => _InlineCatBannerState();
}

class _InlineCatBannerState extends State<InlineCatBanner> with TickerProviderStateMixin {
  // ----- bounce animation -----
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;
  late AnimationController _lottieCtrl;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );
    _lottieCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _lottieCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _kCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: widget.accentColor.withValues(alpha: 0.3)),
      boxShadow: [BoxShadow(color: widget.accentColor.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: Row(children: [
      AnimatedBuilder(
        animation: _bounceAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _bounceAnim.value),
          child: child,
        ),
        child: SizedBox(
          width: widget.catSize,
          height: widget.catSize,
          child: Lottie.asset('assets/animations/cat.json', controller: _lottieCtrl, fit: BoxFit.contain),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Text(
          widget.message,
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500),
        ),
      ),
    ]),
  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05);
}
