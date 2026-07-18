import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/theme/color.dart';
import 'package:hotspot/features/shared/screen/google_auth_screen.dart';
import 'package:hotspot/features/users/auth/screen/userSignUpScreen.dart';
import 'package:hotspot/features/users/home/home_screen.dart';
import 'package:hotspot/go_route.dart';
import '../../../../core/common/widgets/my_button.dart';
import '../../../../core/utils/utils.dart';
import '../service/auth_provider.dart';
import '../service/auth_service.dart';

class UserLoginPage extends ConsumerWidget{
  const UserLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFormProvider);
    final formNotifier = ref.read(authFormProvider.notifier);
    final authMethod = ref.read(authMethodProvider);

    void login() async {
      formNotifier.setLoading(true);
      final res = await authMethod.loginUser(
        email: formState.email,
        password: formState.password,
      );
      formNotifier.setLoading(false);
      if (res == "success") {
        NavigationHelper.pushReplacement(context, HomeScreen());
        mySnackBar(
          message: "Login successful!",
          context: context,
        );
      } else {
        mySnackBar(message: res, context: context);
      }
    }
    double height  = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
             height: height/2.3,
              width: double.maxFinite,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    spreadRadius: 20
                  )
                ]
              ),
              child: Image.asset("assets/login.jpg", fit: BoxFit.cover),
            ),
            SizedBox( height: 32),
            Padding(padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  autocorrect: false,
                  onChanged: (value) => formNotifier.updateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Enter Your Email",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(15),
                    errorText: formState.emailError
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
                formState.isLoading ? Center(child: CircularProgressIndicator()):
                MyButton(onTap: formState.isFormValid ? login : null, buttonText: 'Login',),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: Colors.grey)),
                    Text("OR"),
                    Expanded(child: Container(height: 1, color: Colors.grey)),

                  ],
                ),
                SizedBox(height: 20),
               GoogleLoginScreen(),
                Row(
                  children: [
                    Spacer(),
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: (){
                        NavigationHelper.push(context, UserSignUpPage());
                      },
                      child: Text(" SignUp",style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                ),



              ],
            ),
            )


          ],
        ),
      ),
    );
  }
}


