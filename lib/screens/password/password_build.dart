// ========================================================================
// password_build.dart
// ------------------------------------------------------------------------
// interactive password builder step in the password lesson
// user constructs a strong password and the cat rates it in real time
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'password_cat_messages.dart';
import 'password_theme.dart';
import 'password_widgets.dart';

class BuildPasswordStep extends StatefulWidget {
  final VoidCallback onComplete;
  const BuildPasswordStep({super.key, required this.onComplete});
  @override
  State<BuildPasswordStep> createState() => _BuildPasswordStepState();
}

class _BuildPasswordStepState extends State<BuildPasswordStep> {
  final TextEditingController controller = TextEditingController();
  bool obscure = true;

  bool get hasLength => controller.text.length >= 12;
  bool get hasUpper  => controller.text.contains(RegExp(r'[A-Z]'));
  bool get hasLower  => controller.text.contains(RegExp(r'[a-z]'));
  bool get hasNumber => controller.text.contains(RegExp(r'[0-9]'));
  bool get hasSymbol => controller.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;~/`]'));

  int get score => [hasLength, hasUpper, hasLower, hasNumber, hasSymbol].where((b) => b).length;
  bool get canProceed => score >= 5;

  String get strengthLabel {
    if (controller.text.isEmpty) return 'Start typing...';
    if (score <= 1) return 'Very Weak 😬';
    if (score == 2) return 'Weak 😕';
    if (score == 3) return 'Getting Better 🙂';
    if (score == 4) return 'Strong 💪';
    return 'Super Strong! 🔥';
  }

  Color get strengthColor {
    if (controller.text.isEmpty) return Colors.white12;
    if (score <= 1) return kPasswordRed;
    if (score == 2) return const Color(0xFFFF8A65);
    if (score == 3) return kPasswordAccent;
    if (score == 4) return kPasswordGreen;
    return kPasswordGreen;
  }

  String get _catMessage {
    if (!hasLength) return PasswordCatMessages.buildHints['length']!;
    if (!hasUpper)  return PasswordCatMessages.buildHints['upper']!;
    if (!hasLower)  return PasswordCatMessages.buildHints['lower']!;
    if (!hasNumber) return PasswordCatMessages.buildHints['number']!;
    if (!hasSymbol) return PasswordCatMessages.buildHints['symbol']!;
    return PasswordCatMessages.buildHints['strong']!;
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const LessonLabel(label: 'BUILD YOUR OWN PASSWORD'),
        const SizedBox(height: 6),
        Text('Use everything you\'ve learned! It needs to pass all 5 rules.',
          style: GoogleFonts.fredoka(fontSize: 14, color: Colors.white54, height: 1.4)),
        const SizedBox(height: 20),

        // Password input + strength meter
        Container(padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Type your password:',
              style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 10),
            TextField(
              controller: controller, obscureText: obscure,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Colors.white),
              decoration: InputDecoration(
                hintText: r'e.g. Fluffy$Pizza!Rocket7',
                hintStyle: GoogleFonts.fredoka(fontSize: 14, color: Colors.white24, fontWeight: FontWeight.w400, letterSpacing: 0),
                filled: true, fillColor: kPasswordBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kPasswordAccent, width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white38),
                  onPressed: () => setState(() => obscure = !obscure)),
              ),
            ),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Strength:', style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38)),
              AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 200),
                style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w700, color: strengthColor),
                child: Text(strengthLabel)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: controller.text.isEmpty ? 0 : score / 5, minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: AlwaysStoppedAnimation<Color>(strengthColor))),
          ])),

        const SizedBox(height: 16),

        // ----- rules checklist ----- 
        Container(padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: kPasswordCard, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kPasswordAccent.withValues(alpha: 0.15))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Rules checklist:',
              style: GoogleFonts.fredoka(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54)),
            const SizedBox(height: 12),
            CheckRow(label: 'At least 12 characters long', passed: hasLength),
            const SizedBox(height: 8),
            CheckRow(label: 'Has UPPERCASE letters', passed: hasUpper),
            const SizedBox(height: 8),
            CheckRow(label: 'Has lowercase letters', passed: hasLower),
            const SizedBox(height: 8),
            CheckRow(label: 'Has numbers (0–9)', passed: hasNumber),
            const SizedBox(height: 8),
            CheckRow(label: r'Has symbols (! @ # $ % etc.)', passed: hasSymbol),
          ])),

        const SizedBox(height: 28),
        if (controller.text.isNotEmpty)
          PasswordCatButton(
            button: PasswordNextButton(onTap: widget.onComplete, enabled: canProceed, label: 'Take the Quiz! 🎯'),
            message: _catMessage,
            accentColor: canProceed ? kPasswordGreen : strengthColor,
          )
        else
          PasswordNextButton(onTap: widget.onComplete, enabled: canProceed, label: 'Take the Quiz! 🎯'),
        if (!canProceed)
          Padding(padding: const EdgeInsets.only(top: 10),
            child: Center(child: Text('Complete all 5 rules to continue',
              style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white24)))),
      ]),
    );
  }
}