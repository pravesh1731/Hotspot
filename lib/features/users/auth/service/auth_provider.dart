import 'package:flutter_riverpod/legacy.dart';
import 'package:hotspot/features/shared/service/google_auth_service.dart';
import 'package:hotspot/features/users/auth/model/auth_model.dart';


class AuthFormNotifier extends StateNotifier<AuthFromState> {
  AuthFormNotifier() : super(AuthFromState());

  void togglePasswordVisibility() {
    state = state.copyWith(isHiddenPassword: !state.isHiddenPassword);
  }

  void updateName(String name) {
    String? nameError;
    if (name.isNotEmpty && name.length < 6) {
      nameError = "Provide Your full name";
    }
    state = state.copyWith(name: name, nameError: nameError);
  }

  void updateEmail(String email) {
    String? emailError;
    if (email.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      emailError = "Provide a valid email address";
    }
    state = state.copyWith(email: email, emailError: emailError);
  }

  void updatePassword(String password) {
    String? passwordError;
    if (password.isNotEmpty && password.length < 6) {
      passwordError = "Password must be at least 6 characters";
    }
    state = state.copyWith(password: password, passwordError: passwordError);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

final authFormProvider = StateNotifierProvider<AuthFormNotifier, AuthFromState>(
  (ref) {
    return AuthFormNotifier();
  },
);
