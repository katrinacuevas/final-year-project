import 'package:flutter/material.dart';

enum DifficultyLevel { easy, medium, hard }

extension DifficultyLevelX on DifficultyLevel {
  String get label {
    switch (this) {
      case DifficultyLevel.easy:   return 'Beginner';
      case DifficultyLevel.medium: return 'Detective';
      case DifficultyLevel.hard:   return 'Expert';
    }
  }

  String get emoji {
    switch (this) {
      case DifficultyLevel.easy:   return '🌱';
      case DifficultyLevel.medium: return '🔥';
      case DifficultyLevel.hard:   return '⚡';
    }
  }

  Color get color {
    switch (this) {
      case DifficultyLevel.easy:   return const Color(0xFF00E676);
      case DifficultyLevel.medium: return const Color(0xFFFFC857);
      case DifficultyLevel.hard:   return const Color(0xFFFF5252);
    }
  }
}
