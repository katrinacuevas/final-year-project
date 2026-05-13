class BaitingCatMessages {
  static const String lessonIntro =
    "Baiters use shiny tempting offers to trap you — like bait on a hook! Let's learn how to spot the trap 🪤";

  static const String lesson1Tip =
    "Remember: if something makes you feel EXCITED and you just have to have it — slow down. That excitement is exactly what baiters want! 🎣";

  static const String lesson2Tip =
    "Baiters are sneaky! They study what you love and use it as the hook. Your favourite game, music, films — all turned into traps! 😼";

  static const String lesson3Tip =
    "Free games, prizes, music downloads — none of it is real. Real companies don't give stuff away to random people for nothing! 🚫";

  static const String lesson4Tip =
    "A USB stick on the floor is NEVER a happy accident. Hackers leave them on purpose with tempting labels. Never plug one in! 🖲️";

  static const String lesson5Tip =
    "Countdown timers, 'you've been selected', 'act now' — these are all tricks to stop you thinking. Slow down and spot the flags! 🚩";

  static const String lesson6Tip =
    "Real rewards are patient. Fake bait is always in a rush. If it feels urgent and too good to be true — it is! ⏰";

  static const String lesson7Tip =
    "Stop, think, tell a trusted adult. Three steps that keep you safe every single time! 💪😸";

  static String quizFeedback(int questionIndex, bool correct) {
    if (correct) {
      const List<String> wins = [
        "Purrfect! ✅ You know exactly what baiting is — using temptation as a trap!",
        "Spot on! ✅ That excitement and urgency is the bait — you saw right through it!",
        "Brilliant! ✅ USB sticks on the floor are ALWAYS suspicious. Never plug one in!",
        "Exactly right! ✅ You can't win something you never entered — instant red flag!",
        "Amazing! ✅ Stopping and telling an adult is always the safest move! 🛡️",
      ];
      return wins[questionIndex.clamp(0, wins.length - 1)];
    } else {
      const List<String> misses = [
        "Not quite! 😿 Baiting uses exciting offers and temptation — not fear and urgency like phishing!",
        "Nearly! 😼 That countdown and excitement is the trick — baiters want you to act before you think!",
        "Hmm! 🤔 USB sticks left on the floor are planted by hackers on purpose with tempting labels!",
        "Not this time! 😿 You never entered a competition — so you can never win one. It's always fake!",
        "Almost! 🐾 Telling a trusted adult is key — they can check if something is real in seconds!",
      ];
      return misses[questionIndex.clamp(0, misses.length - 1)];
    }
  }

  static String completeMessage(int stars) {
    if (stars == 3) return "PERFECT SCORE! 🏆 You're a true Baiting Pro! No sneaky trap will ever catch you now! 😸";
    if (stars == 2) return "Great job! 🎉 You know loads about baiting! Review the tricky bits and try again for full marks!";
    return "Good try! 💪 Baiting tricks can be clever — go back through the lessons and have another go!";
  }
}