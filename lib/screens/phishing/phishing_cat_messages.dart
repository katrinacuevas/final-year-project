import 'dart:math';

class PhishingCatMessages {
  static final Random _rng = Random();

  static const String lessonIntro =
      "Time to become a Phishing Detective! I'll help you spot every sneaky trick cybercriminals use! 🕵️";

  // ─── Per-lesson tips shown on the Next button ─────────────────────────────
  static const String lesson1Tip =
      "Phishers pretend to be people you trust. Always ask yourself: 'Did I expect this message?' 🎣";

  static const String lesson2Tip =
      "Check the FULL email address — not just the display name. 'Apple Support' could come from 'apple.xyz.ru'! 🔍";

  static const String lesson3Tip =
      "Never click a link in a message you weren't expecting — even from someone you know! Type the website yourself instead. 🔗";

  static const String lesson4Tip =
      "When in doubt — STOP, don't click, and tell a trusted adult. It's always better to check! 🛡️";

  static const String chatSimTip =
      "Real companies NEVER offer free in-game currency by DM. If it sounds too good to be true — it is! 🎮";

  // ─── Random tips shown throughout ────────────────────────────────────────
  static const List<String> tips = [
    "Phishers rely on panic and urgency — slow down and think before you click anything!",
    "Real schools and companies will NEVER ask for your password by email or message.",
    "Check the full web address before clicking — one letter off can mean a fake site!",
    "'Free V-Bucks', 'Free Robux', 'Free Gems' — these are always traps. No exceptions!",
    "If a stranger online sends you a link — don't click it. Show a trusted adult first.",
    "A padlock icon means the site uses encryption, but it doesn't mean the site itself is safe!",
    "Phishing happens on email, text, gaming chat and social media. Always stay alert!",
    "If your gut says something feels off about a message — trust that feeling!",
  ];

  static String randomTip() => tips[_rng.nextInt(tips.length)];

  // ─── Chat simulation feedback ─────────────────────────────────────────────
  static const Map<int, String> chatCorrect = {
    0: "Purrfect! ✅ You spotted the fake link! Never log in through links sent by strangers — always go direct!",
    1: "Brilliant! ✅ Ignoring unsolicited prize messages is exactly right. Real contests don't work that way!",
    2: "Spot on! ✅ Real tech support never contacts you first out of the blue like that!",
  };

  static const Map<int, String> chatWrong = {
    0: "Uh oh! 😿 That link leads to a fake site designed to steal your login. Always type the address yourself!",
    1: "Oh no! 😼 Prize scams are one of the most common phishing tricks. If you didn't enter a contest — you didn't win one!",
    2: "Not quite! 😿 This is a 'vishing' trick — fake support calls. Real companies never ask for access like that!",
  };

  static String chatFeedback(int scenarioIndex, bool correct) {
    if (correct) {
      return chatCorrect[scenarioIndex] ?? "Brilliant detective work! ✅ You're really getting good at this! 😸";
    } else {
      return chatWrong[scenarioIndex] ?? "Not this time! 😿 Remember — if it feels off, don't click it!";
    }
  }

  // ─── Quiz feedback ────────────────────────────────────────────────────────
  static const Map<int, String> quizCorrect = {
    0: "Purrfect! ✅ Phishing = a fake message pretending to be someone you trust!",
    1: "Spot on! ✅ Extreme urgency is the number-one phishing red flag. Always pause and check!",
    2: "Exactly right! ✅ That sneaky zero instead of 'o' is a classic fake domain trick!",
    3: "Brilliant! ✅ Always type the website address yourself — never trust a link in a message!",
    4: "Amazing! ✅ Free in-game currency offers are ALWAYS scams. Official games never do that!",
  };

  static const Map<int, String> quizWrong = {
    0: "Not quite! 😿 Phishing isn't a virus — it's a trick message designed to steal your info!",
    1: "Nearly! 😼 Clicking immediately is exactly what the phisher wants. Pause and tell a trusted adult first!",
    2: "Hmm! 🤔 Look more closely — 'r0blox-free.xyz' has a zero AND a fake domain. Very suspicious!",
    3: "Not this time! 😿 Clicking the link first is risky. Always type the official address yourself!",
    4: "Almost! 🐾 Asking them to prove it won't work — scammers will just say more convincing things. Ignore and report!",
  };

  static String quizFeedback(int questionIndex, bool correct) {
    if (correct) {
      return quizCorrect[questionIndex] ?? "Brilliant! ✅ You really know your stuff! 😸";
    } else {
      return quizWrong[questionIndex] ?? "Not quite! 😿 Have another think — you can do it!";
    }
  }

  // ─── Completion messages ──────────────────────────────────────────────────
  static const List<String> lessonComplete3Stars = [
    "PERFECT SCORE! 🏆 You're a certified Phishing Detective! No scammer is getting past you! 😸",
    "WOW! Full marks! 🌟 You can spot every sneaky trick cybercriminals use! Purrfectly done! 🐱",
    "Incredible! 🎉 You aced every single question! You're a real cyber hero! 😼",
  ];

  static const List<String> lessonComplete2Stars = [
    "Great job! 🎉 You know loads about phishing! Review the tricky bits and try again for full marks!",
    "Well done! 😸 You're getting really sharp at spotting scams! A little more practice and you'll nail it!",
    "Nice work! 🐾 You're nearly a full detective — just review those tricky ones and go again!",
  ];

  static const List<String> lessonComplete1Star = [
    "Good try! 💪 Phishing can be sneaky — go back through the lessons and give it another shot!",
    "Don't give up! 😸 Every attempt makes you smarter and safer online! You've got this!",
    "Keep going! 🐾 Even I had to practice before I became a cyber cat! Try again — you can do it!",
  ];

  static String completeMessage(int stars) {
    if (stars == 3) {
      return lessonComplete3Stars[_rng.nextInt(lessonComplete3Stars.length)];
    } else if (stars == 2) {
      return lessonComplete2Stars[_rng.nextInt(lessonComplete2Stars.length)];
    } else {
      return lessonComplete1Star[_rng.nextInt(lessonComplete1Star.length)];
    }
  }
}