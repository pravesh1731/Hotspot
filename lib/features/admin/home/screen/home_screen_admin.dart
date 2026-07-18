import 'package:flutter/material.dart';
import 'package:hotspot/features/shared/service/google_auth_service.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        title: Text("Admin Dashboard"),
        centerTitle: true,
        leading: IconButton(onPressed: (){},
            icon: Icon(Icons.add_chart)),
        actions: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: Icon(Icons.supervised_user_circle_outlined,size: 30,),
            ),
          ),
          IconButton(onPressed: (){
            FirebaseServices().signOutUser();
          }, icon: Icon(Icons.logout))
        ],
      ),
      
      body: Center(
        child: Text(
          "Welcome Admin",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),),
    );
  }
}
