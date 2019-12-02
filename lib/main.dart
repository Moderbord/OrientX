import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/first_screen.dart';
import "simon_directory/login_page.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OrientX',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage()
    );
  }
}