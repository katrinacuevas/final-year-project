// ========================================================================
// loading_dots.dart
// ------------------------------------------------------------------------
// animated three-dot loading indicator
// dots bounce in sequence using a single looping AnimationController
// ========================================================================

import 'package:flutter/material.dart';

// ----- loading dots widget -----
// shown during async operations like username availability checks
class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // one controller drives all three dots — staggering is done via index offset below
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          // offset each dot's position in the cycle so they bounce one after another
          final double phase = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
          // fold the 0→1 range into a triangle wave so the dot goes up then back down
          final double bounce = phase < 0.5 ? phase : 1.0 - phase;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            // height and opacity both animate so the jump feels more alive
            height: 8 + bounce * 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6 + bounce * 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
