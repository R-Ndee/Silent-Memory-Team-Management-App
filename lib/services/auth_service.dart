import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// Service handling Firebase Authentication & Firestore User profile operations.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of Firebase Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current Firebase Auth User
  User? get currentUser => _auth.currentUser;

  /// Signs in user with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Signs out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Fetches user profile document from Firestore `/users/{userId}`
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Stream of user profile from Firestore
  Stream<UserModel?> streamUserProfile(String uid) {
    final docPath = '/users/$uid';
    if (kDebugMode) {
      print(
        '[AuthService] Streaming profile for Auth UID: $uid (email: ${_auth.currentUser?.email}) from path: $docPath',
      );
    }
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        if (kDebugMode) {
          print('[AuthService] Firestore document does NOT exist at path: $docPath');
        }
        return null;
      }
      final profile = UserModel.fromFirestore(snapshot);
      if (kDebugMode) {
        print(
          '[AuthService] Profile loaded successfully from $docPath -> role: "${profile.role}", status: "${profile.status}", displayName: "${profile.displayName}"',
        );
      }
      return profile;
    }).handleError((error, stackTrace) {
      if (kDebugMode) {
        print('[AuthService] ERROR streaming profile from $docPath: $error');
      }
      throw error;
    });
  }
}

