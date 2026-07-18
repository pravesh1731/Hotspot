import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? signInUser = await googleSignIn.signIn();
      if (signInUser == null) {
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await signInUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return false;
      }

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(
        authCredential,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'email': user.email ?? '',
            'name': user.displayName,
            'photoUrl': user.photoURL ?? '',
            'provider': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  void signOutUser() async {
    await auth.signOut();

    final isGoogleSignIn = await googleSignIn.isSignedIn();
    if (isGoogleSignIn) {
      await googleSignIn.signOut();
    }
  }
}

final firebaseServiceProvider = Provider<FirebaseServices>((ref) {
  return FirebaseServices();
});
