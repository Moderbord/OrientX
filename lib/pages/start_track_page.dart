/// This page is the one you start the runs on
/// Contains the track code input field.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:orientx/backend/activity/activesession.dart';
import 'package:orientx/backend/db/serverpackage.dart';

/// Start Run state creator
class StartRun extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StartRunState();
  }
}

/// Start Run state with keep-alive, so that you can scroll through the
/// rest of the app while you are out doing a run.
class _StartRunState extends State<StartRun>
    with AutomaticKeepAliveClientMixin<StartRun> {

  String _input = "";
  String _result = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState()
  {
    super.initState();
    // Set active session state to "start" when first created
    ActiveSession().addStateListener((SessionState state) {
      if (state == SessionState.Start)
        setState(() {
          _input = "";
          _result = "";
        });
    });
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return Stack(
      children: <Widget>[
        // Background image
        SvgPicture.asset(
          "assets/svg/tree.svg",
          semanticsLabel: "A decorative bottom vignette",
          fit: BoxFit.fitHeight,
          alignment: Alignment.bottomRight,
          color: Theme.of(context).backgroundColor,
        ),
        // Input field for track code
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Banans ID: ",
                style: Theme.of(context).textTheme.title,
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        width: 5.0, color: Theme.of(context).accentColor)),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  onChanged: (String text) {
                    setState(() {
                      _input = text;
                    });
                  },
                ),
              ),
              // Button for starting the track
              Row(
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Kör igång!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      setState(() {
                        if (ServerPackage().checkID(_input)) {
                          _result = "Hämtar data...";
                          ActiveSession().setTrack(_input);
                        } else {
                          _result = "Banan kunde inte hittas!";
                        }
                      });
                    },
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    _result,
                    style: Theme.of(context).textTheme.button,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
