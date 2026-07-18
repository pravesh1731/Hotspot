import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/features/users/auth/screen/userLoginPage.dart';
import 'package:hotspot/features/users/auth/service/auth_provider.dart';
import 'package:hotspot/go_route.dart';
import '../../../../core/common/widgets/my_button.dart';
import '../service/auth_service.dart';

class UserSignUpPage extends ConsumerWidget {
  const UserSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFormProvider);
    final formNotifier = ref.read(authFormProvider.notifier);
    final authMethod = ref.read(authMethodProvider);

    void signup() async {
      formNotifier.setLoading(true);
      final res = await authMethod.signupUser(
        email: formState.email,
        password: formState.password,
        name: formState.name,
      );
      formNotifier.setLoading(false);
      if (res == "success") {
        NavigationHelper.pushReplacement(context, UserLoginPage());
        mySnackBar(
          message: "Sign up successful! Now turn to Login",
          context: context,
        );
      } else {
        mySnackBar(message: res, context: context);
      }
    }

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height / 2.4,
              width: double.maxFinite,
              child: Image.asset("assets/signup.jpg", fit: BoxFit.cover),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifier.updateName(value),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Enter Your name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.nameError,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifier.updateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Enter Your Email",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.emailError,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifier.updatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: formState.isHiddenPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Enter Your Password",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.passwordError,
                      suffixIcon: IconButton(
                        onPressed: () {
                          formNotifier.togglePasswordVisibility();
                        },
                        icon: Icon(
                          formState.isHiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  formState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : MyButton(
                          onTap: formState.isFormValid ? signup : null,
                          buttonText: 'Sign Up',
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () =>
                            NavigationHelper.push(context, UserLoginPage()),
                        child: Text(
                          " Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
