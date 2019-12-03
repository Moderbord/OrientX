import 'package:flutter/material.dart';
import 'first_screen.dart';
import 'package:orientx/fredrik_directory/mapview.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';

class StartRun extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartRunState();
  }
}

class _StartRunState extends State<StartRun> with AutomaticKeepAliveClientMixin<StartRun>{
  String result = "";
  bool runTrack = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
     super.build(context);
    return runTrack == false
        ? Container(
            decoration: BoxDecoration(color: currentTheme.backgroundColor),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: currentTheme.primaryColor),
                    decoration: InputDecoration(
                      labelText: "Ban-nummer",
                      labelStyle: TextStyle(color: currentTheme.primaryColor),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: currentTheme.primaryColor)),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: currentTheme.primaryColor)),
                    ),
                    onChanged: (String text) {
                      setState(() {
                        result = text;
                      });
                    },
                  ),
                  Text(result),
                  RaisedButton(
                    color: currentTheme.backgroundColor,
                    textColor: currentTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: currentTheme.primaryColor)),
                    child: Text(
                      "Starta Bana",
                      style: TextStyle(color: currentTheme.primaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        if (checkID(int.parse(result))) {
                          runTrack = true;
                        } else {
                          result = "Track ID mismatch";
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(color: currentTheme.backgroundColor),
            child: Center(
                child: MapView(
              track: ServerPackage().fromID(int.parse(result)),
              context: context,
            )),
          );
  }

  bool checkID(int id)
  {
    return ServerPackage().checkID(id);
  }
}
