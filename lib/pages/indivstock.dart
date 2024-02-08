import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:investment_manager/pages/analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  SearchResultsPage({required this.searchQuery});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _quantityController = TextEditingController();
  final String apiKey = 'YOUR_FREE_API_KEY';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};

  Future<void> addStocks(String symbol, double price, int quantity, String email) async{
    final docId = FirebaseFirestore.instance.collection('users').doc(email).id;
    String path = 'users/'+docId+'/myStocks';
    await FirebaseFirestore.instance.collection(path).add({
      'symbol': symbol,
      'price' : price,
      'quantity': quantity,
    }
    );
  }


  void _showQuantityDialog(String stockSymbol, double price, String email) {
    int quantity = 1; // Default quantity
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the Quantity of stock'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Quantity'),
            onChanged: (value) {
              quantity = int.tryParse(value) ?? 1; // If parsing fails, default to 1
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                addStocks(stockSymbol, price, quantity, email);
              },
              child: Text('Add to my stocks'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addWatchlist(String symbol, String email) async{
    final docId = FirebaseFirestore.instance.collection('users').doc(email).id;
    String path = 'users/'+docId+'/Watchlist';
    await FirebaseFirestore.instance.collection(path).add({
      'symbol': symbol,
    }
    );
  }

  @override
  void initState() {
    super.initState();
    stockSymbol = widget.searchQuery;
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final String symbolWithBSE = '$stockSymbol$suffix'.replaceAll(' ', '%20');
    final String apiUrl =
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbolWithBSE&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Global Quote')) {
          setState(() {
            stockData = data['Global Quote'];
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchQuery),
        backgroundColor: Color.fromARGB(255, 255, 251, 228),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                if (stockData.isNotEmpty) ..._buildStockInfo(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {// Navigate to the second page and pass the variable
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StockAnalysis(stockSymbol: stockSymbol),
                      ),
                    );
                  },
                  child: Text('More Info'),
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(110,50))
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      ElevatedButton(onPressed: (){
                        _showQuantityDialog(stockSymbol, double.parse(stockData['05. price']), email);
                      },
                          child: Text("Buy Stock",
                          style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(120,50))
                          ),
                      ),
                      ElevatedButton(onPressed: (){
                        addWatchlist(stockSymbol, email);
                      }, child: Text("Watchlist"),
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size(120,50))
                        ),),
                    ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStockInfo() {
    return [
      _buildParameter('Open', stockData['02. open']),
      _buildParameter('High', stockData['03. high']),
      _buildParameter('Low', stockData['04. low']),
      _buildParameter('Price', stockData['05. price']),
      _buildParameter('Volume', stockData['06. volume']),
      _buildParameter('Latest Day', stockData['07. latest trading day']),
      _buildParameter('Previous Close', stockData['08. previous close']),
      _buildParameter('Change', stockData['09. change']),
      _buildParameter('Change Percent', stockData['10. change percent']),
    ];
  }

  Widget _buildParameter(String label, String value) {
    Color tileColor = Color.fromARGB(255, 255, 251, 228); // Default color

    if (label == 'Change' || label == 'Change Percent') {
      // Extract numeric value and remove '%' if 'Change Percent'
      double numericValue = label == 'Change Percent'
          ? double.tryParse(value.replaceAll('%', '')) ?? 0.0
          : double.tryParse(value) ?? 0.0;

      print('Numeric Value for $label: $numericValue');

      // Set tile color based on positive or negative value of 'Change'
      tileColor = numericValue >= 0 ? Colors.green : Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Choose text color
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black, // Choose text color
            ),
          ),
        ],
      ),
    );
  }
}
