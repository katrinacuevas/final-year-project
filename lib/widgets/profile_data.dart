import 'package:flutter/material.dart';

class ProfileData {
  static final List<Map<String, dynamic>> completedTasks = [
    {'emoji': '🔒', 'title': 'Password Power', 'subtitle': 'Completed all 4 lessons', 'color': const Color(0xFFFFB347), 'xp': 100},
    {'emoji': '🎁', 'title': 'Baiting Intro', 'subtitle': 'Completed lesson 1 of 8', 'color': const Color(0xFFFF7F7F), 'xp': 50},
    {'emoji': '📧', 'title': 'Daily Challenge', 'subtitle': 'Spot the phishing email', 'color': const Color(0xFF7EC8E3), 'xp': 50},
  ];

  static final List<Map<String, dynamic>> badges = [
    {'emoji': '🔒', 'title': 'Password Master', 'color': const Color(0xFFFFB347)},
    {'emoji': '🔥', 'title': '5 Day Streak', 'color': const Color(0xFFFF7F7F)},
    {'emoji': '🛡️', 'title': 'Privacy Pro', 'color': const Color(0xFF7EC8E3)},
    {'emoji': '⚡', 'title': 'Quick Learner', 'color': const Color(0xFFB39DDB)},
  ];

  static final List<Map<String, dynamic>> safetyRules = [
    {
      'title': 'Never share your password',
      'icon': '🔒',
      'detail': 'Your password is private — not even your best friend should know it. If anyone online asks for it, say NO and tell a trusted adult.',
    },
    {
      'title': 'Don\'t talk to strangers online',
      'icon': '🚫',
      'detail': 'People online might not be who they say they are. Only chat with people you know in real life, and always tell an adult if someone makes you feel uncomfortable.',
    },
    {
      'title': 'If it sounds too good, it\'s probably fake',
      'icon': '🎁',
      'detail': 'Free prizes, free skins, and "secret glitches" are usually tricks to steal your info. Real rewards come from official sources only.',
    },
    {
      'title': 'Never click unknown links',
      'icon': '🔗',
      'detail': 'A dodgy link can install harmful software the moment you click it. Always ask a trusted adult before clicking anything you\'re unsure about.',
    },
    {
      'title': 'Tell a trusted adult if something feels wrong',
      'icon': '🤝',
      'detail': 'If anyone online makes you feel scared, uncomfortable, or confused — stop the conversation and tell a parent, carer, or teacher straight away.',
    },
  ];
}