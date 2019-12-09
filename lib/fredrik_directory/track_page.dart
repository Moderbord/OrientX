import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'track.dart';
import 'station.dart';

import 'map_view.dart';

class TrackPage extends StatefulWidget {
  final Track track;

  TrackPage({@required this.track});

  @override
  State createState() => TrackPageState();
}

class TrackPageState extends State<TrackPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: widget.track.stations.length,
          itemBuilder: (BuildContext context, int i) {
            Station station = widget.track.stations[i];

            return Container(
              height: 250.0,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(station.resourceUrl),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Theme.of(context).backgroundColor,
                          child: Row(children: <Widget>[
                            Icon(Icons.location_on),
                            Text(station.name, style: TextStyle(fontSize: 15.0),),
                          ],),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: MapView(track: widget.track),
      color: Theme.of(context).bottomAppBarColor,
      parallaxEnabled: true,
      backdropEnabled: true,
      minHeight: 30.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    );
  }
}
