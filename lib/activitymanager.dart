import 'package:flutter/material.dart';
import 'package:orientx/activitypackage.dart';

import 'activity.dart';

class ActivityManager {

  String activityName;
  int id;
  String dataSource;
  DataType dataType;
  String description;
  List<String> labels;
  String correct;
  int duration;

  void newActivity(
      {@required BuildContext context,
      @required ActivityPackage package})
  {
    activityName  = package.activityName  ?? "Väääääs! Måste ha TITEL!";
    id            = package.id            ?? 0;
    dataSource    = package.dataSource;
    dataType      = package.dataType      ?? DataType.Undefined;
    description   = package.description   ?? "VÄÄÄÄÄÄÄS!! Måste ha TEXT!";
    labels        = package.labels;
    correct       = package.correct;
    duration      = package.duration;

    _startActivity(context);
  }

  _startActivity(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Activity(
          activityName: activityName,
          id: id,
          dataSource: dataSource,
          dataType: dataType,
          description: description,
          labels: labels,
          correct: correct,
          duration: duration,
        )
      ),
    );
    // Display short Snackbar
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
}
