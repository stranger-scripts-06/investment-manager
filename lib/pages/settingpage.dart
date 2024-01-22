import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",
          style: TextStyle(
            color: Color(0xFFF9FAF8),
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(onPressed: (){},
          icon: Icon(Icons.menu),
          color: Color(0xFFF9FAF8),
        ),
        actions: [
          IconButton(onPressed: (){},
            icon: Icon(Icons.notifications),
            color: Color(0xFFF9FAF8),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                child:Icon(Icons.settings, size: 100, color: Colors.white,),
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Change email address",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Change password",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Notification Settings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Display Settings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Legal Information",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, '/home');
                  },
                    icon: Icon(Icons.home,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, '/portfolio');
                  },
                    icon: Icon(Icons.perm_contact_cal_rounded,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, '/stocks');
                  },
                    icon: Icon(Icons.attach_money_rounded,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(onPressed: (){},
                    icon: Icon(Icons.menu_book,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
