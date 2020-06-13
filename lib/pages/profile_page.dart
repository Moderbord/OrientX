/// The profile page is a page that displays your current statistics
/// This uses the staggered grid view plugin to create a grid with stats

import 'package:flutter/material.dart';
import '../backend/auth/sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Profile Page state creator
class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

/// Profile Page state
class _ProfilePageState extends State<ProfilePage> {

  String lapAmount = "0", runTime = "0", questionsAnswered = "0", steps = "0";

  ///Method for updating the stats from the database when complete.
  updateStatsDB() {
    return false;
  }

  /// Checks if the values are not set and if so, sets them to zero.
  _ifNull() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("isguest") && prefs.getInt("g_steps") == null) {
      prefs.setInt("g_laps", 0);
      prefs.setInt("g_runtime", 0);
      prefs.setInt("g_qa", 0);
      prefs.setInt("g_steps", 0);
    } else if (updateStatsDB()) {
      //get database data if there is any
    } else if (prefs.getInt("steps") == null) {
      prefs.setInt("laps", 0);
      prefs.setInt("runtime", 0);
      prefs.setInt("qa", 0);
      prefs.setInt("steps", 0);
    }
  }
  /// Method for getting the stats from shared preferences.
  ///
  /// Updates the stats of the profile page.
  _getStats() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _ifNull();
    setState(() {
      if (prefs.getBool("isguest")) {
        lapAmount = prefs.getInt("g_laps").toString();
        runTime = prefs.getInt("g_runtime").toString();
        questionsAnswered = prefs.getInt("g_qa").toString();
        steps = prefs.getInt("g_steps").toString();
      } else {
        lapAmount = prefs.getInt("laps").toString();
        runTime = prefs.getInt("runtime").toString();
        questionsAnswered = prefs.getInt("qa").toString();
        steps = prefs.getInt("steps").toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }
  /// The staggered grid view widget that sets up a grid.
  @override
  Widget build(BuildContext context) {
    _getStats();
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              "assets/svg/grass_rocks.svg",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          StaggeredGridView.count(
            padding: EdgeInsets.all(10.0),
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            staggeredTiles: <StaggeredTile>[
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
              const StaggeredTile.fit(2),
            ],
            children: <Widget>[
              _createTile(
                  icon: Icon(Icons.flag),
                  headerText: "Laps complete",
                  stat: lapAmount,
                  color: Theme.of(context).primaryColor),
              _createTile(
                  icon: Icon(Icons.access_time),
                  headerText: "Total running time",
                  stat: runTime,
                  color: Theme.of(context).canvasColor),
              _createReverseTile(
                  icon: Icon(Icons.help),
                  headerText: "Questions answered",
                  stat: questionsAnswered,
                  color: Theme.of(context).canvasColor),
              _createReverseTile(
                  icon: Icon(Icons.directions_run),
                  headerText: "Meters",
                  stat: steps,
                  color: Theme.of(context).primaryColor),
            ],
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 210,
                ),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Theme.of(context).canvasColor,
                  child: CircleAvatar(
                    backgroundImage: profileImage.image,
                    radius: 60,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a tile for the staggered grid view.
  Container _createTile(
      {String headerText, Color color, String stat, Icon icon}) {
    return Container(
      height: 270,
      child: Card(
        color: color,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    icon,
                    Text(
                      headerText,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Text(
                  stat,
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a inverted tile for the staggered grid view.
  ///
  /// Image and text are flipped for a nice look.
  static Container _createReverseTile(
      {String headerText, Color color, String stat, Icon icon}) {
    return Container(
      height: 270,
      child: Card(
        color: color,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  stat,
                  style: TextStyle(fontSize: 40),
                ),
                Column(
                  children: <Widget>[
                    icon,
                    Text(
                      headerText,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
