import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/mapview.dart';
import 'sign_in.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:latlong/latlong.dart';

class TestPage extends StatelessWidget {
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

  final ActivityPackage enTill = ActivityPackage(
    activityName: "Oh Mhürer",
    id: 123,
    dataSource:
        "https://a9p9n2x2.stackpathcdn.com/wp-content/blogs.dir/1/files/2011/01/raised-eyebrow.jpg",
    dataType: DataType.Image,
    description: "Vad gömmer sig bakom blicken?",
    questions: <String>["Mona Lisa", "Nivea", "Jesus"],
    questionType: QuestionType.Single,
    answers: <String>["Jesus"],
    duration: 6,
  );

  @override
  Widget build(BuildContext context) {

    final List<Station> stationList = [
      Station(name: "Lakeside Shrubbery", point: LatLng(37.4320, 122.0941)),
      Station(name: "Shrekway Bus Station", point: LatLng(37.5320, 122.1041)),
      Station(name: "3 boys in a sleeping bag", point: LatLng(37.4325, 122.0951))
    ];
    final List<ActivityPackage> activityList = [rndImagePkg, videoPkg, enTill];

    Track track = Track(
      name: "Mysslinga",
      stations: stationList,
      activities: activityList,
      type: circuitType.standard
    );


    int index = 0;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color1, color3],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft)),
      child: Center(
        child: MapView(track: track)
      ),
    );
  }
}
