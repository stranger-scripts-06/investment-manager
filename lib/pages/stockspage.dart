import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:investment_manager/pages/indivstock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class StocksPage extends StatefulWidget {
  @override
  State<StocksPage> createState() => _StocksPageState();
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

class _StocksPageState extends State<StocksPage> {
  late List<Stock> myStocks;
  late List<Stock> myWatchlist;
  TextEditingController searchController = TextEditingController();

  final String apiKey = 'YOUR_FREE_API_KEY';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};

  @override
  void initState() {
    super.initState();
    fetchStocks();
    fetchWatchlist();
    searchController.addListener(() {
      setState(
          () {
          }); // Trigger a rebuild when the text in the search box changes
    });
  }

  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    stockSymbol = symbol;
    final String symbolWithBSE = '$stockSymbol$suffix'.replaceAll(' ', '%20');
    final String apiUrl =
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbolWithBSE&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Global Quote')) {
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

  Future<List<Map<String, dynamic>>> fetchStockDataForAll(List<String> symbols) async {
    List<Future<Map<String, dynamic>>> futures = [];

    for (var symbol in symbols) {
      futures.add(fetchStockData(symbol));
    }

    return await Future.wait(futures);
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
        _isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  Future<void> fetchWatchlist() async {
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
          .collection('Watchlist')
          .get();

      // Map the documents to Stock objects
      List<Stock> fetchedWatchlist =
      snapshot.docs.map((doc) => Stock.fromMap(doc.data())).toList();

      setState(() {
        myWatchlist = fetchedWatchlist;
        _isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  void _performSearch(String query) {
    // Navigate to search results page with the entered query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(searchQuery: query),
      ),
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? waiting()
        : Scaffold(
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
                IconButton(
                  onPressed: () {
                    _performSearch(searchController.text);
                  },
                  icon: Icon(Icons.search),
                  color: Color(0xFFF9FAF8),
                ),
              ],
              backgroundColor: Colors.black,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (query) {
                      _performSearch(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Stocks...',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
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
                              )
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "My Stocks",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                          child:FutureBuilder(
                            future: fetchStockDataForAll(myStocks.map((stock) => stock.symbol).toList()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error loading data');
                              } else {
                                List<Map<String, dynamic>> stockDataList = snapshot.data as List<Map<String, dynamic>>;

                                return ListView.builder(
                                  itemCount: myStocks.length,
                                  itemBuilder: (context, index) {
                                    var stock = myStocks[index];
                                    var stockData = stockDataList[index];

                                    var price = stockData?['05. price'];
                                    var changePercent = stockData?['10. change percent'];
                                    var changePercentValue;
                                    if(changePercent!=null) {
                                      changePercentValue = double.parse(changePercent.replaceAll('%', ''));
                                    }
                                    else{
                                      changePercentValue = null;
                                    }
                                    Color tileColor;
                                    if(changePercentValue!=null && changePercentValue<0){
                                      tileColor = Colors.redAccent;
                                    }
                                    else{
                                      tileColor = Colors.green;
                                    }
                                    if(index==myStocks.length-1){
                                      return GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight: Radius.circular(20.0),
                                            ),
                                            color: tileColor,
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              stock.symbol,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            trailing: Text(
                                              '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          showModalBottomSheet(context: context, builder: (BuildContext){
                                            return Container(
                                              width: 330,
                                              height: 300,
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
                                                        Text('${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                                          style: TextStyle(color: tileColor),),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Expected Price:"),
                                                        SizedBox(width: 40),
                                                        Text('I have no idea ', style: TextStyle(color: tileColor),),
                                                      ],
                                                    ),
                                                    ElevatedButton(onPressed: (){}, child: Text("More Info")),

                                                  ],
                                                ),
                                              ),
                                            );
                                            },
                                          );
                                        },
                                      );
                                    }
                                      return GestureDetector(
                                        child: Container(
                                          color: tileColor,
                                          child: ListTile(
                                            title: Text(
                                              stock.symbol,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            trailing: Text(
                                              '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          showModalBottomSheet(context: context, builder: (BuildContext){
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
                                                          Text('${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                                            style: TextStyle(color: tileColor),),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("Expected Price:"),
                                                          SizedBox(width: 40),
                                                          Text('I have no idea ', style: TextStyle(color: tileColor),),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 200,
                                                        width: 330,
                                                        child: WebviewScaffold(
                                                          url: "https://in.tradingview.com/chart/?symbol=NSE%3A" + stock.symbol,
                                                          withZoom: false,
                                                          withJavascript: true,
                                                        ),
                                                      ),
                                                      ElevatedButton(onPressed: (){}, child: Text("More Info")),
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
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 190,
                      width: 330,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF313131),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            width: 330,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                  bottom: Radius.zero,
                                )
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Watchlist",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
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
                            child: FutureBuilder(
                              future: fetchStockDataForAll(myWatchlist.map((stock) => stock.symbol).toList()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error loading data');
                                } else {
                                  List<Map<String, dynamic>> stockDataList = snapshot.data as List<Map<String, dynamic>>;

                                  return ListView.builder(
                                    itemCount: myWatchlist.length,
                                    itemBuilder: (context, index) {
                                      var stock = myWatchlist[index];
                                      var stockData = stockDataList[index];

                                      var price = stockData?['05. price'];
                                      var changePercent = stockData?['10. change percent'];
                                      var changePercentValue;
                                      if(changePercent!=null) {
                                        changePercentValue = double.parse(changePercent.replaceAll('%', ''));
                                      }
                                      else{
                                        changePercentValue = null;
                                      }
                                      Color tileColor;
                                      if(changePercentValue!=null && changePercentValue<0){
                                        tileColor = Colors.redAccent;
                                      }
                                      else{
                                        tileColor = Colors.green;
                                      }
                                      if(index==myStocks.length-1){
                                        return GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20.0),
                                                bottomRight: Radius.circular(20.0),
                                              ),
                                              color: tileColor,
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                stock.symbol,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              trailing: Text(
                                                '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                              ),
                                            ),
                                          ),
                                          onTap: (){
                                            showModalBottomSheet(context: context, builder: (BuildContext){
                                              return Container(
                                                width: 330,
                                                height: 300,
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
                                                          Text('${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                                            style: TextStyle(color: tileColor),),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("Expected Price:"),
                                                          SizedBox(width: 40),
                                                          Text('I have no idea ', style: TextStyle(color: tileColor),),
                                                        ],
                                                      ),
                                                      ElevatedButton(onPressed: (){}, child: Text("More Info")),

                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            );
                                          },
                                        );
                                      }
                                      return GestureDetector(
                                        child: Container(
                                          color: tileColor,
                                          child: ListTile(
                                            title: Text(
                                              stock.symbol,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            trailing: Text(
                                              '${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          showModalBottomSheet(context: context, builder: (BuildContext){
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
                                                        Text('${price ?? 'Loading'} ${changePercent ?? 'Loading'}',
                                                          style: TextStyle(color: tileColor),),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Expected Price:"),
                                                        SizedBox(width: 40),
                                                        Text('I have no idea ', style: TextStyle(color: tileColor),),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 200,
                                                      width: 330,
                                                      child: WebviewScaffold(
                                                        url: "https://in.tradingview.com/chart/?symbol=NSE%3A" + stock.symbol,
                                                        withZoom: false,
                                                        withJavascript: true,
                                                      ),
                                                    ),
                                                    ElevatedButton(onPressed: (){}, child: Text("More Info")),

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
                            ),
                          ),
                        ],
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
