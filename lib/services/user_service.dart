import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<int> kXpThresholds = [0, 100, 300, 500, 700, 900, 1100];

int levelFromXp(int xp) {
  for (int i = kXpThresholds.length - 1; i >= 0; i--) {
    if (xp >= kXpThresholds[i]) {
      return i;
    }
  }
  return 0;
}

double xpProgressInLevel(int xp) {
  final level = levelFromXp(xp);
  final currentFloor = kXpThresholds[level];
  final nextCeiling = level + 1 < kXpThresholds.length
      ? kXpThresholds[level + 1]
      : kXpThresholds.last + 500;
  return ((xp - currentFloor) / (nextCeiling - currentFloor)).clamp(0.0, 1.0);
}

int xpToNextLevel(int xp) {
  final level = levelFromXp(xp);
  if (level + 1 >= kXpThresholds.length) return 0;
  return kXpThresholds[level + 1] - xp;
}

class UserProfile {
  final String uid;
  final String username;
  final int avatarIndex;
  final String avatarEmoji;
  final String avatarName;
  final String avatarColour;
  final int xp;
  final int level;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.avatarIndex,
    required this.avatarEmoji,
    required this.avatarName,
    required this.avatarColour,
    this.xp = 0,
    this.level = 0,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    final xp = (map['xp'] as int?) ?? 0;
    return UserProfile(
      uid: uid,
      username: map['username'] as String,
      avatarIndex: map['avatarIndex'] as int,
      avatarEmoji: map['avatarEmoji'] as String,
      avatarName: map['avatarName'] as String,
      avatarColour: map['avatarColour'] as String,
      xp: xp,
      level: levelFromXp(xp),
    );
  }

  Map<String, dynamic> toMap() => {
        'username': username,
        'avatarIndex': avatarIndex,
        'avatarEmoji': avatarEmoji,
        'avatarName': avatarName,
        'avatarColour': avatarColour,
        'xp': xp,
        'level': level,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  UserProfile withXp(int newXp) => UserProfile(
        uid: uid,
        username: username,
        avatarIndex: avatarIndex,
        avatarEmoji: avatarEmoji,
        avatarName: avatarName,
        avatarColour: avatarColour,
        xp: newXp,
        level: levelFromXp(newXp),
      );
}


class LessonProgress {
  final String lessonId;
  final int stepsCompleted;
  final int totalSteps;
  final int stars;
  final bool completed;

  const LessonProgress({
    required this.lessonId,
    required this.stepsCompleted,
    required this.totalSteps,
    required this.stars,
    required this.completed,
  });

  double get percentage =>
      totalSteps == 0 ? 0 : stepsCompleted / totalSteps;

  factory LessonProgress.fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonId: map['lessonId'] as String,
      stepsCompleted: map['stepsCompleted'] as int,
      totalSteps: map['totalSteps'] as int,
      stars: map['stars'] as int,
      completed: map['completed'] as bool,
    );
  }

  Map<String, dynamic> toMap() => {
        'lessonId': lessonId,
        'stepsCompleted': stepsCompleted,
        'totalSteps': totalSteps,
        'stars': stars,
        'completed': completed,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}

class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  UserProfile? _profile;
  String? _uid;
  Map<String, LessonProgress> _progressCache = {};

  final Set<String> _awardedLessons = {};

  UserProfile? get profile => _profile;
  String? get uid => _uid;
  bool get hasProfile => _profile != null;

  int get xp => _profile?.xp ?? 0;
  int get level => _profile?.level ?? 0;
  double get xpProgress => xpProgressInLevel(xp);
  int get xpForNextLevel => xpToNextLevel(xp);
  int get xpAtCurrentLevel =>
      level < kXpThresholds.length ? kXpThresholds[level] : 0;
  int get xpNeededForNextLevel =>
      level + 1 < kXpThresholds.length ? kXpThresholds[level + 1] : xp;

  Future<void> init() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
    _uid = _auth.currentUser!.uid;
    await _loadProfile();
    await loadAllProgress();
  }

  Future<void> _loadProfile() async {
    if (_uid == null) return;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        _profile = UserProfile.fromMap(_uid!, doc.data()!);
      }
    } catch (_) {}
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      final result = await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (result.docs.isEmpty) return false;
      for (var doc in result.docs) {
        if (doc.id != _uid) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    if (_uid == null) return;
    final taken = await isUsernameTaken(profile.username);
    if (taken) throw Exception('Username is already taken, try another one!');
    await _db.collection('users').doc(_uid).set(profile.toMap());
    _profile = profile;
  }

  Future<void> refreshProfile() async => await _loadProfile();

  Future<({int newXp, int newLevel, bool levelledUp})?> addXp(
    String lessonId,
    int amount, {
    bool force = false,
  }) async {
    if (_uid == null || _profile == null) return null;

    if (!force) {
      try {
        final awarded = await _db
            .collection('users')
            .doc(_uid)
            .collection('xp_awarded')
            .doc(lessonId)
            .get();
        if (awarded.exists) return null;
      } catch (_) {
        // If the read fails, allow the award anyway rather than
        // silently blocking the user forever
      }
    }

    final oldLevel = _profile!.level;
    final newXp = _profile!.xp + amount;
    final newLevel = levelFromXp(newXp);

    await _db.collection('users').doc(_uid).set({
      'xp': FieldValue.increment(amount),
      'level': newLevel,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db
        .collection('users')
        .doc(_uid)
        .collection('xp_awarded')
        .doc(lessonId)
        .set({'awardedAt': FieldValue.serverTimestamp()});

    _profile = _profile!.withXp(newXp);
    _awardedLessons.add(lessonId); 

    return (
      newXp: newXp,
      newLevel: newLevel,
      levelledUp: newLevel > oldLevel,
    );
  }

  LessonProgress? getProgress(String lessonId) => _progressCache[lessonId];

  Future<void> saveProgress(LessonProgress progress) async {
    if (_uid == null) return;
    await _db
        .collection('users')
        .doc(_uid)
        .collection('progress')
        .doc(progress.lessonId)
        .set(progress.toMap(), SetOptions(merge: true));
    _progressCache[progress.lessonId] = progress;
  }

  Future<void> loadAllProgress() async {
    if (_uid == null) return;
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_uid)
          .collection('progress')
          .get();
      _progressCache = {
        for (final doc in snapshot.docs)
          doc.id: LessonProgress.fromMap(doc.data()),
      };
    } catch (_) {
      _progressCache = {};
    }
  }
}