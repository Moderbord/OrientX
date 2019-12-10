import 'package:flutter/material.dart';

import 'package:orientx/fredrik_directory/destination.dart';
import 'package:orientx/simon_directory/start_screen.dart';
import 'package:orientx/fredrik_directory/map_screen.dart';
import 'package:orientx/fredrik_directory/result_screen.dart';

class TrackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackPageState();
  }
}

class _TrackPageState extends State<TrackPage>
    with TickerProviderStateMixin {

  List<Destination> _destinations;
  List<AnimationController> _faders;
  List<Key> _destinationKeys;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _destinations = <Destination>[
      Destination(0, 'Resultat', Icons.check_circle, ResultScreen()),
      Destination(1, 'Start', Icons.flag, StartRun()),
      Destination(2, 'Orientering', Icons.location_on, MapScreen()),
    ];

    _faders = _destinations.map<AnimationController>((Destination destination) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(_destinations.length, (int index) => GlobalKey())
            .toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: _destinations.map((Destination destination) {
        final Widget view = FadeTransition(
          opacity: _faders[destination.index]
              .drive(CurveTween(curve: Curves.fastOutSlowIn)),
          child: KeyedSubtree(
              key: _destinationKeys[destination.index],
              child: destination.screen),
        );
        if (destination.index == _currentIndex) {
          _faders[destination.index].forward();
          return view;
        } else {
          _faders[destination.index].reverse();
          if (_faders[destination.index].isAnimating) {
            return IgnorePointer(child: view);
          }
          return Offstage(child: view);
        }
      }).toList(),
    );
  }
}
