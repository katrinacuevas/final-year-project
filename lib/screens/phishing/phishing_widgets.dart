import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../services/sound_service.dart';
import 'phishing_theme.dart';

// ─── Cat + Button (Phishing-flavoured) ────────────────────────────────────────
class PhishingCatButton extends StatefulWidget {
  final Widget button;
  final String message;
  final bool showBubble;
  final bool showButton;
  const PhishingCatButton({
    super.key,
    required this.button,
    required this.message,
    this.showBubble = true,
    this.showButton = true,
  });
  @override
  State<PhishingCatButton> createState() => _PhishingCatButtonState();
}

class _PhishingCatButtonState extends State<PhishingCatButton>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.showButton ? 180 : 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.showButton)
            Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
          // Cat — always visible
          Positioned(
            left: -18,
            bottom: widget.showButton ? 15 : 0,
            child: ClipRect(
              child: SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/animations/cat.json',
                  controller: _ctrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Speech bubble
          if (widget.showBubble)
            Positioned(
              left: 130,
              bottom: widget.showButton ? 80 : 50,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 210),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kPhishingCard,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: kPhishingAccent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPhishingAccent.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Next Button ──────────────────────────────────────────────────────────────
class PhishingNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const PhishingNextButton({
    required this.onTap,
    this.label = 'Next →',
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: enabled ? () { SoundService.playClick(); onTap(); } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPhishingAccent,
        foregroundColor: Colors.white,
        disabledBackgroundColor: kPhishingCard,
        disabledForegroundColor: Colors.white24,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: Text(label, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700)),
    ),
  );
}

// ─── Dark Card ────────────────────────────────────────────────────────────────
class PhishingDarkCard extends StatelessWidget {
  final Widget child;
  const PhishingDarkCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: kPhishingCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: kPhishingAccent.withValues(alpha: 0.2)),
    ),
    child: child,
  );
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class PhishingInfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const PhishingInfoCard({
    required this.color,
    required this.emoji,
    required this.title,
    required this.body,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 26)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4)),
      ])),
    ]),
  );
}

// ─── Tip Box ──────────────────────────────────────────────────────────────────
class PhishingTipBox extends StatelessWidget {
  final String text;
  const PhishingTipBox({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: kPhishingAccent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kPhishingAccent.withValues(alpha: 0.25)),
    ),
    child: Row(children: [
      const Text('💡', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

// ─── Red Flag Card ────────────────────────────────────────────────────────────
class PhishingRedFlagCard extends StatelessWidget {
  final String flag, detail;
  const PhishingRedFlagCard({required this.flag, required this.detail});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: kPhishingCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kPhishingRed.withValues(alpha: 0.25)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(flag, style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: kPhishingRed)),
      const SizedBox(height: 5),
      Text(detail, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
    ]),
  );
}

// ─── Step Card ────────────────────────────────────────────────────────────────
class PhishingStepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const PhishingStepCard({
    required this.number,
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: kPhishingCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.25)),
    ),
    child: Row(children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
      ])),
      Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Center(child: Text(number,
          style: GoogleFonts.fredoka(color: color, fontWeight: FontWeight.w700, fontSize: 12))),
      ),
    ]),
  );
}

// ─── Email Card ───────────────────────────────────────────────────────────────
class PhishingEmailCard extends StatelessWidget {
  final String from, subject, body, clue;
  final bool isReal;
  const PhishingEmailCard({
    required this.from,
    required this.subject,
    required this.body,
    required this.clue,
    required this.isReal,
  });
  @override
  Widget build(BuildContext context) {
    final Color c = isReal ? kPhishingGreen : kPhishingRed;
    return Container(
      decoration: BoxDecoration(
        color: kPhishingCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Icon(isReal ? Icons.check_circle_rounded : Icons.warning_rounded, color: c, size: 14),
            const SizedBox(width: 6),
            Text(isReal ? '✅ Looks legitimate' : '❌ Suspicious',
              style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('From: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
              Expanded(child: Text(from, style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: c))),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Text('Subject: ', style: GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white38)),
              Expanded(child: Text(subject, style: GoogleFonts.fredoka(fontSize: 11, color: Colors.white70))),
            ]),
            const SizedBox(height: 8),
            Text(body, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white54, height: 1.4)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🔍 ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(clue, style: GoogleFonts.fredoka(fontSize: 12, color: c, height: 1.4))),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Link Row ─────────────────────────────────────────────────────────────────
class PhishingLinkRow extends StatelessWidget {
  final String label, link;
  final bool safe;
  const PhishingLinkRow({required this.label, required this.link, required this.safe});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      SizedBox(width: 24, child: Text(label, style: const TextStyle(fontSize: 14))),
      const SizedBox(width: 8),
      Expanded(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: (safe ? kPhishingGreen : kPhishingRed).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(link, style: GoogleFonts.fredoka(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: safe ? kPhishingGreen : kPhishingRed,
        )),
      )),
    ]),
  );
}

// ─── Simple Row ───────────────────────────────────────────────────────────────
class PhishingSimpleRow extends StatelessWidget {
  final String emoji, text;
  const PhishingSimpleRow({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.4))),
    ]),
  );
}

// ─── Summary Tile ──────────────────────────────────────────────────────────────
class PhishingSummaryTile extends StatelessWidget {
  final String emoji, text;
  const PhishingSummaryTile({required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white54, height: 1.4))),
      const Icon(Icons.check_circle_rounded, color: kPhishingGreen, size: 18),
    ]),
  );
}

// ─── Lesson Progress Bar ──────────────────────────────────────────────────────
class PhishingLessonProgressBar extends StatelessWidget {
  final int current, total;
  const PhishingLessonProgressBar({required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('PROGRESS', style: GoogleFonts.fredoka(fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
      Text('$current / $total', style: GoogleFonts.fredoka(fontSize: 11, color: kPhishingAccent, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 6),
    ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: current / total,
        minHeight: 7,
        backgroundColor: kPhishingCyan.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(current == total ? kPhishingGreen : kPhishingCyan),
      ),
    ),
  ]);
}

// ─── Lesson Label ─────────────────────────────────────────────────────────────
class PhishingLessonLabel extends StatelessWidget {
  final String label;
  const PhishingLessonLabel({required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.chevron_right_rounded, color: kPhishingAccent, size: 16),
    const SizedBox(width: 4),
    Text(label, style: GoogleFonts.fredoka(color: kPhishingAccent, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
  ]);
}

// ─── Tappable Step Card (for Lesson 3) ────────────────────────────────────────
class PhishingTappableStepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  final bool isExpanded;
  final VoidCallback onTap;
  const PhishingTappableStepCard({
    required this.number,
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPhishingCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded ? color.withValues(alpha: 0.6) : color.withValues(alpha: 0.25),
            width: isExpanded ? 1.8 : 1.2,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title,
              style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w700, color: color))),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Center(child: Icon(
                isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                size: 16,
                color: color,
              )),
            ),
          ]),
          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.15)),
              ),
              child: Text(body, style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white70, height: 1.5)),
            ),
          ],
        ]),
      ),
    );
  }
}

// ─── Grid Painter (background) ────────────────────────────────────────────────
class PhishingGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = kPhishingAccent.withValues(alpha: 0.04)..strokeWidth = 1;
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