import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}





class _ProfilePageState extends State<ProfilePage>
{
  String lapAmount = "",runTime = "",questionsAnswered = "",meters = "";

  _getStats() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      print(prefs.getBool("isguest"));
      if(prefs.getBool("isguest"))
        {
          lapAmount = prefs.getInt("g_laps").toString();
          runTime = prefs.getInt("g_runtime").toString();
          questionsAnswered = prefs.getInt("g_qa").toString();
          meters = prefs.getInt("g_meters").toString();
          prefs.setBool("isguest", false);
        }
      else {
        lapAmount = prefs.getInt("laps").toString();
        runTime = prefs.getInt("runtime").toString();
        questionsAnswered = prefs.getInt("qa").toString();
        meters = prefs.getInt("meters").toString();
      }

    });
  }

  @override
  void initState() {
    super.initState();
    _getStats();
  }

  @override
    Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
          StaggeredGridView.count(
            crossAxisCount:4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            staggeredTiles: <StaggeredTile>[
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
            ],
            children: <Widget>[
              _createTile(icon: Icon(Icons.flag),headerText: "Laps complete",stat: lapAmount, color: Theme.of(context).primaryColor),
              _createTile(icon: Icon(Icons.access_time),headerText: "Total running time",stat: runTime,color: Theme.of(context).canvasColor),
              _createReverseTile(icon: Icon(Icons.help),headerText: "Questions answered",stat: questionsAnswered, color: Theme.of(context).canvasColor),
              _createReverseTile(icon: Icon(Icons.directions_run),headerText: "Meters",stat: meters, color: Theme.of(context).primaryColor),
            ],
          ),
        Center(
            child: Column(

              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Theme.of(context).canvasColor,
                  child:
                    CircleAvatar(
                      backgroundImage: profileImage.image,
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ))
              ],
            ))
        ]
        )
    );
  }



  Container _createTile({String headerText, Color color,String stat, Icon icon})
  {
    return
    Container(
      height: 270,
    child:
      Card(
          color: color,
          child: Center(
            child:
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      icon,
                      Text(headerText,style:  TextStyle(fontSize: 20),),
                    ],
                  ),
                  Text(stat,style:  TextStyle(fontSize: 40),)
                ],
              ),
            ),
          )
      )
    );
  }

  static Container _createReverseTile({String headerText, Color color,String stat, Icon icon})
  {
    return
    Container(
      height: 270,
    child:
      Card(
        color: color,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(stat,style:  TextStyle(fontSize: 40),),
                Column(
                  children: <Widget>[
                    icon,
                    Text(headerText,style:  TextStyle(fontSize: 20),),
                  ],
                ),
              ],
            ),
          ),
        )
    )
    );
  }

}


