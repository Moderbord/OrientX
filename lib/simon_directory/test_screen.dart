import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:orientx/activitypackage.dart';
import 'package:orientx/activitymanager.dart';

class TestPage extends StatelessWidget
{
   final ActivityPackage rndImagePkg = ActivityPackage(
      activityName: "Mycket stiligt",
      id: 123,
      dataSource: "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta för gudomlighet?",
      questions: <String>["Hemligt", "Oklart", "Drake"],
      questionType: QuestionType.Single,
      answers: <String>["Oklart"],
      duration: 5,
   );

   final ActivityPackage videoPkg = ActivityPackage(
      activityName: "Vad ser du på Kalle?",
      id: 123,
      dataSource:
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      dataType: DataType.Video,
      description: "Vad är detta för gudomlighet?",
      questions: <String>["Flygande", "Butterfree", "Spindel", "Majblomma"],
      questionType: QuestionType.Multiple,
      answers: <String>["Flygande", "Butterfree"],
      duration: 20,
   );

  @override
  Widget build(BuildContext context)
  {
    return Container
      (
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1,color3],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 RaisedButton(
                    onPressed: () {
                       // Transitions to a new activity
                       ActivityManager().newActivity(
                          context: context,
                          package: rndImagePkg,
                       );
                    },
                    child: Text('i want it all!'),
                 ),
              ],
            )
        ));
  }
}
