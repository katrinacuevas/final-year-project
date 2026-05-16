// ========================================================================
// password_widgets.dart
// ------------------------------------------------------------------------
// shared UI components for the password lesson 
// imported by password_lessons, password_quiz and password_build
// ========================================================================

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sound_service.dart';
import 'password_theme.dart';

// ----- cat + button -----
class PasswordCatButton extends StatefulWidget {
  final Widget button;
  final String message;
  final Color accentColor;
  final bool showBubble;
  final bool showButton;
  const PasswordCatButton({
    super.key,
    required this.button,
    required this.message,
    this.accentColor = kPasswordAccent,
    this.showBubble = true,
    this.showButton = true,
  });
  @override
  State<PasswordCatButton> createState() => _PasswordCatButtonState();
}

class _PasswordCatButtonState extends State<PasswordCatButton> with TickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.showButton ? 180 : 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.showButton)
            Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
          Positioned(
            left: -18,
            bottom: widget.showButton ? 15 : 0,
            child: ClipRect(
              child: SizedBox(
                width: 160, height: 160,
                child: Lottie.asset('assets/animations/cat.json', controller: _ctrl, fit: BoxFit.contain),
              ),
            ),
          ),
          if (widget.showBubble)
            Positioned(
              left: 130,
              bottom: widget.showButton ? 80 : 50,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 210),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kPasswordCard,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: widget.accentColor.withValues(alpha: 0.5), width: 1.5),
                  boxShadow: [BoxShadow(color: widget.accentColor.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Text(widget.message,
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }
}

// ----- next button -----
class PasswordNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const PasswordNextButton({super.key, required this.onTap, this.label = 'Next →', this.enabled = true});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? () { SoundService.playClick(); onTap(); } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPasswordAccent, foregroundColor: kPasswordBg,
        disabledBackgroundColor: kPasswordCard, disabledForegroundColor: Colors.white24,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), elevation: 0),
      child: Text(label, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
    ),
  );
}

// ----- lesson progress bar -----
class LessonProgressBar extends StatelessWidget {
  final int current, total;
  const LessonProgressBar({super.key, required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('PROGRESS', style: GoogleFonts.fredoka(fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
      Text('$current / $total', style: GoogleFonts.fredoka(fontSize: 11, color: kPasswordAccent, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(value: current / total, minHeight: 7,
        backgroundColor: kPasswordAccent.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(current == total ? kPasswordGreen : kPasswordAccent))),
  ]);
}

// ----- lesson label -----
class LessonLabel extends StatelessWidget {
  final String label;
  const LessonLabel({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.chevron_right_rounded, color: kPasswordAccent, size: 16), const SizedBox(width: 4),
    Text(label, style: GoogleFonts.fredoka(color: kPasswordAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
  ]);
}

// ----- info card -----
class InfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const InfoCard({super.key, required this.color, required this.emoji, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.3))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 26)), const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
      ])),
    ]),
  );
}

// ----- scenario card -----
class ScenarioCard extends StatelessWidget {
  final String emoji, text;
  final bool isBad;
  const ScenarioCard({super.key, required this.emoji, required this.text, required this.isBad});
  @override
  Widget build(BuildContext context) {
    final Color c = isBad ? kPasswordRed : kPasswordGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.35), width: 1.2)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 12),
        Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: c))),
        Icon(isBad ? Icons.cancel_rounded : Icons.check_circle_rounded, color: c, size: 20),
      ]),
    );
  }
}

// ----- weak password -----
class WeakPasswordTile extends StatelessWidget {
  final String password, reason;
  const WeakPasswordTile({super.key, required this.password, required this.reason});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kPasswordRed.withValues(alpha: 0.2))),
    child: Row(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: kPasswordRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kPasswordRed.withValues(alpha: 0.3))),
        child: Text(password, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: kPasswordRed, letterSpacing: 0.5))),
      const SizedBox(width: 12),
      Expanded(child: Text(reason, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54))),
      const Text('❌', style: TextStyle(fontSize: 16)),
    ]),
  );
}

// ----- tappable rule card -----
class TappableRuleCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  final bool isExpanded;
  final VoidCallback onTap;
  const TappableRuleCard({
    super.key,
    required this.number, required this.emoji, required this.title,
    required this.body, required this.color, required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kPasswordCard, borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded ? color.withValues(alpha: 0.6) : color.withValues(alpha: 0.25),
            width: isExpanded ? 1.8 : 1.2),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.3))),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
            const SizedBox(width: 14),
            Expanded(child: Text(title,
              style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color))),
            Container(width: 28, height: 28,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.5))),
              child: Center(child: Icon(
                isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                size: 16, color: color))),
          ]),
          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.15))),
              child: Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.5)),
            ),
          ],
        ]),
      ),
    );
  }
}

class PasswordTag extends StatelessWidget {
  final String label;
  final Color color;
  const PasswordTag({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.35))),
    child: Text(label, style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
  );
}

class WordBubble extends StatelessWidget {
  final String word, emoji;
  const WordBubble({super.key, required this.word, required this.emoji});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(color: kPasswordAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kPasswordAccent.withValues(alpha: 0.25))),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 4),
      Text(word, style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    ]),
  );
}

// ----- summary -----
class SummaryTile extends StatelessWidget {
  final String emoji, text;
  const SummaryTile({super.key, required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
      const Icon(Icons.check_circle_rounded, color: kPasswordGreen, size: 18),
    ]),
  );
}

// ----- Build Password screen -----
class CheckRow extends StatelessWidget {
  final String label;
  final bool passed;
  const CheckRow({super.key, required this.label, required this.passed});
  @override
  Widget build(BuildContext context) => Row(children: [
    AnimatedContainer(duration: const Duration(milliseconds: 300),
      width: 26, height: 26,
      decoration: BoxDecoration(
        color: passed ? kPasswordGreen.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
        shape: BoxShape.circle,
        border: Border.all(color: passed ? kPasswordGreen : Colors.white12, width: 2)),
      child: Icon(passed ? Icons.check_rounded : Icons.remove_rounded, size: 14,
        color: passed ? kPasswordGreen : Colors.white24)),
    const SizedBox(width: 12),
    Text(label, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600,
      color: passed ? Colors.white : Colors.white38)),
  ]);
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kPasswordAccent.withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}