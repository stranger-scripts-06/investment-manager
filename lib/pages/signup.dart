import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                    color: Colors.black,
                  )),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: Image(image: AssetImage('assets/loginlogo.png'),
                    fit: BoxFit.cover),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: ("Email"),
                        hintText: ("Enter email address"),
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Phone Number"),
                        hintText: ("Enter Phone Number"),
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        hintText: ("Enter Password"),
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Confirm Password"),
                        hintText: ("Re-enter password"),
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    //
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Already have an account?"),
              ElevatedButton(onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
              },
                  child: Text("Login"),
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
                child: Text("Sign Up"),
              ),
              TextButton.icon(onPressed: () {},
                icon: Icon(Icons.g_mobiledata),
                label: Text("Sign Up with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
