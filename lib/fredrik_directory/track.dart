import 'dart:math';

import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

enum circuitType{
  standard,
  random,
}


class Track {
  final String name;
  final List<Station> stations;
  final List<ActivityPackage> activities;
  List<int> circuit = [];



  Track({this.name, this.stations, this.activities, circuitType type = circuitType.standard})
  {
    switch (type)
    {
      case circuitType.standard:
        for (int i = 0; i < stations.length; i++)
        {
          circuit.add(i);
        }
        break;
      case circuitType.random:
        for (int i = 0; i < activities.length; i++)
        {
          circuit.add(i);
        }
        circuit.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
        break;
      default:
        break;
    }
  }

  Track.fromCircuit({this.name, this.stations, this.activities, this.circuit});


}
