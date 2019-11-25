import 'package:flutter/material.dart';
import 'package:orientx/activitypackage.dart';

import 'activitymanager.dart';

void main() => runApp(OrientxApp());

class OrientxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Easy life'),
        ),
        body: Smorres(),
      ),
    ); // used to wrap the entire app "core-root-widget"
  }
}

class Smorres extends StatelessWidget {
  bool imageVideo = false;

  @override
  Widget build(BuildContext context) {

    ActivityPackage rndImagePkg = ActivityPackage(
      activityName: "Mycket stiligt",
      id: 123,
      dataSource: "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta för gudomlighet?",
      questions: <String>["Hemligt", "Oklart", "Drake"],
      questionType: QuestionType.Single,
      answers: <String>["Oklart"],
      duration: 10,
    );

    ActivityPackage videoPkg = ActivityPackage(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RaisedButton(
          onPressed: () => imageVideo = !imageVideo,
          child: Container(
            alignment: Alignment.center,
            child: Image.network(
              "https://pbs.twimg.com/profile_images/977183150412652544/WpQeIMYn_400x400.jpg",
              width: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(7.0),
          child: RaisedButton(
            onPressed: () {
              // Transitions to a new activity
              ActivityManager().newActivity(
                context: context,
                package: imageVideo ? videoPkg : rndImagePkg,
              );
            },
            child: Text('Rawr'),
          ),
        ),
      ],
    );
  }
}
