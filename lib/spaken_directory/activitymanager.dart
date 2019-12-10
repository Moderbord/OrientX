import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'activity.dart';

class ActivityManager {

  String activityName;
  int id;
  String dataSource;
  DataType dataType;
  String description;
  List<String> questions;
  QuestionType questionType;
  List<String> answers;
  int duration;

  Future<bool> newActivity(
      {@required BuildContext context,
      @required ActivityPackage package})
  {
    activityName  = package.activityName  ?? "Väääääs! Måste ha TITEL!";
    id            = package.id            ?? 0;
    dataSource    = package.dataSource;
    dataType      = package.dataType      ?? DataType.Undefined;
    description   = package.description   ?? "VÄÄÄÄÄÄÄS!! Måste ha TEXT!";
    questions     = package.questions;
    questionType  = package.questionType;
    answers       = package.answers;
    duration      = package.duration;

    return _startActivity(context);
  }

  Future<bool> _startActivity(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Activity(
           activityName: activityName,
           id: id,
           dataSource: dataSource,
           dataType: dataType,
           description: description,
           questions: questions,
           questionType: questionType,
           answers: answers,
           duration: duration,
        )
      ),
    );

    //Function deepEq = const DeepCollectionEquality.unordered().equals;

    bool hej = DeepCollectionEquality.unordered().equals(result, answers);

    // Display short Snackbar
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$hej')));
    return hej;
  }
}
