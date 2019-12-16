import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/spaken_directory/answerpackage.dart';
import 'activity.dart';

class ActivityManager {
  String activityName;
  String id;
  String dataSource;
  DataType dataType;
  String description;
  List<String> questions;
  QuestionType questionType;
  List<String> answers;
  int duration;

  Future<AnswerPackage> newActivity(
      {@required BuildContext context, @required ActivityPackage package}) {
    activityName = package.activityName ?? "Väääääs! Måste ha TITEL!";
    id = package.id ?? "0";
    dataSource = package.dataSource;
    dataType = package.dataType ?? DataType.Undefined;
    description = package.description ?? "VÄÄÄÄÄÄÄS!! Måste ha TEXT!";
    questions = package.questions;
    questionType = package.questionType;
    answers = package.answers;
    duration = package.duration;

    return _startActivity(context);
  }

  Future<AnswerPackage> _startActivity(BuildContext context) async {
    AnswerPackage answerPackage = await Navigator.push(
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
              )),
    );

    return answerPackage;
  }
}
