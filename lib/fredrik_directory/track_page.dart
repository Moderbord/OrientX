import 'package:flutter/material.dart';

import 'package:orientx/fredrik_directory/destination.dart';
import 'package:orientx/simon_directory/start_screen.dart';
import 'package:orientx/fredrik_directory/map_screen.dart';
import 'package:orientx/fredrik_directory/result_screen.dart';
import 'package:orientx/spaken_directory/activesession.dart';

class TrackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackPageState();
  }
}

/// Animated stack that displays the appropriate page destination for the
/// current state in ActiveSession.
///
/// 0. Start - lets the player enter a new track code and start running.
/// 1. Track - shows the map screen, displaying the track and its info.
/// 2. Result - shows the result of the player's last finished track.
class _TrackPageState extends State<TrackPage> with TickerProviderStateMixin {

  // All available page destinations in stack.
  List<Destination> _destinations;

  // Animation controller for handling fading between pages.
  List<AnimationController> _faders;
  List<Key> _destinationKeys;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    ActiveSession().addStateListener((SessionState state) {
      setState(() {
        if (state != SessionState.Finished)
          _currentIndex = state.index;
      });
    });

    _destinations = <Destination>[
      Destination(0, 'Start', Icons.flag, StartRun()),
      Destination(1, 'Orientering', Icons.location_on, MapScreen()),
      Destination(2, 'Resultat', Icons.check_circle, ResultScreen()),
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
