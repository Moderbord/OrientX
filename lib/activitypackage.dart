import 'package:flutter/material.dart';

enum DataType {
  Undefined,
  Image,
  Video,
  Sound,
  Game,
}

class ActivityPackage {
  final String activityName;
  final int id;
  final String dataSource;
  final DataType dataType;
  final String description;
  final List<String> labels;
  final String correct;
  final int duration;

  ActivityPackage(
      {@required this.activityName,
      @required this.id,
      this.dataSource,
      this.dataType,
      @required this.description,
      this.labels,
      this.correct,
      this.duration});
}
