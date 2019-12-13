import 'package:flutter/material.dart';

import 'package:orientx/spaken_directory/activesession.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/luddw_dir/db.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
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
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none, focusedBorder: InputBorder.none),
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
                      _result = "Ok!";
                      ActiveSession().setTrack(_input);
                      ActiveSession().setSessionState(SessionState.Run);
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool checkID(String id) {
    return ServerPackage().checkID(id);
  }
}
