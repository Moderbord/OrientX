import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'first_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfilePage extends StatelessWidget
{
  @override
    Widget build(BuildContext context) {
    return Container(
      color: currentTheme.backgroundColor,
        child: Stack(children: <Widget>[

          StaggeredGridView.count(
          crossAxisCount: 4,
            staggeredTiles: _sTiles,
            children: _tiles,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: const EdgeInsets.all(4.0),
          ),

        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  radius: 70,
                  backgroundColor: currentTheme.backgroundColor,
                  child:
                    CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ))
              ],
            ))
        ]
        )
    );
  }
}


List<Widget> _tiles = <Widget> [
  _createTile(icon: Icon(Icons.flag),headerText: "Laps complete",stat: "17", color: currentTheme.primaryColor),
  _createTile(icon: Icon(Icons.access_time),headerText: "Total running time",stat: "47 h",color: currentTheme.backgroundColor),
  _createReverseTile(icon: Icon(Icons.help),headerText: "Questions answered",stat: "374", color: currentTheme.backgroundColor),
  _createReverseTile(icon: Icon(Icons.directions_run),headerText: "Meters",stat: "120563", color: currentTheme.primaryColor),
];

List<StaggeredTile> _sTiles = const <StaggeredTile>[
  const StaggeredTile.count(2, 2.5),
  const StaggeredTile.count(2, 2.5),
  const StaggeredTile.count(2, 2.5),
  const StaggeredTile.count(2, 2.5),
];

Card _createTile({String headerText, Color color,String stat, Icon icon})
{
  return
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
  );
}

Card _createReverseTile({String headerText, Color color,String stat, Icon icon})
{
  return Card(
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
  );
}