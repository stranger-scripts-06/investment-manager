import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForecastApp extends StatefulWidget {
  @override
  _ForecastAppState createState() => _ForecastAppState();
}

class _ForecastAppState extends State<ForecastApp> {
  TextEditingController _symbolController = TextEditingController();
  List<dynamic> predictions = [];

  Future<void> getForecast() async {
    final String apiUrl = 'http://127.0.0.1:5000/forecast';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'symbol': _symbolController.text},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          predictions = List<dynamic>.from(data['predictions']);
        });
      } else {
        setState(() {
          // Handle error scenario
        });
      }
    } catch (error) {
      setState(() {
        // Handle error scenario
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Forecast App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _symbolController,
                decoration: InputDecoration(labelText: 'Enter symbol'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => getForecast(),
                child: Text('Get Forecast'),
              ),
              SizedBox(height: 20),
              Text(
                'Predictions:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Day ${index + 1}: ${predictions[index]}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
