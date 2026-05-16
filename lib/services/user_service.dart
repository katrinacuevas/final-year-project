// ========================================================================
// user_service.dart
// ------------------------------------------------------------------------
// manages user authentication, profile data, XP progression and lesson
// progress using Firebase Authentication and Cloud Firestore 
// ========================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ----- xp level thresholds -----
const List<int> kXpThresholds = [0, 100, 300, 500, 700, 900, 1100];

// ----- level calculator -----
// return the user level based on xp amount 
int levelFromXp(int xp) {
  for (int i = kXpThresholds.length - 1; i >= 0; i--) {
    if (xp >= kXpThresholds[i]) {
      return i;
    }
  }
  return 0;
}

// ----- xp progress calculator -----
// return progress percentage within the current level 
double xpProgressInLevel(int xp) {
  final level = levelFromXp(xp);
  final currentFloor = kXpThresholds[level];
  final nextCeiling = level + 1 < kXpThresholds.length
      ? kXpThresholds[level + 1]
      : kXpThresholds.last + 500;
  return ((xp - currentFloor) / (nextCeiling - currentFloor)).clamp(0.0, 1.0);
}

// ----- xp remaining calculator -----
// returns how much xp is needed for next level
int xpToNextLevel(int xp) {
  final level = levelFromXp(xp);
  if (level + 1 >= kXpThresholds.length) return 0;
  return kXpThresholds[level + 1] - xp;
}

// ====================================
// user profile model 
// ------------------------------------
// stores user account information, 
// avatar details and xp progression
// ====================================

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

  // create a user profile object from firestore data 
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

  // converts user profile into firestore map format 
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

  // xp updater 
  // return a new profile object with updated xp and level 
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

// ====================================
// lesson progress model 
// ------------------------------------
// stores lesson completion progress
// and star ratings 
// ====================================

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

  // return lesson completion percentage 
  double get percentage =>
      totalSteps == 0 ? 0 : stepsCompleted / totalSteps;

  // create lesson progress object from firestore data
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

// ====================================
// user service 
// ------------------------------------
// service responsible for authenticaton 
// profile handling, xp rewards and 
// lesson progress management 
// ====================================

class UserService with ChangeNotifier {
  UserService._();
  static final UserService instance = UserService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  UserProfile? _profile;
  String? _uid;
  Map<String, LessonProgress> _progressCache = {};
  final Set<String> _awardedLessons = {};

  // public getters
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
  
  Map<String, LessonProgress> get progressCache => _progressCache;

  // pending achievement notification 
  String? _pendingCatNudge;
  // notification getter
  // returns and clears pending cat notification
  String? takePendingCatNudge() {
    final msg = _pendingCatNudge;
    _pendingCatNudge = null;
    return msg;
  }

  // signs user in anonymously and loads profile/progress
  Future<void> init() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
    _uid = _auth.currentUser!.uid;
    await _loadProfile();
    await loadAllProgress();
  }

  // fetch user profile from firestore 
  Future<void> _loadProfile() async {
    if (_uid == null) return;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        _profile = UserProfile.fromMap(_uid!, doc.data()!);
        notifyListeners();
      }
    } catch (_) {}
  }

  // username validator 
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

  // save user profile 
  Future<void> saveProfile(UserProfile profile) async {
    if (_uid == null) return;
    final taken = await isUsernameTaken(profile.username);
    if (taken) throw Exception('Username is already taken, try another one!');
    await _db.collection('users').doc(_uid).set(profile.toMap());
    _profile = profile;
    notifyListeners();
  }

  // refresh profile
  Future<void> refreshProfile() async => await _loadProfile();

  // add xp reward 
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
      } catch (_) {}
    }

    final oldLevel = _profile!.level;
    final newXp = _profile!.xp + amount;
    final newLevel = levelFromXp(newXp);

    // update xp and level in firestore 
    await _db.collection('users').doc(_uid).set({
      'xp': FieldValue.increment(amount),
      'level': newLevel,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // mark lesson xp as awarded 
    await _db
        .collection('users')
        .doc(_uid)
        .collection('xp_awarded')
        .doc(lessonId)
        .set({'awardedAt': FieldValue.serverTimestamp()});

    // update local profile cache 
    _profile = _profile!.withXp(newXp);
    _awardedLessons.add(lessonId);
    // achievement notifiction
    _pendingCatNudge = '🏆 You just earned +$amount XP! Check the leaderboard — you might have moved up the rankings! 👀';
    notifyListeners();

    return (
      newXp: newXp,
      newLevel: newLevel,
      levelledUp: newLevel > oldLevel,
    );
  }

  // progress getter 
  LessonProgress? getProgress(String lessonId) => _progressCache[lessonId];

  // save lesson progress
  Future<void> saveProgress(LessonProgress progress) async {
    if (_uid == null) return;
    await _db
        .collection('users')
        .doc(_uid)
        .collection('progress')
        .doc(progress.lessonId)
        .set(progress.toMap(), SetOptions(merge: true));
    _progressCache[progress.lessonId] = progress;
    notifyListeners();
  }

  // load all progress
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
      notifyListeners();
    } catch (_) {
      _progressCache = {};
    }
  }
}