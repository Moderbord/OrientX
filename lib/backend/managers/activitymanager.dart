import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orientx/backend/activity/activitypackage.dart';
import 'package:orientx/backend/activity/answerpackage.dart';
import '../activity/activity.dart';

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

  /// Constructs a new Activity with given package
  ///
  /// Returns future of constructed Activity (AnswerPackage)
  Future<AnswerPackage> newActivity(
      {@required BuildContext context, @required ActivityPackage package}) {
    activityName = package.activityName ?? "Title needed!";
    id = package.id ?? "0";
    dataSource = package.dataSource;
    dataType = package.dataType ?? DataType.Undefined;
    description = package.description ?? "Description text needed!";
    questions = package.questions;
    questionType = package.questionType;
    answers = package.answers;
    duration = package.duration;

    return _startActivity(context);
  }

  /// Builds Activity widget and pushes it to the Navigator
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
