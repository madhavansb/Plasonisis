import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(PlasonisisApp());
}

class PlasonisisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plasonisis',
      theme: ThemeData(
        primaryColor: Colors.green[700],
        hintColor: Colors.green[400],
        scaffoldBackgroundColor: Colors.green[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green[600],
        ),
      ),
      home: HomeScreen(),
    );
  }
}
