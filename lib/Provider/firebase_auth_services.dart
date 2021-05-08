import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices with ChangeNotifier {
  String _errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future register(String myEmail, String myPassword) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: myEmail, password: myPassword);

      User user = authResult.user;
      setLoading(false);

      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No Internet, please connect to the internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future login(String myEmail, String myPassword) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: myEmail, password: myPassword);

      User user = authResult.user;
      setLoading(false);

      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No Internet, please connect to the internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future logOut() async {
    await firebaseAuth.signOut();
    notifyListeners();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
