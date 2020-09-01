import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_news_app/src/auth/baseauth.dart';

class FakeAuth implements BaseAuth {
  @override
  Future<String> signIn(String email, String password) {
    var completer = Completer<String>();
    completer.complete('id-fake');
    return completer.future;
  }
  
  @override
  Future<String> signUp(String email, String password) {
    var completer = Completer<String>();
    completer.complete('id-fake');
    return completer.future;
  }
  
  @override
  Future<FirebaseUser> getCurrentUser() {
    var completer = Completer<FirebaseUser>();
    completer.complete(null);
    return completer.future;
  }
  
  @override
  Future<void> sendEmailVerification() {
    var completer = Completer<void>();
    completer.complete(null);
    return completer.future;
  }
  
  @override
  Future<void> signOut() {
    var completer = Completer<void>();
    completer.complete(null);
    return completer.future;
  }
  
  @override
  Future<bool> isEmailVerified() {
    var completer = Completer<bool>();
    completer.complete(true);
    return completer.future;
  }
}
