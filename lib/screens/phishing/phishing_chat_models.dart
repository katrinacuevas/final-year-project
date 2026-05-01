import 'package:flutter/material.dart';

class ChatMessage {
  final String from;
  final String text;
  
  ChatMessage({required this.from, required this.text});
  
  Map<String, dynamic> toJson() => {'from': from, 'text': text};
  factory ChatMessage.fromJson(Map<String, dynamic> json) => 
      ChatMessage(from: json['from'], text: json['text']);
}

class FeedbackOption {
  final bool safe;
  final String title;
  final List<String> points;
  final String emoji;
  
  FeedbackOption({required this.safe, required this.title, required this.points, required this.emoji});
}

class PhishingScenario {
  final String title;
  final List<ChatMessage> messages;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final List<FeedbackOption> feedback;
  
  PhishingScenario({
    required this.title,
    required this.messages,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.feedback,
  });
}

final List<PhishingScenario> phishingScenarios = [
  PhishingScenario(
    title: 'The Free Skin Trick 🎮',
    messages: [
      ChatMessage(from: 'stranger', text: 'Hey, nice work! You\'re pretty good for a new player 😊'),
      ChatMessage(from: 'you', text: 'Thx, your outfit is awesome!'),
      ChatMessage(from: 'stranger', text: 'Thx, I made most of it myself, I found a glitch to get it for freeee!!'),
      ChatMessage(from: 'stranger', text: 'Its kind of complicated but i can do it if i log into your account for 2 mins :D'),
      ChatMessage(from: 'you', text: '...'),
    ],
    question: 'How do you respond?',
    choices: [
      'OMG!! Yes :DD',
      'Cant you just tell me how ill try??',
      'No way im not doing that!',
    ],
    correctIndex: 2,
    feedback: [
      FeedbackOption(
        safe: false,
        title: 'Uh-Oh! That choice would\'ve let a stranger into your account!',
        points: [
          'Say NO if anyone asks for your password',
          'BLOCK the person',
          'REPORT them to keep others safe',
        ],
        emoji: '😨',
      ),
      FeedbackOption(
        safe: false,
        title: 'Be careful! Asking how to do it yourself still shows you\'re interested.',
        points: [
          'Never share or look for account glitches',
          'Real free items come from official sources only',
          'BLOCK and REPORT the person',
        ],
        emoji: '😬',
      ),
      FeedbackOption(
        safe: true,
        title: 'Great job! You protected your account! 🎉',
        points: [
          'Never give anyone access to your account',
          'Real games never need your login details',
          'You can also BLOCK and REPORT this person',
        ],
        emoji: '🛡️',
      ),
    ],
  ),
];