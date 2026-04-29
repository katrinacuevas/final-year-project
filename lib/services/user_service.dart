import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final int avatarIndex;
  final String avatarEmoji;
  final String avatarName;
  final String avatarColour;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.avatarIndex,
    required this.avatarEmoji,
    required this.avatarName,
    required this.avatarColour,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid, 
      username: map['username'] as String,
      avatarIndex: map['avatarIndex'] as int,
      avatarEmoji: map['avatarEmoji'] as String,
      avatarName: map['avatarName'] as String, 
      avatarColour: map['avatarColour'] as String,
    );
  }

Map<String, dynamic> toMap() => {
  'username': username, 
  'avatarIndex': avatarIndex,
  'avatarEmoji': avatarEmoji,
  'avatarName': avatarName,
  'avatarColour': avatarColour,
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

  UserProfile? get profile => _profile;
  String? get uid => _uid;
  bool get hasProfile => _profile != null;

  Future<void> init() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
    _uid = _auth.currentUser!.uid;
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_uid == null) return;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      if (doc.exists && doc.data() != null) {
        _profile = UserProfile.fromMap(_uid!, doc.data()!);
      }
    } catch (e) {
      // no profile (username and avatar not chosen yet )
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    if (_uid == null) throw Exception('Not authenticated');
    await _db.collection('users').doc(_uid).set(
      profile.toMap(),
      SetOptions(merge: true),
    );
    _profile = profile;
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }
}
