import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sound_service.dart';
import 'baiting_theme.dart';

// ─── Cat + Button ─────────────────────────────────────────────────────────────
class BaitingCatButton extends StatefulWidget {
  final Widget button;
  final String message;
  final Color accentColor;
  final bool showBubble;
  final bool showButton;
  const BaitingCatButton({
    super.key,
    required this.button,
    required this.message,
    this.accentColor = kBaitAccent,
    this.showBubble = true,
    this.showButton = true,
  });
  @override
  State<BaitingCatButton> createState() => _BaitingCatButtonState();
}

class _BaitingCatButtonState extends State<BaitingCatButton> with TickerProviderStateMixin {
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
      child: Stack(clipBehavior: Clip.none, children: [
        if (widget.showButton)
          Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
        Positioned(
          left: -18, bottom: widget.showButton ? 15 : 0,
          child: ClipRect(child: SizedBox(width: 160, height: 160,
            child: Lottie.asset('assets/animations/cat.json', controller: _ctrl, fit: BoxFit.contain)))),
        if (widget.showBubble)
          Positioned(
            left: 130, bottom: widget.showButton ? 80 : 50,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 210),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kBaitCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16)),
                border: Border.all(color: widget.accentColor.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [BoxShadow(color: widget.accentColor.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: Text(widget.message,
                style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500)),
            )),
      ]),
    );
  }
}

// ─── Next Button ──────────────────────────────────────────────────────────────
class BaitingNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const BaitingNextButton({super.key, required this.onTap, this.label = 'Next →', this.enabled = true});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? () { SoundService.playClick(); onTap(); } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: kBaitAccent, foregroundColor: Colors.white,
        disabledBackgroundColor: kBaitCard, disabledForegroundColor: Colors.white24,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), elevation: 0),
      child: Text(label, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
    ),
  );
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────
class BaitingProgressBar extends StatelessWidget {
  final int current, total;
  const BaitingProgressBar({super.key, required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('PROGRESS', style: GoogleFonts.fredoka(fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
      Text('$current / $total', style: GoogleFonts.fredoka(fontSize: 11, color: kBaitAccent, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(value: current / total, minHeight: 7,
        backgroundColor: kBaitAccent.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(current == total ? kBaitGreen : kBaitAccent))),
  ]);
}

// ─── Lesson Label ─────────────────────────────────────────────────────────────
class BaitingLessonLabel extends StatelessWidget {
  final String label;
  const BaitingLessonLabel({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.chevron_right_rounded, color: kBaitAccent, size: 16), const SizedBox(width: 4),
    Text(label, style: GoogleFonts.fredoka(color: kBaitAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
  ]);
}

// ─── White Card ───────────────────────────────────────────────────────────────
class BaitingCard extends StatelessWidget {
  final Widget child;
  const BaitingCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: kBaitAccent.withValues(alpha: 0.15)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 3))]),
    child: child,
  );
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class BaitingInfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const BaitingInfoCard({super.key, required this.color, required this.emoji, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
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

// ─── Tip Box ──────────────────────────────────────────────────────────────────
class BaitingTipBox extends StatelessWidget {
  final String text;
  const BaitingTipBox({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kBaitAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kBaitAccent.withValues(alpha: 0.3))),
    child: Row(children: [
      const Text('💡', style: TextStyle(fontSize: 20)), const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

// ─── Trap Row (simple icon + text) ───────────────────────────────────────────
class BaitingTrapRow extends StatelessWidget {
  final String emoji, text;
  const BaitingTrapRow({super.key, required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)), const SizedBox(width: 12),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

// ─── Compare Row ──────────────────────────────────────────────────────────────
class BaitingCompareRow extends StatelessWidget {
  final String emoji, text;
  const BaitingCompareRow({super.key, required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.3))),
    ]),
  );
}

// ─── Red Flag Card ────────────────────────────────────────────────────────────
class BaitingRedFlagCard extends StatelessWidget {
  final String flag, detail;
  const BaitingRedFlagCard({super.key, required this.flag, required this.detail});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kBaitRed.withValues(alpha: 0.3), width: 1.2)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: kBaitRed)),
      const SizedBox(height: 5),
      Text(detail, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
    ]),
  );
}

// ─── Step Card ────────────────────────────────────────────────────────────────
class BaitingStepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const BaitingStepCard({super.key, required this.number, required this.emoji,
    required this.title, required this.body, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.25))),
    child: Row(children: [
      Container(width: 46, height: 46,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 2),
        Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
      ])),
      Container(width: 26, height: 26,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5))),
        child: Center(child: Text(number,
          style: GoogleFonts.fredoka(color: color, fontWeight: FontWeight.w700, fontSize: 12)))),
    ]),
  );
}

// ─── Tappable Step Card ───────────────────────────────────────────────────────
class BaitingTappableCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  final bool isExpanded;
  final VoidCallback onTap;
  const BaitingTappableCard({super.key, required this.number, required this.emoji,
    required this.title, required this.body, required this.color,
    required this.isExpanded, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? color.withValues(alpha: 0.6) : color.withValues(alpha: 0.25),
          width: isExpanded ? 1.8 : 1.2)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 46, height: 46,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3))),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
          const SizedBox(width: 12),
          Expanded(child: Text(title,
            style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: color))),
          Container(width: 26, height: 26,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5))),
            child: Center(child: Icon(
              isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              size: 15, color: color))),
        ]),
        if (isExpanded) ...[
          const SizedBox(height: 10),
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.15))),
            child: Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white70, height: 1.5))),
        ],
      ]),
    ),
  );
}

// ─── Bait Example Card ────────────────────────────────────────────────────────
class BaitingExampleCard extends StatelessWidget {
  final String emoji, title, baitMsg, why;
  final Color color;
  const BaitingExampleCard({super.key, required this.emoji, required this.title,
    required this.baitMsg, required this.why, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: kBaitCard, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.4))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.3)))),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)), const SizedBox(width: 10),
          Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        ])),
      Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: kBaitRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBaitRed.withValues(alpha: 0.4), width: 1.2)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🚨 ', style: TextStyle(fontSize: 14)),
            Expanded(child: Text('"$baitMsg"',
              style: GoogleFonts.fredoka(fontSize: 13, color: kBaitRed, fontStyle: FontStyle.italic, height: 1.4))),
          ])),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('⚠️ ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(why, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4))),
        ]),
      ])),
    ]),
  );
}

// ─── Summary Tile ─────────────────────────────────────────────────────────────
class BaitingSummaryTile extends StatelessWidget {
  final String emoji, text;
  const BaitingSummaryTile({super.key, required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
      const Icon(Icons.check_circle_rounded, color: kBaitGreen, size: 18),
    ]),
  );
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────
class BaitingGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kBaitCyan.withValues(alpha: 0.04)..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint); }
    for (double y = 0; y < size.height; y += spacing) { canvas.drawLine(Offset(0, y), Offset(size.width, y), paint); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}