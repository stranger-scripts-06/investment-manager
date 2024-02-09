import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForecastApp extends StatefulWidget {
  @override
  _ForecastAppState createState() => _ForecastAppState();
}

class _ForecastAppState extends State<ForecastApp> {
  int _currentIndex = 0;
  String imageUrl = 'http://127.0.0.1:5000/static/forecast_plot.png';
  TextEditingController _symbolController = TextEditingController();
  List<dynamic> predictions = [];
  String recommendation = '';
  bool _isLoading = false;
  bool showRecommendationImage = false;

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

  Future<void> getIndicator() async {
    final String apiUrl = 'http://127.0.0.1:5000/buysell';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'symbol': _symbolController.text},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          // Extract recommendation value as a string
          recommendation = data['buy_sell_ind'].toString();
          showRecommendationImage = true;
        });
        // if (recommendation == 'STRONG BUY') {
        //   imagePath = 'assets/Image/strong_buy.png';
        // } else if (recommendation == 'BUY') {
        //   imagePath = 'assets/Image/buy.png';
        // } else if (recommendation == 'SELL') {
        //   imagePath = 'assets/Image/sell.png';
        // } else {
        //   imagePath = 'assets/Image/hold.png';
        // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 30, 35, 62),
        title: Text(
          'Stock Prediction',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentIndex == 0
                ? Padding(
                    key: ValueKey<int>(0),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _symbolController,
                            decoration: InputDecoration(
                              hintText: 'Enter symbol',
                              border: InputBorder.none, // Remove border
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () => getForecast(),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 30, 35, 62),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Get Predictions',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              return _buildInfoText(
                                'Day ${index + 1}',
                                predictions[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentIndex == 1
                ? Padding(
                    key: ValueKey<int>(1),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _symbolController,
                            decoration: InputDecoration(
                              hintText: 'Enter symbol',
                              border: InputBorder.none, // Remove border
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              // Perform future request to fetch image
                              http.get(Uri.parse(imageUrl)).then((response) {
                                setState(() {
                                  _isLoading = true;
                                });
                              }).catchError((error) {
                                setState(() {
                                  _isLoading = false;
                                });
                                print('Error loading image: $error');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 30, 35, 62),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Show Graph',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (_isLoading)
                          FutureBuilder(
                            future: http.get(Uri.parse(imageUrl)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error loading image: ${snapshot.error}');
                              } else {
                                return snapshot.data?.bodyBytes != null
                                    ? Image.memory(snapshot.data!.bodyBytes)
                                    : Text('Image data is null');
                              }
                            },
                          ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentIndex == 2
                ? Padding(
                    key: ValueKey<int>(2),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _symbolController,
                            decoration: InputDecoration(
                              hintText: 'Enter symbol',
                              border: InputBorder.none, // Remove border
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () => getIndicator(),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 30, 35, 62),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Get Buy/Sell Indicator',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Text(
                        //   'Recommendation: $recommendation',
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        if (showRecommendationImage) // Only show the image if the flag is true
                          Image.asset(
                            'assets/Images/strong_buy.png',
                            fit: BoxFit.contain,
                          )
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calculate,
              size: 20,
              weight: 10,
            ), // Change the icon as per your requirement
            label: 'Predictions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
              size: 20,
              weight: 20,
            ), // Change the icon as per your requirement
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.trending_up,
              size: 20,
              weight: 20,
            ), // Change the icon as per your requirement
            label: 'Indicator',
          ),
        ],
      ),
    );
  }
}
