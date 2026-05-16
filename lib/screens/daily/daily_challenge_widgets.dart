import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DailyCatPanel extends StatefulWidget {
  final Widget button;
  final String message;
  final Color accentColor;
  const DailyCatPanel({super.key, required this.button, required this.message, required this.accentColor});
  @override
  State<DailyCatPanel> createState() => _DailyCatPanelState();
}

class _DailyCatPanelState extends State<DailyCatPanel> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 4500))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161B2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SizedBox(
        height: 180,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(left: 0, right: 0, bottom: 0, child: widget.button),
          Positioned(
            left: -18, bottom: 15,
            child: ClipRect(
              child: SizedBox(
                width: 160, height: 160,
                child: Lottie.asset('assets/animations/cat.json', controller: _ctrl, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            left: 130, bottom: 80,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 210),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1848),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: widget.accentColor.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Text(widget.message,
                style: GoogleFonts.fredoka(fontSize: 13, color: Colors.white, height: 1.45, fontWeight: FontWeight.w500)),
            ),
          ),
        ]),
      ),
    );
  }
}
