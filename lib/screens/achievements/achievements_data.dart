// ========================================================================
// achievements_data.dart
// ------------------------------------------------------------------------
//  - static data for the achievements system 
//  - defines every course the user can complete, including 
//  - milestones/badges, XP rewards, and accent colours 
// ========================================================================

import 'package:flutter/material.dart';

// ----- course definitions -----
// each entry represents one course in the achievements tab 
// milestones are unlocked as the user completes more steps 
const List<Map<String, dynamic>> achievementCourses = [
  {
    'lessonId': 'password_power', // matches the id used in userService progress
    'title': 'Password Power',
    'subtitle': 'Learning to create super strong, secure passwords!',
    'totalSteps': 6,
    'xpReward': 100,
    // yellow accent 
    'accentColor': Color(0xFFFFC857),
    'courseEmoji': '🔐',
    'milestones': [
      {'step': 1, 'emoji': '🔑', 'name': 'First Key', 'desc': 'Started your first lesson'},
      {'step': 3, 'emoji': '🛡️', 'name': 'Shield Up', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🏅', 'name': 'Password Master', 'desc': 'Completed Password Power!'},
    ],
  },
  {
    'lessonId': 'phishing_detective',
    'title': 'Phishing Detective',
    'subtitle': 'Becoming an expert at spotting fake messages!',
    'totalSteps': 6,
    'xpReward': 150,
    // light blue accent 
    'accentColor': Color(0xFF4FC3F7),
    'courseEmoji': '🎣',
    'milestones': [
      {'step': 1, 'emoji': '👀', 'name': 'Eagle Eyes', 'desc': 'Spotted your first scenario'},
      {'step': 3, 'emoji': '🔎', 'name': 'Detective', 'desc': 'Halfway through the course'},
      {'step': 6, 'emoji': '🕵️', 'name': 'Phish Buster', 'desc': 'Completed Phishing Detective!'},
    ],
  },
  {
    'lessonId': 'baiting_pro',
    'title': 'Baiting Pro',
    'subtitle': 'Investigating suspicious offers that are too good to be true!',
    'totalSteps': 6,
    'xpReward': 200,
    // orange accent 
    'accentColor': Color(0xFFFF8A65),
    'courseEmoji': '🎁',
    'milestones': [
      {'step': 1, 'emoji': '🧐', 'name': 'Suspicious', 'desc': 'Started investigating baiting'},
      {'step': 3, 'emoji': '🚩', 'name': 'Flag Spotter', 'desc': 'Spotted 3 red flags'},
      {'step': 6, 'emoji': '🪤', 'name': 'Trap Buster', 'desc': 'Completed Baiting Pro!'},
    ],
  },
  {
    'lessonId': 'pretexting',
    'title': 'Pretexting Pro',
    'subtitle': 'Learning to spot people who pretend to be someone else!',
    'totalSteps': 5,
    'xpReward': 180,
    // purple accent 
    'accentColor': Color(0xFFBA68C8),
    'courseEmoji': '🎭',
    'milestones': [
      {'step': 1, 'emoji': '🤔', 'name': 'Curious', 'desc': 'Started learning pretexting'},
      {'step': 3, 'emoji': '🎭', 'name': 'Mask Off', 'desc': 'Spotted a fake identity'},
      {'step': 5, 'emoji': '🦸', 'name': 'Identity Hero', 'desc': 'Completed Pretexting!'},
    ],
  },
];

// ----- leaderboard entry model -----
// represents a single user row fetched from Firestore 
// avatarColour is stored as a hex string 
class LeaderboardEntry {
  final String username;
  final String avatarEmoji;
  final String avatarColour;
  final int xp;
  final int level;

  const LeaderboardEntry({
    required this.username,
    required this.avatarEmoji,
    required this.avatarColour,
    required this.xp,
    required this.level,
  });
}
