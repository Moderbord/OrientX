import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/track_page.dart';
import 'package:orientx/spaken_directory/activesession.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';

class StartRun extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartRunState();
  }
}

class _StartRunState extends State<StartRun>
    with AutomaticKeepAliveClientMixin<StartRun> {
  String _input = "";
  String _result = "";
  bool runTrack = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return runTrack == false
        ? Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Banans ID: ",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          width: 5.0, color: Theme.of(context).accentColor)),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
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
                Row(
                  children: <Widget>[
                    RaisedButton(
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Kör igång!",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        setState(() {
                          if (checkID(_input)) {
                            ActiveSession().setTrack(_input);
                            runTrack = true;
                          } else {
                            _result = "Banan kunde inte hittas!";
                          }
                        });
                      },
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      _result,
                      style: TextStyle(color: Colors.black54, fontSize: 10.0),
                    )
                  ],
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    print("current state: " + ActiveSession().getCurrentState());
                  },
                  child: Text("Cur State"),
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    print("listener added");
                    ActiveSession().addStateListener((SessionState state){
                      print("CALLBACK with state: " + state.toString());
                    });
                  },
                  child: Text("Add listener"),
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    print("state change triggered");
                    ActiveSession().onStateChange();
                  },
                  child: Text("On change"),
                ),
                RaisedButton(
                  onPressed: ()
                  {
                    print("State changed manually");
                    ActiveSession().setState();
                  },
                  child: Text("Next state"),
                )
              ],
            ),
          )
        : Container(
            child: Center(
                child: TrackPage(
                    track: ActiveSession().getTrack())),
          );
  }

  bool checkID(String id) {
    return ServerPackage().checkID(id);
  }
}
