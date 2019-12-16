import 'dart:math';

import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

enum courseType{
  standard,
  random,
}

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
