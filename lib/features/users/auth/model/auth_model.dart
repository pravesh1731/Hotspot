class AuthFromState{
  final String name;
  final String email;
  final String password;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final bool isHiddenPassword;

  AuthFromState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.nameError,
    this.passwordError,
    this.emailError,
    this.isLoading = false,
    this.isHiddenPassword =false
});

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
          (name.isEmpty  || nameError == null);

  AuthFromState copyWith({
    String? name,
    String? email,
    String? password,
    String? nameError,
    String? emailError,
    String? passwordError,
    bool? isLoading,
    bool? isHiddenPassword,
  }) {
    return AuthFromState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      isLoading: isLoading ?? this.isLoading,
      isHiddenPassword: isHiddenPassword ?? this.isHiddenPassword,
    );
  }
}
