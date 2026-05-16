// ========================================================================
// pretexting_widgets.dart
// ------------------------------------------------------------------------
// shared UI components for the pretexting lesson
// imported by pretexting_lessons, pretexting_quiz and pretexting_chat_sim
// ========================================================================

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/sound_service.dart';
import 'pretexting_theme.dart';

// ----- cat + button -----
class PretextingCatButton extends StatefulWidget {
  final Widget button;
  final String message;
  final Color accentColor;
  final bool showBubble;
  final bool showButton;
  const PretextingCatButton({
    super.key,
    required this.button,
    required this.message,
    this.accentColor = kPretextAccent,
    this.showBubble = true,
    this.showButton = true,
  });
  @override
  State<PretextingCatButton> createState() => _PretextingCatButtonState();
}

class _PretextingCatButtonState extends State<PretextingCatButton>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4500))
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
      child: Stack(clipBehavior: Clip.none, children: [
        if (widget.showButton)
          Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
        Positioned(
          left: -18,
          bottom: widget.showButton ? 15 : 0,
          child: ClipRect(
            child: SizedBox(
              width: 160,
              height: 160,
              child: Lottie.asset('assets/animations/cat.json',
                  controller: _ctrl, fit: BoxFit.contain),
            ),
          ),
        ),
        if (widget.showBubble)
          Positioned(
            left: 130,
            bottom: widget.showButton ? 80 : 50,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 210),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kPretextCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.5),
                    width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Text(
                widget.message,
                style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.45,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ]),
    );
  }
}

// ----- next button -----
class PretextingNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const PretextingNextButton(
      {super.key,
      required this.onTap,
      this.label = 'Next →',
      this.enabled = true});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled
              ? () {
                  SoundService.playClick();
                  onTap();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPretextAccent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: kPretextCard,
            disabledForegroundColor: Colors.white24,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: Text(label,
              style: GoogleFonts.fredoka(
                  fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      );
}

// ----- progress bar -----
class PretextingProgressBar extends StatelessWidget {
  final int current, total;
  const PretextingProgressBar(
      {super.key, required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('PROGRESS',
              style: GoogleFonts.fredoka(
                  fontSize: 10, color: Colors.white38, letterSpacing: 1.0)),
          Text('$current / $total',
              style: GoogleFonts.fredoka(
                  fontSize: 11,
                  color: kPretextAccent,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 7,
            backgroundColor: kPretextAccent.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
                current == total ? kPretextGreen : kPretextAccent),
          ),
        ),
      ]);
}

// ----- lesson label -----
class PretextingLessonLabel extends StatelessWidget {
  final String label;
  const PretextingLessonLabel({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
        const Icon(Icons.chevron_right_rounded,
            color: kPretextAccent, size: 16),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.fredoka(
                color: kPretextAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2)),
      ]);
}

// ----- card -----
class PretextingCard extends StatelessWidget {
  final Widget child;
  const PretextingCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPretextAccent.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: child,
      );
}

// ----- info card -----
class PretextingInfoCard extends StatelessWidget {
  final Color color;
  final String emoji, title, body;
  const PretextingInfoCard(
      {super.key,
      required this.color,
      required this.emoji,
      required this.title,
      required this.body});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 3),
            Text(body,
                style: GoogleFonts.fredoka(
                    fontSize: 13, color: Colors.white54, height: 1.4)),
          ])),
        ]),
      );
}

class PretextingStoryStep {
  final String emoji, speaker, text;
  final bool isDanger;
  const PretextingStoryStep(
      {required this.emoji,
      required this.speaker,
      required this.text,
      this.isDanger = false});
}

class PretextingStoryPanel extends StatelessWidget {
  final List<PretextingStoryStep> steps;
  const PretextingStoryPanel({super.key, required this.steps});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kPretextAccent.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: steps.asMap().entries.map((e) {
            final s = e.value;
            final isLast = e.key == steps.length - 1;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: s.isDanger
                          ? kPretextRed.withValues(alpha: 0.15)
                          : kPretextAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: s.isDanger
                              ? kPretextRed.withValues(alpha: 0.4)
                              : kPretextAccent.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                        child: Text(s.emoji,
                            style: const TextStyle(fontSize: 18))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(s.speaker,
                            style: GoogleFonts.fredoka(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: s.isDanger
                                    ? kPretextRed
                                    : kPretextAccent)),
                        const SizedBox(height: 3),
                        Text(s.text,
                            style: GoogleFonts.fredoka(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.4)),
                      ])),
                ]),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.only(left: 33),
                  child: Icon(Icons.arrow_downward,
                      color: Color(0xFF2A3A55), size: 16),
                ),
            ]);
          }).toList(),
        ),
      );
}

class PretextingFakeIDCard extends StatelessWidget {
  final String emoji, role, script, clue;
  final Color color;
  const PretextingFakeIDCard(
      {super.key,
      required this.emoji,
      required this.role,
      required this.script,
      required this.clue,
      required this.color});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              border:
                  Border(bottom: BorderSide(color: color.withValues(alpha: 0.3))),
            ),
            child: Row(children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(role,
                  style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPretextAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: kPretextAccent.withValues(alpha: 0.3), width: 1.2),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('🎭 ', style: TextStyle(fontSize: 14)),
                  Expanded(
                      child: Text('"$script"',
                          style: GoogleFonts.fredoka(
                              fontSize: 13,
                              color: kPretextPurple,
                              fontStyle: FontStyle.italic,
                              height: 1.4))),
                ]),
              ),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🔍 ', style: TextStyle(fontSize: 14)),
                Expanded(
                    child: Text(clue,
                        style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.white54,
                            height: 1.4))),
              ]),
            ]),
          ),
        ]),
      );
}

class PretextingEmailMockup extends StatelessWidget {
  final String from, subject, body;
  final bool isReal;
  const PretextingEmailMockup(
      {super.key,
      required this.from,
      required this.subject,
      required this.body,
      required this.isReal});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isReal
              ? kPretextGreen.withValues(alpha: 0.08)
              : kPretextRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isReal
                ? kPretextGreen.withValues(alpha: 0.4)
                : kPretextRed.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(isReal ? Icons.check_circle : Icons.warning,
                color: isReal ? kPretextGreen : kPretextRed, size: 14),
            const SizedBox(width: 5),
            Text(isReal ? 'Looks real ✅' : 'Fake! ❌',
                style: GoogleFonts.fredoka(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isReal ? kPretextGreen : kPretextRed)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Text('From: ',
                style: GoogleFonts.fredoka(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white38)),
            Expanded(
                child: Text(from,
                    style: GoogleFonts.fredoka(
                        fontSize: 11,
                        color: isReal ? Colors.white70 : kPretextRed,
                        fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 3),
          Row(children: [
            Text('Subject: ',
                style: GoogleFonts.fredoka(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white38)),
            Expanded(
                child: Text(subject,
                    style: GoogleFonts.fredoka(
                        fontSize: 11, color: Colors.white70))),
          ]),
          const SizedBox(height: 6),
          Text(body,
              style: GoogleFonts.fredoka(
                  fontSize: 12, color: Colors.white54, height: 1.4)),
        ]),
      );
}

// ----- step card, pause rule ----- 
class PretextingStepCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const PretextingStepCard(
      {super.key,
      required this.number,
      required this.emoji,
      required this.title,
      required this.body,
      required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kPretextCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: GoogleFonts.fredoka(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 2),
            Text(body,
                style: GoogleFonts.fredoka(
                    fontSize: 12, color: Colors.white54, height: 1.4)),
          ])),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Center(
                child: Text(number,
                    style: GoogleFonts.fredoka(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12))),
          ),
        ]),
      );
}

// ----- taappable card -----
class PretextingTappableCard extends StatelessWidget {
  final String emoji, title, body;
  final Color color;
  final bool isExpanded;
  final VoidCallback onTap;
  const PretextingTappableCard(
      {super.key,
      required this.emoji,
      required this.title,
      required this.body,
      required this.color,
      required this.isExpanded,
      required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kPretextCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExpanded
                  ? color.withValues(alpha: 0.6)
                  : color.withValues(alpha: 0.25),
              width: isExpanded ? 1.8 : 1.2,
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Center(
                    child:
                        Text(emoji, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(title,
                      style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color))),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Center(
                    child: Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 15,
                  color: color,
                )),
              ),
            ]),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.15)),
                ),
                child: Text(body,
                    style: GoogleFonts.fredoka(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.5)),
              ),
            ],
          ]),
        ),
      );
}

// ----- summary tile -----
class PretextingSummaryTile extends StatelessWidget {
  final String emoji, text;
  const PretextingSummaryTile(
      {super.key, required this.emoji, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.fredoka(
                      fontSize: 13, color: Colors.white54, height: 1.4))),
          const Icon(Icons.check_circle_rounded,
              color: kPretextGreen, size: 18),
        ]),
      );
}

class PretextingGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPretextCyan.withValues(alpha: 0.04)
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
