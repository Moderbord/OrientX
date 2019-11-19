import 'package:flutter/material.dart';
import 'package:orientx/activitytimer.dart';
import 'package:orientx/extendedcheckboxgroup.dart';
import 'package:orientx/videoitem.dart';
import 'package:video_player/video_player.dart';

class RootActivity extends StatelessWidget {
  final String name;

  final WidgetBuilder builder;

  RootActivity({
    @required this.name,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: builder(context),
    );
  }
}

class Activity extends StatelessWidget {
  final String image;
  final String imageText;
  final List<String> labels;
  final int time;

  Activity({
    this.image,
    this.imageText,
    this.labels,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(image),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(imageText),
          alignment: Alignment.centerLeft,
        ),
        ActivityTimer(
            time: time,
            onFinish: () => Navigator.pop(context, "Activity timed out")),
        ExtendedCheckboxGroup(
          labels: labels,
          onClick: (List<String> answers) => Navigator.pop(context, answers),
        ),
      ],
    );
  }
}

class VideoActivity extends StatelessWidget {
  final String url;


  VideoActivity({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        VideoItem(
          videoPlayerController: VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
          looping: true,
        )
      ],
    ); //temp
  }
}
