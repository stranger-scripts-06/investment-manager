import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockAnalysis extends StatefulWidget {
  final String stockSymbol;
  StockAnalysis({required this.stockSymbol});
  @override
  _StockAnalysisState createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  String imageUrl = 'http://127.0.0.1:5000/static/forecast_plot.png';
  List<dynamic> stockData = [];
  bool _isLoading = false;

  Future<void> _fetchAnalysis() async {
    setState(() {
      _fetchAnalysis();
    });

    const String baseUrl = '';
    final String stockSymbol = widget.stockSymbol;
    final String apiUrl = '$baseUrl?stockSymbol=$stockSymbol';

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          stockData = data as List<dynamic>;
        });
      } else {
        print('Error:${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _fetchAnalysis();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stockSymbol),
        backgroundColor: Color.fromARGB(255, 255, 251, 228),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: stockData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(stockData[index]),
                  );
                },
              ),
            ),
            FutureBuilder(
              future: http.get(Uri.parse(imageUrl)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading image: ${snapshot.error}');
                } else {
                  // Check if the response bodyBytes is not null before accessing it
                  return snapshot.data?.bodyBytes != null
                      ? Image.memory(snapshot.data!.bodyBytes)
                      : Text('Image data is null');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
