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
  final String symbol;
  int quantity=0;

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
  late List<Stock> myStocks = [];
  final String apiKey = 'SILP9TO8T400LMTL';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};
  double currentTotal=0;
  List<double> stockPrice = [];
  int index=0;

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
        '';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Global Quote')) {
          double price = double.parse(data['Global Quote']['05. price']);
          price = price*quantity;
          stockPrice.add(price);
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

    fetchStockDataForAll(myStocks);
    List<PieChartSectionData> sectionData = [];
    if (currentTotal == 0) {
      // Handle the case where currentTotal is zero to avoid division by zero
      return [
        PieChartSectionData(
          value: 100,
          color: Colors.red,
        )
      ];
    }
    for(Stock i in myStocks){
      if (i.price == 0) {
        continue;
      }
      double thisStockPrice = stockPrice[index];
      sectionData.add(
        PieChartSectionData(
          value: ((thisStockPrice/currentTotal)*100),
          color: Colors.grey,
        )
      );
      index++;
    }
    return sectionData;
  }

  List<PieChartSectionData> p1=[];
  @override

  Widget build(BuildContext context) {
    p1 = createSectionData();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchStockDataForAll(myStocks),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          p1 = createSectionData();
          return PieChart(
            PieChartData(
              sections: p1,
            ),
            swapAnimationDuration: const Duration(milliseconds: 750),
            swapAnimationCurve: Curves.easeInOut,
          );
        }
      },
    );
  }
}
