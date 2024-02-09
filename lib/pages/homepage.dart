import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investment_manager/pages/piechart.dart';
import 'package:investment_manager/pages/portfoliopage.dart';
import 'package:investment_manager/pages/prediction.dart';
import 'package:investment_manager/pages/stockspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    // Delay the animation to give time for the UI to build
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showButtons = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
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
        ],
        backgroundColor: Colors.black,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                AnimatedOpacity(
                  opacity: _showButtons ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    height: 250,
                    width: 375,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF313131),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: MyPieChart(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildAnimatedButton(
                  onPressed: () {
                    _navigateToPage('/stocks');
                  },
                  iconPath: "assets/Icons/stocksIconHajicon.png",
                  label: "Stocks",
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildAnimatedButton(
                  onPressed: () {
                    _navigateToPage('/prediction');
                  },
                  iconPath: "assets/Icons/mutualFundIconPopVectors.png",
                  label: "Get Prediction",
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildAnimatedButton(
                  onPressed: () {},
                  iconPath: "assets/Icons/newsIconFreepik.png",
                  label: "News",
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(
                      onPressed: () {},
                      icon: Icons.home,
                    ),
                    _buildIconButton(
                      onPressed: () {
                        _navigateToPage('/portfolio');
                      },
                      icon: Icons.perm_contact_cal_rounded,
                    ),
                    _buildIconButton(
                      onPressed: () {
                        _navigateToPage('/stocks');
                      },
                      icon: Icons.attach_money_rounded,
                    ),
                    _buildIconButton(
                      onPressed: () {},
                      icon: Icons.menu_book,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required String iconPath,
    required String label,
  }) {
    return AnimatedOpacity(
      opacity: _showButtons ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Container(
              child: Image.asset(iconPath),
              height: 40,
              width: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFFF9FAF8),
                fontSize: 22,
              ),
            ),
            SizedBox(
              width: 50,
            ),
            Container(
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFFF9FAF8),
              ),
            ),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF313131)),
          fixedSize: MaterialStateProperty.all(Size(375, 60)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 40,
      ),
      color: Color(0xFFF9FAF8),
    );
  }

  // Function to navigate to a page with smooth animated transition
  void _navigateToPage(String routeName) {
    switch (routeName) {
      case '/stocks':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StocksPage()),
        );
        break;
      case '/prediction':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForecastApp()),
        );
        break;
      case '/portfolio':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PortfolioPage()),
        );
        break;
      default:
        break;
    }
  }
}
