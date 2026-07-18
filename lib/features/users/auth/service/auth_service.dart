import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthMethod {
  final  _firestore = FirebaseFirestore.instance;
  final  _auth = FirebaseAuth.instance;

  //signup
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "All fields are required";
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  //login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "All fields are required";
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // logout
  Future<void> logout() async{
    await _auth.signOut();
  }
}

final authMethodProvider = Provider<AuthMethod>((ref){
  return AuthMethod();
});
