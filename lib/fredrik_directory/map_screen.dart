import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orientx/spaken_directory/activesession.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'station.dart';
import 'track.dart';

import 'map_view.dart';

class MapScreen extends StatefulWidget {

  @override
  State createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Track track = ActiveSession().getTrack();
    int stationCount = (track == null) ? 0 : track.activityIndex.length;

    return SlidingUpPanel(
      panel: Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: stationCount,
          itemBuilder: (BuildContext context, int i) {
            Station station = track.getStationFromIndex(i);

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
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Text(
                                station.name,
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0)),
                              color: Theme.of(context).bottomAppBarColor),
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "1/1",
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              Icon(
                                Icons.check_circle,
                                size: 25.0,
                                color: Colors.lightGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: MapView(),
      parallaxEnabled: true,
      backdropEnabled: true,
      minHeight: 30.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    );
  }
}
