import 'package:flutter/material.dart';
import 'package:investment_manager/pages/homepage.dart';
import 'package:investment_manager/pages/loginpage.dart';
import 'package:investment_manager/pages/signup.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => LoginPage(),
    '/signup': (context) => SignUpPage(),
    '/home': (context) => HomePage(),
  },
)
);
