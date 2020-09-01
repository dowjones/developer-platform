import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  
  Future<String> signUp(String email, String password);
  
  Future<FirebaseUser> getCurrentUser();
  
  Future<void> sendEmailVerification();
  
  Future<void> signOut();
  
  Future<bool> isEmailVerified();
}
