
 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspot/features/users/home/home_screen.dart';
import 'package:hotspot/go_route.dart';

import '../model/google_auth_model.dart';
import 'google_auth_service.dart';

class GoogleAuthNotifier extends StateNotifier<GoogleAuthState>{
  final FirebaseServices _firebaseServices;

  GoogleAuthNotifier(this._firebaseServices) : super(GoogleAuthState());

  Future<void> signInWithGoogle(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final result  = await _firebaseServices.signInWithGoogle();
      state = state.copyWith(isLoading: false);
      if(result){
        await Future.delayed(Duration(milliseconds: 300));
        // NavigationHelper.pushReplacement(context, HomeScreen());
      }else{
        state = state.copyWith(error: "Google sign-in failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Google sign-in failed: ${e.toString()}");
    }

  }

  void clearError(){
    state = state.copyWith(error: null);
  }
}


final googleAuthProvider = StateNotifierProvider<GoogleAuthNotifier, GoogleAuthState>((ref){
  final firebaseService  = ref.read(firebaseServiceProvider);
  return GoogleAuthNotifier(firebaseService);
});