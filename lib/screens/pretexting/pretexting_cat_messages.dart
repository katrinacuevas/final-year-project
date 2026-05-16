// ========================================================================
// pretexting_cat_messages.dart
// ------------------------------------------------------------------------
// all cat dialogue strings used throughout the pretexting lesson 
// ========================================================================

class PretextingCatMessages {
  static const String lessonIntro =
      "Some people make up fake stories to trick you into sharing your secrets! 🎭 Let's learn how to catch them out! 🕵️";

  // ----- lesson tips -----
  static const String lesson1Tip =
      "Anyone can SAY they have a made-up reason to talk to you. Now you know what pretexting looks like! 🎭";

  static const String lesson2Tip =
      "Pretexters use trust, rushing, and little facts they know to make you believe them. Sneaky — but now you know! 🕵️😸";

  static const String lesson3Tip =
      "Pretexters wear LOTS of disguises — IT people, police, competition organisers, old friends. Now you know what to look for! 🎭😸";

  static const String lesson4Tip =
      "One sneaky letter swap in an email address can be the difference between real and fake! Always look VERY carefully! 🔎";

  static const String lesson5Tip =
      "That weird feeling in your tummy is there for a reason — listen to it! It's always okay to say 'let me check with a grown-up first'! 💪";

  static const String lesson6Tip =
      "PAUSE is your secret weapon! Stop → Ask → Understand → Seek help → Exit. Five steps that keep you safe every time! 🛡️😸";

  // ----- quiz feedback -----
  static String quizFeedback(int questionIndex, bool correct) {
    if (correct) {
      const List<String> wins = [
        "Purrfect! ✅ Pretexting means someone makes up a fake story and pretends to be someone else to trick you!",
        "Spot on! ✅ Real IT staff NEVER need your password — they have their own special tools to fix things!",
        "Brilliant! ✅ Those sneaky number swaps in email addresses are a classic fake trick — great spotting!",
        "Exactly right! ✅ You can't verify who someone is online, so always check with a grown-up first!",
        "Amazing! ✅ P is for PAUSE — always stop and think before doing anything suspicious! 🛡️",
      ];
      return wins[questionIndex.clamp(0, wins.length - 1)];
    } else {
      const List<String> misses = [
        "Not quite! 😿 Pretexting is when someone invents a fake story and pretends to be someone else — like an actor playing a villain!",
        "Nearly! 😼 No one should EVER ask for your password — not even the IT teacher. Real staff have tools to fix accounts without it!",
        "Hmm! 🤔 Look really carefully at email addresses — swapping letters for numbers like '0' instead of 'o' is a sneaky fake trick!",
        "Not this time! 😿 Your address is very private info — always check with a trusted grown-up before sharing anything!",
        "Almost! 🐾 The PAUSE rule starts with P for Pause — stop what you're doing and think before you act!",
      ];
      return misses[questionIndex.clamp(0, misses.length - 1)];
    }
  }

  // ----- completion messages -----
  static String completeMessage(int stars) {
    if (stars == 3) {
      return "PERFECT SCORE! 🏆 You're a true Pretexting Detective! No sneaky faker will ever fool YOU now! 😸";
    }
    if (stars == 2) {
      return "Great job! 🎉 You know loads about pretexting! Review the tricky bits and try again for full marks!";
    }
    return "Good try! 💪 Pretexting tricks can be sneaky — go back through the lessons and have another go!";
  }
}
