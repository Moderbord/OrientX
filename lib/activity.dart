import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orientx/activitytimer.dart';

import 'package:orientx/extendedcheckboxgroup.dart';

class RootActivity extends StatelessWidget {
  final String name;

  final WidgetBuilder builder;

  RootActivity({
    @required this.name,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: builder(context),
    );
  }
}

// ignore: must_be_immutable
class Activity extends StatelessWidget {
  final String image;
  final String imageText;
  final List<String> labels;
  final int time;

  BuildContext _context;

  Activity({
    this.image,
    this.imageText,
    this.labels,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    _context = context;
    _startTimeout(time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(image),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(imageText),
          alignment: Alignment.centerLeft,
        ),
        ActivityTimer(
          time: time,
        ),
        ExtendedCheckboxGroup(
          labels: labels,
        )
      ],
    );
  }

  Timer _startTimeout([int time]) {
    print("Timer started");
    const timeout = const Duration(seconds: 999);
    const ms = const Duration(milliseconds: 1000);

    var duration = time == null ? timeout : ms * time;
    return new Timer(duration, _activityTimeoutCallback);
  }

  void _activityTimeoutCallback() {
    Navigator.pop(_context, "Activity timed out");
  }
}
