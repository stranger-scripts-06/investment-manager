import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investment_manager/auth/authpage.dart';
import 'package:investment_manager/pages/homepage.dart';
import 'package:investment_manager/pages/loginpage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return HomePage();
            }
            // user is not logged in
            else {
              return AuthPage();
            }
          },
        ),
    );
  }
}
