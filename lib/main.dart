import 'package:flutter/material.dart';
import 'package:orientx/map_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, canvasColor: Colors.transparent),
      home: Scaffold(
        appBar: AppBar(
          title: Text("OrientX"),
        ),
        body: MapView(),
        bottomSheet: Container(
          height: 200.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Row(
              children: <Widget>[
                Card(
                  child: Column(

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
