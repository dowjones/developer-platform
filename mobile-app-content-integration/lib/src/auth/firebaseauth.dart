import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_news_app/src/auth/baseauth.dart';

class FireBaseAuth extends BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn(String email, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password);
    var user = result?.user;
    return user?.getIdToken()?.then((value) => value.toString() ?? '');
  }
  
  @override
  Future<String> signUp(String email, String password) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password);
    var user = result?.user;
    return user?.getIdToken()?.then((value) => value.toString() ?? '');
  }
  
  @override
  Future<FirebaseUser> getCurrentUser() async {
    var user = await _firebaseAuth.currentUser();
    return user;
  }
  
  @override
  Future<void> sendEmailVerification() async {
    var user = await _firebaseAuth.currentUser();
    await user.sendEmailVerification();
  }
  
  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
  
  @override
  Future<bool> isEmailVerified() async {
    var user = await _firebaseAuth.currentUser();
    return await user.isEmailVerified;
  }
}
