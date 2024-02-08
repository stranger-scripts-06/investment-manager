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
        if (mounted) {
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
        }
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
        backgroundColor: const Color.fromARGB(255, 247, 231, 186),
        title: Text('Stock Information for : ${widget.stockSymbol}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 212, 242, 129),
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  '$longName',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 35, 62),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$industry',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 35, 62),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$quoteType',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 20),
              _buildInfoText('52-Week High:', fiftyTwoWeekHigh),
              _buildInfoText('Dividend Rate:', dividendRate),
              _buildInfoText('Dividend Yield:', dividendYield),
              _buildInfoText('Market Cap:', marketCap),
              _buildInfoText('Debt to Equity:', debtToEquity),
              _buildInfoText('Return on Equity:', returnOnEquity),
              _buildInfoText('EBITDA Margins:', ebitdaMargins),
              _buildInfoText('Trailing EPS:', trailingEps),
              _buildInfoText('Forward EPS:', forwardEps),
              _buildInfoText('Trailing PE:', trailingPE),
              _buildInfoText('Forward PE:', forwardPE),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoText(String label, double value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 54, 62, 105),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
