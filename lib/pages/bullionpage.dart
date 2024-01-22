import 'package:flutter/material.dart';

class BullionPage extends StatefulWidget {
  const BullionPage({super.key});

  @override
  State<BullionPage> createState() => _BullionPageState();
}

class _BullionPageState extends State<BullionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bullion",
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
                height: 100,
                width: 375,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Stocks owned",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
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
                child: Text("Graph",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 200,
                width: 375,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text("Recomendations",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
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
