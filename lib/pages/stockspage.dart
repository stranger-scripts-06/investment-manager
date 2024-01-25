import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StocksPage extends StatefulWidget {
  @override
  State<StocksPage> createState() => _StocksPageState();
}

class Stock {
  final String name;
  final String symbol;

  

  Stock({required this.name, required this.symbol});

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
        name: map['name'] ?? '',
        symbol: map['symbol'] ?? '',
      );
    }
  }

class _StocksPageState extends State<StocksPage> {
  late List<Stock> myStocks;

  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  Widget waiting(){
    return CircularProgressIndicator();
  }

  Future<void> fetchStocks() async {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;

    setState(() {_isLoading = true;});

    try {
      while(ConnectionState == ConnectionState.waiting){
        waiting();
      }
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
      });
      setState(() {
          myStocks = fetchedStocks;
          _isLoading = false; // Set loading state to false after data is fetched
        }
      );
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? waiting() : Scaffold(
      appBar: AppBar(
        title: Text(
          "Stocks",
          style: TextStyle(
            color: Color(0xFFF9FAF8),
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
          icon: Icon(Icons.menu),
          color: Color(0xFFF9FAF8),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
                width: 330,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Graph",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  height: 190,
                  width: 330,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF313131),
                  ),
                  child: Column(children: [
                    Container(
                      height: 35,
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.zero,
                          )),
                      child: Text(
                        "My Stocks",
                        style: TextStyle(
                          color: Colors.black,

                        ),
                      ),
                    ),
                    Container(
                      height: 155,
                      width: 330,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF313131),
                      ),
                      alignment: Alignment.center,
                      child: myStocks != null
                          ? ListView.builder(
                              itemCount: myStocks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(myStocks[index].name),
                                  subtitle:
                                      Text('Symbol: ${myStocks[index].symbol}'),
                                );
                              },
                            )
                          : CircularProgressIndicator(),
                    ),
                  ]),
                ),
              ]),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF313131),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Watchlist/Top losers and gainers",
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
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    icon: Icon(
                      Icons.home,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/portfolio');
                    },
                    icon: Icon(
                      Icons.perm_contact_cal_rounded,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_money_rounded,
                      size: 50,
                    ),
                    color: Color(0xFFF9FAF8),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu_book,
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
