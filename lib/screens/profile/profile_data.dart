// ========================================================================
// profile_data.dart
// ------------------------------------------------------------------------
// course progress data and safety rules shown on the profile screen
// ========================================================================

import 'package:flutter/material.dart';

const List<Map<String, dynamic>> profileCourses = [
  {
    'lessonId': 'password_power',
    'title': 'Password Power',
    'emoji': '🔐',
    'accentColor': Color(0xFFFFC857),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key', 'desc': 'Started your first lesson'},
      {'step': 3, 'emoji': '🛡️', 'name': 'Shield Up', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'emoji': '🎣',
    'accentColor': Color(0xFF4FC3F7),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes', 'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Super Sleuth', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'emoji': '🎁',
    'accentColor': Color(0xFFFF8A65),
    'totalSteps': 6,
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious', 'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster', 'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting',
    'emoji': '🎭',
    'accentColor': Color(0xFFBA68C8),
    'totalSteps': 5,
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious', 'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off', 'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

const List<Map<String, String>> safetyRules = [
  {
    'icon': '🔒',
    'title': 'Keep passwords strong & private',
    'detail': 'Use a mix of letters, numbers and symbols. Never share your password with anyone — not even friends.',
  },
  {
    'icon': '🎣',
    'title': 'Spot fake messages',
    'detail': 'If a message asks you to click a link urgently or give personal info, it might be phishing. Always check with a trusted adult.',
  },
  {
    'icon': '🎁',
    'title': 'If it seems too good, it probably is',
    'detail': "Free prizes, gift cards, and \"you've won!\" messages are almost always scams designed to trick you.",
  },
  {
    'icon': '🎭',
    'title': "Verify who you're talking to",
    'detail': 'Anyone can pretend to be someone else online. Always verify identities before sharing personal information.',
  },
  {
    'icon': '👨‍👩‍👧',
    'title': 'Tell a trusted adult',
    'detail': 'If anything online makes you feel uncomfortable or confused, always tell a parent, guardian or teacher straight away.',
  },
];
