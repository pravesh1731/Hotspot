import 'package:flutter/material.dart';
import 'package:hotspot/features/shared/screen/google_auth_screen.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(child:
        Padding(
          padding: const EdgeInsets.only(top: 400.0),
          child: GoogleLoginScreen(),
        )),
    );
  }
}
