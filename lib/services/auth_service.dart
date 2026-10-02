import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic> adminProfile = {};
  bool loading = true;

  Future<void> restoreSession() async {
    user = _auth.currentUser;
    if (user != null) {
      await _loadAdminProfile();
    }
    loading = false;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      user = credential.user;
      if (user == null || !user!.emailVerified) {
        await _auth.signOut();
        user = null;
        return 'Admin email must be verified.';
      }
      final ok = await _loadAdminProfile();
      if (!ok) {
        await _auth.signOut();
        user = null;
        return 'This account is not authorized as an admin.';
      }
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed.';
    }
  }

  Future<bool> _loadAdminProfile() async {
    if (user == null) return false;
    final snap = await _db.collection('admin_users').doc(user!.uid).get();
    if (!snap.exists) return false;
    final data = snap.data() ?? {};
    if (data['status'] != 'active') return false;
    adminProfile = data;
    return true;
  }

  bool hasPermission(String permission) {
    final permissions = List<String>.from(adminProfile['permissions'] ?? const []);
    return permissions.contains('*') || permissions.contains(permission);
  }

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    adminProfile = {};
    notifyListeners();
  }
}
