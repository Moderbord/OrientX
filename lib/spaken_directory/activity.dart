import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:orientx/spaken_directory/activitytimer.dart';
import 'package:orientx/spaken_directory/extendedcheckboxgroup.dart';
import 'package:orientx/spaken_directory/videoitem.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

class Activity extends StatelessWidget {
   final String activityName;
   final int id;
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
                      onFinish: () => Navigator.pop(context, List<String>())),
                  ExtendedCheckboxGroup(
                     labels: questions,
                     type: questionType,
                     onClick: (List<String> answers) =>
                         Navigator.pop(context, answers),
                  ),
               ],
            ),
         ),
      );
   }
}

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