import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'pages/signup.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),



      },
  )
);

