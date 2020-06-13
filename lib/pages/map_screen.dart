import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orientx/backend/activity/activesession.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../backend/data/station.dart';
import '../backend/data/track.dart';

import '../widgets/map_view.dart';

class MapScreen extends StatefulWidget {
  @override
  State createState() => MapScreenState();
}

/// Compound map screen, containing stations overview and map view.
class MapScreenState extends State<MapScreen> {

  // Stations in this list get a green checkmark in the overview.
  List<Station> _visited = [];

  @override
  void initState() {
    super.initState();

    // Ensure visited stations get added to "visited"-list.
    ActiveSession().addOnVisitedListeners((Station station) {
      setState(() {
        _visited.add(station);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Track track = ActiveSession().getTrack();
    int stationCount = (track == null) ? 0 : track.activityIndex.length;

    return SlidingUpPanel(
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.drag_handle),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: stationCount,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {

                  Station station = track.getStationFromIndex(i);
                  bool isVisited = _visited.contains(station);

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
                                child: Icon(
                                  isVisited
                                      ? Icons.check_circle
                                      : Icons.remove_circle,
                                  size: 25.0,
                                  color: isVisited
                                      ? Colors.lightGreen
                                      : Colors.yellow,
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
          ),
        ],
      ),
      body: MapView(),
      parallaxEnabled: true,
      backdropEnabled: true,
      color: Theme.of(context).bottomAppBarColor,
      minHeight: 30.0,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
    );
  }
}
