import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final user = FirebaseAuth.instance.currentUser!;
  //TODO: Uncomment the above line and ask Sanhita what could be the issue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",
                  style: TextStyle(
                    color: Color(0xFFF9FAF8),
                    fontSize: 28.0,
                ),
              ),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushNamed(context, '/settings');
        },
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
                height: 250,
                width: 375,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Pie Chart",
                style: TextStyle(
                  color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/stocks');
              },
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset("assets/Icons/stocksIconHajicon.png"),
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Text("Stocks",
                      style: TextStyle(
                        color: Color(0xFFF9FAF8),
                        fontSize: 28,
                        ),
                      ),
                      SizedBox(
                        width: 110,
                      ),
                      Container(
                        child: Icon(Icons.arrow_forward,
                        color: Color(0xFFF9FAF8),
                        ),
                      ),
                    ],
                  ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF313131)),
                  fixedSize: MaterialStatePropertyAll(Size(375, 60)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/mutualfunds');
              },
                child: Row(
                  children: [
                    Container(
                      child: Image.asset("assets/Icons/mutualFundIconPopVectors.png"),
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Text("Mutual Funds",
                      style: TextStyle(
                        color: Color(0xFFF9FAF8),
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: 46,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward,
                        color: Color(0xFFF9FAF8),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF313131)),
                  fixedSize: MaterialStatePropertyAll(Size(375, 60)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/gold');
              },
                child: Row(
                  children: [
                    Container(
                      child: Image.asset("assets/Icons/goldIconVectorStall.png"),
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Text("Gold",
                      style: TextStyle(
                        color: Color(0xFFF9FAF8),
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward,
                        color: Color(0xFFF9FAF8),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF313131)),
                  fixedSize: MaterialStatePropertyAll(Size(375, 60)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(onPressed: (){},
                child: Row(
                  children: [
                    Container(
                      child: Image.asset("assets/Icons/newsIconFreepik.png"),
                      height: 47,
                      width: 47,
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Text("News",
                      style: TextStyle(
                        color: Color(0xFFF9FAF8),
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(
                      width: 130,
                    ),
                    Container(
                      child: Icon(Icons.arrow_forward,
                        color: Color(0xFFF9FAF8),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF313131)),
                  fixedSize: MaterialStatePropertyAll(Size(375, 60)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), //
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){},
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
