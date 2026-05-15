import 'dart:math';

class CatMessages {
  static final Random _rng = Random();

  static const List<String> _tabIntro = [
    "Hi! 👋 Welcome to your dashboard!\nThis is where you can see all your progress and daily challenges!",
    "These are your lessons! 📚\nEach one teaches you a different trick to stay safe online. Pick one to start!",
    "Your badges live here! 🏆\nComplete lessons to unlock new ones and show off your skills!",
    "This is your profile! 😸\nCheck your XP, level and avatar here!",
  ];

  static String tabIntro(int index) => _tabIntro[index.clamp(0, _tabIntro.length - 1)];

  static const List<String> _tips = [
    "🔐 Never share your password with anyone — not even your best friend!",
    "🎣 If a message says 'click here to win a prize!' — it's probably a trick! Don't click it!",
    "👤 A stranger online is still a stranger, even if they seem really nice!",
    "📱 Always tell a trusted adult if someone online makes you feel uncomfortable.",
    "🔗 Check the web address carefully before you click — fake sites look almost real!",
    "🎁 Free game items online are almost never really free — they're usually bait!",
    "🤫 Your full name, address and school are private — never share them online!",
    "🖥️ Found a USB stick on the floor? Never plug it in — it could be a trap!",
    "📧 Emails from banks or schools asking for your password are always fake!",
    "🤔 If something online feels weird or wrong, trust your gut and tell an adult!",
    "🏠 Use a different password for every account — like different keys for different doors!",
    "👀 Check who sent a message before you reply — anyone can pretend to be someone else!",
    "🎮 Even in games, don't share personal info with players you don't know in real life!",
    "⏰ Scammers always say 'hurry up!' to stop you thinking — take your time instead!",
    "🌐 Real companies never ask for your password by email, text or message!",
    "🐱 Mrrrow! Stay safe out there, cyber detective! 🕵️",
    "😸 You're getting really good at this cyber safety stuff!",
    "🐾 Purrr... remember, I'm always here if you need a tip!",
    "😼 Meow! Knowledge is your superpower online!",
    "🐱 Keep learning and you'll be unstoppable! Meow! 💪",
  ];

  static String randomTip() => _tips[_rng.nextInt(_tips.length)];

  static const List<String> _encouragement = [
    "You're doing amazing! Keep going! 🌟",
    "Purrr... you're one of the best cyber detectives I know! 😸",
    "Mrrrow! Every lesson makes you safer online! 💪",
    "You've got this! I believe in you! 🐾",
    "Meow! Look how far you've come already! 🎉",
    "You're a natural at this! 😼 Keep it up!",
    "Purrfectly brilliant! 🐱 I'm so proud of you!",
  ];

  static String randomEncouragement() => _encouragement[_rng.nextInt(_encouragement.length)];

  static String levelUp(int newLevel) =>
      "LEVEL UP! 🎉 You're now Level $newLevel!\nYou're absolutely unstoppable! Keep going! 🚀";

  static String xpEarned(int amount) =>
      "Amazing work! ⭐ You just earned +$amount XP!\nI'm so proud of you! 🐱";

  static String xpAlreadyEarned() =>
      "You already earned XP for this one! 😸\nReplay for practice anytime — I'll be here!";

  static String afterFirstTap() =>
      "Tap me anytime for a cyber safety tip! 🐾\nI've got loads of secrets to share! 😼";

  static String randomAfterFirstVisit() {
    final choices = [randomTip, randomEncouragement];
    return choices[_rng.nextInt(choices.length)]();
  }

  static String leaderboardGreeting() =>
      '🌍 Welcome to the leaderboard!\nSee how you rank against other cyber detectives — keep earning XP to climb higher! 🏆';

  static String leaderboardNudge(int xpGained) =>
      '🏆 You just earned +$xpGained XP! Check the leaderboard — you might have moved up the rankings! 👀';
}