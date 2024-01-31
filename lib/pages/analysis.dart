import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockAnalysis extends StatefulWidget {
  final String stockSymbol;

  StockAnalysis({required this.stockSymbol});

  @override
  _StockAnalysisState createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  String data = '';
  String quoteType = '';
  String longName = '';
  String industry = '';
  double fiftyTwoWeekHigh = 0.0;
  double dividendRate = 0.0;
  double dividendYield = 0.0;
  double marketCap = 0.0;
  double debtToEquity = 0.0;
  double returnOnEquity = 0.0;
  double ebitdaMargins = 0.0;
  double trailingEps = 0.0;
  double forwardEps = 0.0;
  double trailingPE = 0.0;
  double forwardPE = 0.0;

  TextEditingController _symbolController = TextEditingController();
  List<dynamic> predictions = [];

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000'),
        body: {'symbol': widget.stockSymbol},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result =
            json.decode(response.body); // Use json.decode instead of jsonDecode
        setState(() {
          data = result.toString(); // Convert map to string for display
          quoteType = result['quoteType'].toString();
          longName = result['longName'].toString();
          industry = result['industry'].toString();
          fiftyTwoWeekHigh =
              double.parse(result['fiftyTwoWeekHigh'].toString());
          dividendRate = double.parse(result['dividendRate'].toString());
          dividendYield = double.parse(result['dividendYield'].toString());
          marketCap = double.parse(result['marketCap'].toString());
          debtToEquity = double.parse(result['debtToEquity'].toString());
          returnOnEquity = double.parse(result['returnOnEquity'].toString());
          ebitdaMargins = double.parse(result['ebitdaMargins'].toString());
          trailingEps = double.parse(result['trailingEps'].toString());
          forwardEps = double.parse(result['forwardEps'].toString());
          trailingPE = double.parse(result['trailingPE'].toString());
          forwardPE = double.parse(result['forwardPE'].toString());
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Stock Information for ${widget.stockSymbol}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Text(
              //   'Data: $data',
              //   style: TextStyle(color: Colors.white),
              // ),
              SizedBox(height: 20),
              Text(
                'Quote Type: $quoteType',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Long Name: $longName',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Industry: $industry',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                '52-Week High: $fiftyTwoWeekHigh',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Dividend Rate: $dividendRate',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Dividend Yield: $dividendYield',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Market Cap: $marketCap',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Debt to Equity: $debtToEquity',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Return on Equity: $returnOnEquity',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'EBITDA Margins: $ebitdaMargins',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Trailing EPS: $trailingEps',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Forward EPS: $forwardEps',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Trailing PE: $trailingPE',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Forward PE: $forwardPE',
                style: TextStyle(color: Colors.white),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
