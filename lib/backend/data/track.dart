import 'dart:math';

import 'package:orientx/backend/data/station.dart';
import 'package:orientx/backend/activity/activitypackage.dart';

/// Represents how stations are ordered on a track.
enum courseType{
  standard,
  random,
}

/// Class for representing a track, with multiple stations.
///
/// Has name, stations, and activities.
/// Can order stations in the way they're originally ordered when fetched from
/// the server, or in a random fashion.
class Track {
  final String name;
  final List<Station> stations;
  final List<ActivityPackage> activities;
  List<int> activityIndex = [];

  Track({this.name, this.stations, this.activities, courseType type = courseType.standard})
  {
    switch (type)
    {
      case courseType.standard:
        for (int i = 0; i < stations.length; i++)
        {
          activityIndex.add(i);
        }
        break;
      case courseType.random:
        for (int i = 0; i < activities.length; i++)
        {
          activityIndex.add(i);
        }
        activityIndex.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
        break;
      default:
        break;
    }
  }

  Track.fromCircuit({this.name, this.stations, this.activities, this.activityIndex});

  getStationFromIndex(int index)
  {
    return stations[activityIndex[index]];
  }

}
