import 'package:flutter/material.dart';
import 'package:investment_manager/auth/mainpage.dart';
import 'package:investment_manager/pages/homepage.dart';
import 'package:investment_manager/pages/loginpage.dart';
import 'package:investment_manager/pages/portfoliopage.dart';
import 'package:investment_manager/pages/settingpage.dart';
import 'package:investment_manager/pages/signup.dart';
import 'package:investment_manager/pages/stockspage.dart';
import 'package:investment_manager/pages/mutualfundspage.dart';
import 'package:investment_manager/pages/bullionpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() => runApp(MaterialApp(
//   theme: ThemeData(
//     useMaterial3: true,
//     scaffoldBackgroundColor: Colors.black,
//   ),
//   initialRoute: '/',
//   routes: {
//     '/': (context) => LoginPage(),
//     '/signup': (context) => SignUpPage(),
//     '/home': (context) => HomePage(),
//   },
// )
// );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/home': (context) => HomePage(),
        '/stocks': (context) => StocksPage(),
        '/mutualfunds': (context) => MutualFundsPage(),
        '/gold': (context) => BullionPage(),
        '/settings': (context) => SettingsPage(),
        '/portfolio': (context) => PortfolioPage(),

      },
    );
  }
}
