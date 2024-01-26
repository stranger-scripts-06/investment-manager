import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  SearchResultsPage({required this.searchQuery});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final String apiKey = 'YOUR_FREE_API_KEY';
  final String suffix = '.BSE';
  String stockSymbol = '';
  Map<String, dynamic> stockData = {};

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
    Color tileColor = Colors.white; // Default color

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
