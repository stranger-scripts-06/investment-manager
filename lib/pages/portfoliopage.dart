import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:investment_manager/pages/indivstock.dart';
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class Stock {
  double price=0.0;
  final String symbol;

  Stock({required this. price, required this. symbol});

  factory Stock.fromMap(Map<dynamic, dynamic> map) {
    return Stock(
      price: map['price']?.toDouble() ?? 0.0,
      symbol: map['symbol'] ?? '',
    );
  }
}

class _PortfolioPageState extends State<PortfolioPage> {
  late List<Stock> myStocks;

  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  Widget waiting() {
    return Center(child:CircularProgressIndicator());
  }

  Future<void> fetchStocks() async {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;

    setState(() {
      _isLoading = true;
    }
    );

    try {
      // Replace 'user_id' with the actual user ID
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(email)
          .collection('myStocks')
          .get();

      // Map the documents to Stock objects
      List<Stock> fetchedStocks =
      snapshot.docs.map((doc) => Stock.fromMap(doc.data())).toList();

      setState(() {
          myStocks = fetchedStocks;
          _isLoading = false;
        }
      );
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  Widget buildDisplay(){
      return (myStocks != null
            ? ListView.builder(
                itemCount: myStocks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(myStocks[index].symbol),
                    subtitle: Text(
                '     Symbol: ${myStocks[index].price.toString()}'),
          );
        },
      )
          : CircularProgressIndicator());
    }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
      return _isLoading
          ? waiting()
    : Scaffold(
      appBar: AppBar(
        title: Text("Protfolio",
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
              SizedBox(
                height: 15.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 90,
                      width: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      alignment: Alignment.center,
                      child: Text("Net Worth",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      width: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      alignment: Alignment.center,
                      child: Text("Day's Gain",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 450,
                width: 500,
                child: buildDisplay(),
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
                  IconButton(onPressed: (){},
                    icon: Icon(Icons.perm_contact_cal_rounded,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(onPressed: (){},
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


