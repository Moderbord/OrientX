import 'package:flutter/material.dart';

enum DataType {
  Undefined,
  Image,
  Video,
  Sound,
  Game,
}

enum QuestionType {
  Undefined,
  Single,
  Multiple,
}

class ActivityPackage {
  final String activityName;
  final String id;
  final String dataSource;
  final DataType dataType;
  final String description;
  final List<String> questions;
  final QuestionType questionType;
  final List<String> answers;
  final int duration;

  ActivityPackage(
      {@required this.activityName,
      @required this.id,
      this.dataSource,
      this.dataType,
      @required this.description,
      this.questions,
      this.questionType,
      this.answers,
      this.duration});
}
