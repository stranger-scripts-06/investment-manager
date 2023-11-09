import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              Text("App Name",
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
                        labelText: ("Email/Phone"),
                        hintText: ("Enter email address/phone number"),
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
                    //
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                  onPressed: (){},
                  child: Text("Forgot Password"),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, '/home');
                  },//make pushReplacementNamed later
                      child: Text("Login"),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                      child: Text("Sign Up"),
                  ),
                ],
              ),
             TextButton.icon(onPressed: (){},
                 icon: Icon(Icons.g_mobiledata), label: Text("Login with Google"),
             )

            ],
          ),
        ),
      ),
    );
  }
}