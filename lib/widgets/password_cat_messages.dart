import 'dart:math';

class PasswordCatMessages {
  static final Random _rng = Random();

  static const String lessonIntro =
      "Hi! I'm Byte! 🐱 Let's learn how to make passwords SO strong that no hacker can ever crack them!";

  static const List<String> tips = [
    "Hackers use programs that try millions of common passwords in seconds. The simpler yours is, the faster it gets cracked!",
    "Think of a password like the key to your house — a weak one lets anyone walk right in!",
    "Never use your name, birthday or favourite team — those are the first things hackers try!",
    "The longer your password, the harder it is to crack. 12 characters is the magic minimum!",
    "Mixing UPPER and lower case letters makes your password way harder to guess!",
    "Adding numbers and symbols like ! @ # makes it almost impossible to crack!",
    "A passphrase is three random words joined together — easy to remember but super hard to crack!",
    "Never use the same password for two different accounts — if one gets hacked, the others stay safe!",
  ];

  static String randomTip() => tips[_rng.nextInt(tips.length)];

  static String tip(int index) => tips[index.clamp(0, tips.length - 1)];

  static const List<String> weakPasswordWarnings = [
    "Uh oh! 😿 That's one of the most guessed passwords of all time. Hackers try that one first!",
    "Mrrrow! 😼 Using your name makes it way too easy to guess. Try something more secret!",
    "Yikes! 🙀 Short passwords get cracked in seconds. Make it longer!",
    "Oh no! 😿 Numbers in order are super easy to guess. Mix it up a bit!",
    "Meow! 😼 That's a really common password. Hackers have a whole list of those!",
  ];

  static String randomWeakWarning() =>
      weakPasswordWarnings[_rng.nextInt(weakPasswordWarnings.length)];

  static const Map<String, String> buildHints = {
    'length':  "Almost there! 📏 You need at least 12 characters — try adding more words!",
    'upper':   "Nice start! 🔤 Now add some UPPERCASE letters — try capitalising the start of a word!",
    'lower':   "Great! Now mix in some lowercase letters too to make it even stronger!",
    'number':  "Looking good! 🔢 Throw in a number — like replacing 'o' with '0'!",
    'symbol':  "Nearly there! ✨ Add a symbol like ! @ # or \$ to make it super strong!",
    'strong':  "WOW! 🔥 That password is incredible! No hacker is getting through that! Purrfect! 😸",
  };

  static const List<String> buildEncouragement = [
    "Keep going! You're building something amazing! 💪",
    "Purrr... I can feel that password getting stronger! 😸",
    "Yes! Tick those rules off one by one! 🐾",
    "You're so close to a perfect password! Don't stop now! 🌟",
    "Meow! Every symbol and number makes it harder to crack! 😼",
  ];

  static String randomBuildEncouragement() =>
      buildEncouragement[_rng.nextInt(buildEncouragement.length)];

  static const Map<int, String> quizCorrect = {
    0: "Purrfect! ✅ That's right — long, mixed case, numbers AND symbols is the winning combo!",
    1: "Spot on! ✅ 12 characters is the minimum. The longer the better!",
    2: "Exactly right! ✅ Using your own name makes it way too easy to guess!",
    3: "Brilliant! ✅ Special symbols like @ ! # make passwords much harder to crack!",
    4: "Amazing! ✅ Combining random words makes a memorable but super strong password!",
  };

  static const Map<int, String> quizWrong = {
    0: "Not quite! 😿 The strongest password has ALL four things — length, mixed case, numbers and symbols!",
    1: "Nearly! 😼 4 or 8 characters isn't enough — aim for at least 12!",
    2: "Hmm! 🤔 The problem with your name is that people who know you could guess it easily!",
    3: "Not this time! 😿 Only letters aren't enough — you need symbols too!",
    4: "Almost! 🐾 A passphrase uses RANDOM words together — not just one short word!",
  };

  static String quizFeedback(int questionIndex, bool correct) {
    if (correct) {
      return quizCorrect[questionIndex] ??
          "Brilliant! ✅ You really know your stuff! 😸";
    } else {
      return quizWrong[questionIndex] ??
          "Not quite! 😿 Have another think — you can do it!";
    }
  }

  static const List<String> lessonComplete3Stars = [
    "PERFECT SCORE! 🏆 You're an absolute password LEGEND! I'm so proud! 😸",
    "WOW! Full marks! 🌟 You know exactly how to keep your accounts safe! Purrfect! 🐱",
    "Incredible! 🎉 You nailed every single question! You're a real cyber hero! 😼",
  ];

  static const List<String> lessonComplete2Stars = [
    "Great job! 🎉 You know loads about passwords! Review the tricky bits and try again for full marks!",
    "Well done! 😸 You're getting really good at this! A little more practice and you'll ace it!",
    "Nice work! 🐾 Two more to go for a perfect score — you've totally got this!",
  ];

  static const List<String> lessonComplete1Star = [
    "Good try! 💪 Passwords can be tricky — go back through the lessons and give it another go!",
    "Don't give up! 😸 Every attempt makes you smarter and safer online! You've got this!",
    "Keep going! 🐾 Even I had to practice before I became a cyber cat! Try again!",
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