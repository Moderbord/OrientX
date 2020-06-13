import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../backend/data/track.dart';

import 'package:orientx/backend/activity/activesession.dart';
import 'package:orientx/backend/activity/answerpackage.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultScreenState();
}

/// Displays the results of the last finished track session.
///
/// For instance, questions and answers, time,
/// and a QR code representing this data.
class ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Track track = ActiveSession().getTrack();
    int stations = (track == null) ? 0 : track.activities.length;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            "assets/svg/car.svg",
            color: Theme.of(context).backgroundColor,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 40.0,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(20.0),
          onPressed: () {
            ActiveSession().flush();
          },
        ),
        Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              "Du är i mål!",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Card(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Image.asset("assets/images/qr.png"),
              ),
            ),
            Text(
              "Visa QR-koden för din lärare",
              style: TextStyle(color: Theme.of(context).dividerColor),
            ),
            SizedBox(height: 20.0),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: stations,
                itemBuilder: (BuildContext context, int index) {
                  AnswerPackage answer = ActiveSession().getAnswer(index);

                  Icon answerIcon;

                  switch (answer.result) {
                    case Result.Correct:
                      answerIcon = Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30.0,
                      );
                      break;
                    case Result.Incorrect:
                      answerIcon = Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30.0,
                      );
                      break;
                    case Result.TimedOut:
                      answerIcon = Icon(
                        Icons.remove_circle,
                        color: Colors.grey,
                        size: 30.0,
                      );
                      break;
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: answerIcon,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                              Text(
                                track.getStationFromIndex(index).name,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ] +
                            [_getResultSubtext(answer)],
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  /// Returns a grey subtext detailing how well the player answered a
  /// specific question.
  Widget _getResultSubtext(AnswerPackage package) {
    TextStyle style = TextStyle(fontSize: 15.0, color: Colors.grey);

    switch (package.result) {
      case Result.Correct:
        return Text(
          "Snyggt, full pott!",
          style: style,
        );
      case Result.Incorrect:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Dina svar: " + package.selectedAnswers.join(", "),
              style: style,
            ),
            Text(
              "Rätt svar: " + package.correctAnswers.join(", "),
              style: style,
            )
          ],
        );
      case Result.TimedOut:
        return Text(
          "Inget svar!",
          style: style,
        );
    }
  }
}
