import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = AuthService();
  User? user;
  bool loading = true;

  AuthProvider() {
    _auth.authState.listen((u) {
      user = u;
      loading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String pass) async {
    await _auth.signIn(email, pass);
  }

  Future<void> register(String email, String pass) async {
    await _auth.register(email, pass);
  }

  Future<void> logout() => _auth.signOut();
}
