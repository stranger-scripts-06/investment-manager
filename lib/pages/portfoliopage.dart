import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class Stock {
  double price = 0.0;
  int quantity = 0;
  final String symbol;

  Stock({required this.quantity, required this.price, required this.symbol});

  factory Stock.fromMap(Map<dynamic, dynamic> map) {
    return Stock(
      price: map['price']?.toDouble() ?? 0.0,
      symbol: map['symbol'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}

class _PortfolioPageState extends State<PortfolioPage> {
  late List<Stock> myStocks;
  final String apiKey = 'YOUR_FREE_API_KEY';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};
  bool _isLoading = false;
  double currentTotal = 0;
  double boughtTotal = 0;

  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  Widget waiting() {
    return Center(child: CircularProgressIndicator());
  }

  Future<void> fetchStocks() async {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;

    setState(() {
      _isLoading = true;
    });

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

      calculateBuyTotal(fetchedStocks);

      setState(() {
        myStocks = fetchedStocks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStockData(
      String symbol, int quantity) async {
    stockSymbol = symbol;
    final String symbolWithBSE = '$stockSymbol$suffix'.replaceAll(' ', '%20');
    final String apiUrl = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbolWithBSE&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Global Quote')) {
          double price = double.parse(data['Global Quote']['05. price']);
          price = price * quantity;
          currentTotal = currentTotal + price;
          return data['Global Quote'];
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> fetchStockDataForAll(
      List<Stock> stocks) async {
    List<Future<Map<String, dynamic>>> futures = [];

    for (Stock s in stocks) {
      String symbol = s.symbol;
      int quantity = s.quantity;
      futures.add(fetchStockData(symbol, quantity));
    }

    return await Future.wait(futures);
  }

  void calculateBuyTotal(List<Stock> myStocks) {
    for (Stock i in myStocks) {
      double price = i.price;
      int quantity = i.quantity;
      price = price * quantity;
      boughtTotal = boughtTotal + price;
    }
  }

  Widget buildDisplay() {
    return FutureBuilder(
      future: fetchStockDataForAll(myStocks),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data');
        } else {
          List<Map<String, dynamic>> stockDataList =
              snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: myStocks.length,
            itemBuilder: (context, index) {
              var stock = myStocks[index];
              var stockData = stockDataList[index];
              var price = stockData?['05. price'];
              var changePercent = stockData?['10. change percent'];
              var changePercentValue;
              if (changePercent != null) {
                changePercentValue =
                    double.parse(changePercent.replaceAll('%', ''));
              } else {
                changePercentValue = null;
              }
              Color tileColor;
              if (changePercentValue != null && changePercentValue < 0) {
                tileColor = Colors.redAccent;
              } else {
                tileColor = Colors.green;
              }
              return GestureDetector(
                child: Container(
                  color: tileColor,
                  child: ListTile(
                    title: Text(
                      stock.symbol,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext) {
                      return Container(
                        width: 330,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("${stock.symbol}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Current Price:"),
                                  SizedBox(width: 40),
                                  Text(
                                    '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                    style: TextStyle(color: tileColor),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Expected Price:"),
                                  SizedBox(width: 40),
                                  Text(
                                    'I have no idea ',
                                    style: TextStyle(color: tileColor),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {}, child: Text("More Info")),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? waiting()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Portfolio",
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
                            child: Text(
                              "Net Worth: $currentTotal",
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
                            child: Text(
                              "Day's Gain: 0.0",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ]),
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
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          icon: Icon(
                            Icons.home,
                            size: 40,
                          ),
                          color: Color(0xFFF9FAF8),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.perm_contact_cal_rounded,
                            size: 40,
                          ),
                          color: Color(0xFFF9FAF8),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.attach_money_rounded,
                            size: 40,
                          ),
                          color: Color(0xFFF9FAF8),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.menu_book,
                            size: 40,
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
