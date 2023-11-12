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
                    color: Color(0xFFF9FAF8),
                  )),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: Image(image: AssetImage('assets/loginlogo.png'),
                  fit: BoxFit.cover,
                  color: Color(0xFFF9FAF8),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 16.0, 40.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        labelText: ("Email/Phone"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8)
                        ),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAF8),
                        ),
                        hintText: ("Enter Password"),
                        hintStyle: TextStyle(
                          color: Color(0xFFF9FAF8),
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFF313131),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF0E68C)
                          ),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFFF9FAF8)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: (){},
                child: Text("Forgot Password?"),
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/home');
              },//make pushReplacementNamed later
                child: Text("Login",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                  foregroundColor: MaterialStatePropertyAll(Colors.grey[900]),
                  fixedSize: MaterialStatePropertyAll(Size(330, 60)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 30.0
              ),
              ElevatedButton.icon(onPressed: (){},
                icon: Icon(Icons.g_mobiledata), label: Text("Login with Google"),
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(330, 50)),
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.yellow, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/home');
                },
                child: Text("New Here? Sign Up"),
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Color(0xFFF0E68C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
