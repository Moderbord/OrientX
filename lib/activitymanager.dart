import 'package:flutter/material.dart';

import 'activity.dart';

enum ActivityType { Question, Video, Sound, Game }

enum ActivityConclusion { Choice, Written, Task, Passive }

enum ActivityAnswerCount { Single, Multiple }

class ActivityManager extends StatelessWidget {
  final ActivityType activityType;

  final ActivityConclusion activityConclusion;

  final ActivityAnswerCount activityAnswerCount;

  ActivityManager(
      {this.activityType, this.activityConclusion, this.activityAnswerCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(7.0),
          child: RaisedButton(
            onPressed: () {
              // Transitions to a new activity
              _startActivity(context);
            },
            child: Text('Actify me'),
          ),
        ),
      ],
    );
  }

  _startActivity(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RootActivity(
          name: 'Väsande aktivitet',
          builder: (context) => Activity(
            image: 'assets/väs.jpg',
            imageText: 'Vad är detta för gudomlighet?',
            labels: <String>['Hej', 'då', 'gammal', 'kod'],
            time: 5,
          ),
        ),
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
}
