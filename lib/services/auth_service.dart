import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer'; // Add this for logging

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    log("Attempting login for email: $email");
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log("Login successful for email: $email");
    } catch (e) {
      log("Login failed for email: $email. Error: $e", level: 1000);
      throw Exception("Login failed");
    }
  }

  Future<void> register(String email, String password) async {
    log("Attempting registration for email: $email");
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("Registration successful for email: $email");
    } catch (e) {
      log("Registration failed for email: $email. Error: $e", level: 1000);
      throw Exception("Registration failed");
    }
  }

  Future<void> logout() async {
    log("Attempting logout for user: ${_auth.currentUser?.email}");
    await _auth.signOut();
    log("Logout successful");
  }

  User? get currentUser => _auth.currentUser;

  Future<String> getCurrentUserId() async {
    log("Fetching current user ID");
    if (_auth.currentUser != null) {
      log("Current user ID: ${_auth.currentUser!.uid}");
      return _auth.currentUser!.uid;
    }
    log("User not logged in", level: 1000);
    throw Exception("User not logged in");
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    User? user = _auth.currentUser;
    log("Updating profile for user: ${user?.email}");
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload(); // Refresh user info
      log("Profile updated: displayName=$displayName, photoURL=$photoURL");
    } else {
      log("No user is currently signed in.", level: 1000);
      throw Exception("No user is currently signed in.");
    }
  }
}
