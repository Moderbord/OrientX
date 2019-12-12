import 'package:flutter/material.dart';

import 'package:orientx/fredrik_directory/map_view.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.0))
            ),
            child: MapView(),
          ),
        ],
      )
    );
  }
}
