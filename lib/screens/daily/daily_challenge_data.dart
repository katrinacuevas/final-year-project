// ========================================================================
// daily_challenge_data.dart
// ------------------------------------------------------------------------
// model classes and content for all three daily challenges
// challenge 1: spot the fake (phishing), 2: what would you do (baiting),
// 3: safe or risky (pretexting scenarios)
// ========================================================================

class ChallengeMessage {
  final String sender, body;
  const ChallengeMessage(this.sender, this.body);
}

const spotReal = ChallengeMessage('Roblox', 'Hi! Your 100 Robux from the developer reward have been added. Thanks for playing!');
const spotFake = ChallengeMessage('R0blox-Fr33', '🚨 YOUR ACCOUNT WILL BE DELETED IN 1 HOUR! Click NOW to save it → free-r0bux.xyz');
const spotFakeIsB = true;
const spotHint = '"R0blox-Fr33" uses zeros instead of letters — a classic fake name trick! Real Roblox never threatens to delete your account or sends you to random websites.';

class ChatMessage {
  final String from, body;
  const ChatMessage(this.from, this.body);
}

class ChatChoice {
  final String emoji, label, feedback;
  final bool best;
  const ChatChoice({required this.emoji, required this.label, required this.feedback, required this.best});
}

const chatMsgs = [
  ChatMessage('GamePrize_Bot', '🎉 CONGRATS! You\'ve been randomly selected to WIN a FREE gaming PC!'),
  ChatMessage('GamePrize_Bot', 'Just send us your full name, home address and school — we\'ll deliver it tomorrow! 📦'),
];

const chatChoices = [
  ChatChoice(
    emoji: '📨', label: 'Send my details — I want the prize!',
    feedback: 'Careful! Real competitions never contact you out of nowhere asking for your home address. This is a baiting trap designed to get your personal info. Never share your address online!',
    best: false,
  ),
  ChatChoice(
    emoji: '🛡️', label: 'Close it and tell a trusted adult',
    feedback: 'Brilliant! You can\'t win something you never entered. Closing it and telling a parent or teacher is always the safest move. You spotted the bait! 🎣',
    best: true,
  ),
  ChatChoice(
    emoji: '🤔', label: 'Ask them to prove the prize is real',
    feedback: 'Good instinct to be suspicious! But scammers can seem very convincing. The safest thing is always to close it and tell an adult rather than chatting with them.',
    best: false,
  ),
];

class ChallengeScenario {
  final String emoji, text, feedback;
  final bool risky;
  const ChallengeScenario({required this.emoji, required this.text, required this.risky, required this.feedback});
}

const scenarios = [
  ChallengeScenario(
    emoji: '🎮',
    text: 'Someone in a game chat says "I\'m from Roblox support. Give me your password and I\'ll add 1,000 Robux to your account."',
    risky: true,
    feedback: 'RISKY! Real support staff NEVER ask for your password — they don\'t need it. This is pretexting: pretending to be support to steal your account!',
  ),
  ChallengeScenario(
    emoji: '📱',
    text: 'Your mum texts you from her usual number saying she\'ll be 10 minutes late picking you up from school.',
    risky: false,
    feedback: 'SAFE! A normal message from a known, trusted person using their real number. Nothing suspicious here!',
  ),
  ChallengeScenario(
    emoji: '🏫',
    text: 'You get a message saying "Hi, I\'m your new teacher. I need your home address for school records — reply here."',
    risky: true,
    feedback: 'RISKY! Schools never collect home addresses by text message. Someone is pretending to be a teacher to find out where you live!',
  ),
  ChallengeScenario(
    emoji: '🎮',
    text: 'Your friend Jake sends you a message asking if you want to play Minecraft after school, like you do every week.',
    risky: false,
    feedback: 'SAFE! A normal message from someone you know well, about something you regularly do together. No red flags!',
  ),
];
