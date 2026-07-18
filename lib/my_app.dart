import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotspot/features/admin/home/screen/home_screen_admin.dart';
import 'package:hotspot/features/users/home/home_screen.dart';
import 'package:hotspot/global.dart';
import 'package:hotspot/features/admin/auth/adminLoginPage.dart';
import 'package:hotspot/features/users/auth/screen/userLoginPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong! ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return Global.baseUrl == "Admin App"
                ? const AdminHomeScreen()
                : const HomeScreen();
          } else {
            return Global.baseUrl == "Admin App"
                ? const AdminLoginPage()
                : const UserLoginPage();
          }
        },
      ),
    );
  }
}
