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

class Smorres extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    ActivityPackage rndImagePkg = ActivityPackage(
      activityName: "Mycket stiligt",
      id: 123,
      dataSource: "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta för gudomlighet?",
      labels: <String>["Snygg", "Sexig", "Singel"],
      correct: "SSS",
      duration: 10,
    );

    ActivityPackage videoPkg = ActivityPackage(
      activityName: "Vad ser du på Kalle?",
      id: 123,
      dataSource: "https://drive.google.com/file/d/1-C9pl0ICbsoCPLS5PjOmFRn6tNss2h2j/view",
      dataType: DataType.Video,
      description: "Vad är detta för gudomlighet?",
      labels: <String>["Snygg", "Sexig", "Singel"],
      correct: "SSS",
      duration: 10,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network("https://pbs.twimg.com/profile_images/977183150412652544/WpQeIMYn_400x400.jpg"),
        Container(
          margin: EdgeInsets.all(7.0),
          child: RaisedButton(
            onPressed: () {
              // Transitions to a new activity
              ActivityManager().newActivity(
                context: context,
                package: videoPkg,
              );
            },
            child: Text('Rawr'),
          ),
        ),
      ],
    );
  }
  
}