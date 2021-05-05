import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.signika().fontFamily,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              "My E-Commerce app, lets see how its going to go down.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
