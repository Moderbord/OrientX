import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:orientx/backend/activity/answerpackage.dart';
import 'package:video_player/video_player.dart';
import 'package:orientx/widgets/activitytimer.dart';
import 'package:orientx/widgets/extendedcheckboxgroup.dart';
import 'package:orientx/widgets/videoitem.dart';
import 'package:orientx/backend/activity/activitypackage.dart';

/// Activity widget which contains questions and related media
///
/// Returns an AnswerPackage on exit
class Activity extends StatelessWidget {
  final String activityName;
  final String id;
  final String dataSource;
  final DataType dataType;
  final String description;
  final List<String> questions;
  final QuestionType questionType;
  final List<String> answers;
  final int duration;

  Activity(
      {@required this.activityName,
      @required this.id,
      this.dataSource,
      this.dataType,
      @required this.description,
      this.questions,
      this.questionType,
      this.answers,
      this.duration});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Remove back functionality
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes AppBar back button
          title: Text(activityName),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            dataWidget(dataType, dataSource),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text(description),
              alignment: Alignment.centerLeft,
            ),
            ActivityTimer(
                time: duration,
                onFinish: () => Navigator.pop(
                    context,
                    AnswerPackage(
                      result: Result.TimedOut,
                      selectedAnswers: List<String>(),
                      correctAnswers: answers,
                      answerTime: duration,
                    ))),
            ExtendedCheckboxGroup(
              labels: questions,
              type: questionType,
              onClick: (List<String> userAnswers) => Navigator.pop(
                  context,
                  AnswerPackage(
                    result: answerCheck(userAnswers, answers) ? Result.Correct : Result.Incorrect,
                    selectedAnswers: userAnswers,
                    correctAnswers: answers,
                    answerTime: 3, // not taken into account at the moment
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks user answers with correct answers
  bool answerCheck(List<String> userAnswer, List<String> correctAnswer) {
    return DeepCollectionEquality.unordered().equals(userAnswer, correctAnswer);
  }
}

/// Container widget of the displayed media in the Activity
Widget dataWidget(DataType type, String source) {
  switch (type) {
    case DataType.Undefined:
      return Container();
      break;
    case DataType.Image:
      return Image.network(source);
      break;
    case DataType.Video:
      return VideoItem(
        videoPlayerController: VideoPlayerController.network(source),
        looping: true,
      );
      break;
    case DataType.Sound:
      return Container(
        child: Text("Sound Data"),
      );
      break;
    case DataType.Game:
      return Container(
        child: Text("Game Data"),
      );
      break;
    default:
      return Container(
        child: Text("Data switch default fallback"),
      );
  }
}
