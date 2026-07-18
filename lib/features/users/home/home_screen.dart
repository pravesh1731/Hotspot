import 'package:flutter/material.dart';
import 'package:hotspot/features/users/auth/screen/userLoginPage.dart';
import 'package:hotspot/features/users/auth/service/auth_service.dart';
import 'package:hotspot/go_route.dart';

AuthMethod authMethod = AuthMethod();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authMethod.logout();
            NavigationHelper.pushReplacement(context, UserLoginPage());
          },
          child: Text("SignOut"),
        ),
      ),
    );
  }
}
