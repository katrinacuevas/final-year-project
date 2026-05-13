class PhishingCatMessages {
  static const String lessonIntro =
    "Let's learn how sneaky phishers try to trick you — and how to catch them first! 🕵️";

  static const String lesson1Tip =
    "Remember: just like fishing, phishers throw out lots of fake messages hoping someone will bite. Don't be the fish! 🐟";

  static const String lesson2Tip =
    "Phishers pretend to be people you trust — schools, games, friends. Always double-check before clicking anything! 🔍";

  static const String lesson3Tip =
    "The sender address is the biggest clue. Zoom in on it — fake addresses often swap letters for numbers! 👀";

  static const String lesson4Tip =
    "If a message tries to rush you or scare you, slow down. That panic is exactly what they want! 🛑";

  static const String lesson5Tip =
    "Real websites use simple, clean addresses. Anything with weird hyphens or random words is a big red flag! 🚩";

  static const String lesson6Tip =
    "Golden rule: when in doubt, type the website address yourself. Never follow a link in a message! ✍️";

  static const String lesson7Tip =
    "You've now got all the tools to protect yourself. Stop → check → tell an adult. You've got this! 💪";

  static String quizFeedback(int questionIndex, bool correct) {
    if (correct) {
      const List<String> wins = [
        "Purrfect! ✅ You really understand what phishing is!",
        "Spot on! ✅ Telling a trusted adult is always the right move!",
        "Brilliant! ✅ You've got a sharp eye for fake addresses!",
        "Exactly right! ✅ Typing the address yourself is always safest!",
        "Amazing! ✅ Free in-game offers are ALWAYS scams!",
      ];
      return wins[questionIndex.clamp(0, wins.length - 1)];
    } else {
      const List<String> misses = [
        "Not quite! 😿 Phishing is a fake message pretending to be someone you trust!",
        "Nearly! 😼 The urgency trick is designed to make you panic — always pause and tell an adult!",
        "Hmm! 🤔 Look closely at the domain — 'r0blox-free.xyz' uses a zero and has 'free' in it!",
        "Not this time! 😿 Clicking to check is risky — always type the address yourself instead!",
        "Almost! 🐾 No game company ever gives away free currency through random messages — always a scam!",
      ];
      return misses[questionIndex.clamp(0, misses.length - 1)];
    }
  }

  static String completeMessage(int stars) {
    if (stars == 3) return "PERFECT SCORE! 🏆 You're an absolute Phishing Detective legend! No scammer can fool you now! 😸";
    if (stars == 2) return "Great job! 🎉 You know loads about phishing! Review the tricky bits and try again for full marks!";
    return "Good try! 💪 Phishing can be tricky — go back through the lessons and give it another shot!";
  }
}