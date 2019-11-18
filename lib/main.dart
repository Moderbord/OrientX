import 'package:flutter/material.dart';

import 'activitymanager.dart';

void main() => runApp(OrientxApp());

class OrientxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Easy life'),
        ),
        body: ActivityManager(),
      ),
    ); // used to wrap the entire app "core-root-widget"
  }
}
