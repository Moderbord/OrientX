import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/first_screen.dart';
import "simon_directory/login_page.dart";
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      title: 'OrientX',
      home: LoginPage()
        bg.BackgroundGeolocation.start();
        body: MapView(),
