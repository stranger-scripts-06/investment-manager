import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as Math;
class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class Stock {
  double price=0.0;
  int quantity=0;
  final String symbol;

  Stock({required this.quantity, required this. price, required this. symbol});

  factory Stock.fromMap(Map<dynamic, dynamic> map) {
    return Stock(
      price: map['price']?.toDouble() ?? 0.0,
      symbol: map['symbol'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}

class _MyPieChartState extends State<MyPieChart> {
  late List<Stock> myStocks;
  final String apiKey = 'YOUR_FREE_API_KEY';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};

  @override
  void initState() {
    super.initState();
    fetchStocks();

  }

  Future<void> fetchStocks() async {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;

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
      }
      );
    } catch (e) {
      print('Error fetching stocks: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStockData(String symbol, int quantity) async {
    stockSymbol = symbol;
    final String symbolWithBSE = '$stockSymbol$suffix'.replaceAll(' ', '%20');
    final String apiUrl =
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbolWithBSE&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Global Quote')) {
          double price = double.parse(data['05. price']);
          price = price*quantity;
          currentTotal = currentTotal+price;
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

  Future<List<Map<String, dynamic>>> fetchStockDataForAll(List<Stock> stocks) async {
    List<Future<Map<String, dynamic>>> futures = [];

    for (Stock s in stocks) {
      String symbol = s.symbol;
      int quantity = s.quantity;
      futures.add(fetchStockData(symbol, quantity));
    }

    return await Future.wait(futures);
  }


  Color getRandomColor() {
    return Color((Math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  List<PieChartSectionData> createSectionData(){
    List<PieChartSectionData> sectionData = [];
    for(Stock i in myStocks){
      sectionData.add(
        PieChartSectionData(
          value: ((i.price/currentTotal)*100),
          color: getRandomColor(),
        )
      );
    }
    return sectionData;
  }

  double currentTotal = 0;
  List<PieChartSectionData> p1=[];
  @override

  Widget build(BuildContext context) {
    p1 = createSectionData();
    return PieChart(
      PieChartData(
        sections: p1,
      ),
      swapAnimationDuration: const Duration(milliseconds: 750),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
