import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investment_manager/auth/authpage.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phonenumberController = TextEditingController();

  @override
  void disposal() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.0,
              ),
              Text("Sign Up",
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xFFF9FAF8),
                  )),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: Image(
                    image: AssetImage('assets/loginlogo.png'),
                    fit: BoxFit.cover,
                    color: Color(0xFFF9FAF8)),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 16.0, 40.0, 0.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Name"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)),
                        hintText: ("Enter your name"),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Email"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)),
                        hintText: ("Enter email address"),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Phone Number"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)),
                        hintText: ("Enter phone number"),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Password"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)),
                        hintText: ("Enter your password"),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Confirmation"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)),
                        hintText: ("Re-enter password"),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  signUp();
                }, //make pushReplacementNamed later
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                  foregroundColor: MaterialStatePropertyAll(Colors.grey[900]),
                  fixedSize: MaterialStatePropertyAll(Size(330, 60)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.g_mobiledata),
                label: Text("Login with Google"),
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(330, 50)),
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.yellow, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xFFF0E68C),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      ' Login',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
