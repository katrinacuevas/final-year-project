import 'package:flutter/material.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const Color kPhishingAccent = Color(0xFF4FC3F7);
const Color kPhishingBg     = Color(0xFF0D1117);
const Color kPhishingCard   = Color(0xFF161B2E);
const Color kPhishingCyan   = Color(0xFF00D1FF);
const Color kPhishingGreen  = Color(0xFF00E676);
const Color kPhishingRed    = Color(0xFFFF5252);

// ─── Theme Constants ──────────────────────────────────────────────────────────
class PhishingTheme {
  static const Color accent = kPhishingAccent;
  static const Color bg = kPhishingBg;
  static const Color card = kPhishingCard;
  static const Color cyan = kPhishingCyan;
  static const Color green = kPhishingGreen;
  static const Color red = kPhishingRed;
}

// ─── Screen Constants ──────────────────────────────────────────────────────────
class PhishingScreenConstants {
  static const int totalSteps = 6;
  static const int lessonIntroStep = 0;
  static const int lesson1Step = 1;
  static const int lesson2Step = 2;
  static const int lesson3Step = 3;
  static const int lesson4Step = 4;
  static const int chatSimStep = 5;
  static const int quizStep = 6;
  static const int completeStep = 7;
}