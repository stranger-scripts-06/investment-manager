import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void disposal() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Link sent'),
            );
          }
        );
    }

    on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Email the link'),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              iconColor: Colors.white,
              labelText: ("Email/Phone"),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFF9FAF8)),
              hintText: ("Enter email address/phone number"),
              hintStyle: TextStyle(
                color: Color(0xFFF9FAF8),
              ),
              border: OutlineInputBorder(),
              fillColor: Color(0xFF313131),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF0E68C),
                ),
              ),
            ),
            style: TextStyle(color: Color(0xFFF9FAF8)),
          ),
          MaterialButton(
            onPressed: () {
              passwordReset();
            },
            child: Text('Reset Password'),
            
          )
        ],
      ),
    );
  }
}
