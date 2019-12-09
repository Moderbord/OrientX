import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';

class MapView extends StatefulWidget {
  final Track track;
  final BuildContext context;

  MapView({@required this.track, this.context});

  @override
  State createState() => MapViewState();
}

class MapViewState extends State<MapView>
    with AutomaticKeepAliveClientMixin<MapView> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  Timer _timer;
  int _timerSeconds = 3600;

  List<CircleMarker> _currentPosition = [];
  List<LatLng> _trackHistory = [];
  List<LatLng> _trackStations = [];
  List<GeofenceMarker> _geofences = [];
  List<Marker> _markers = [];

  bool _showOnMap = false;
  int _completed = 0;
  int _steps = 0;

  LatLng _center = LatLng(0, 0);
  LatLng _lastKnown = LatLng(0, 0);

  MapController _mapController;
  MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();

    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofencesChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);

    bg.BackgroundGeolocation.setOdometer(0);

    bg.BackgroundGeolocation.getCurrentPosition(
      persist: true,
      desiredAccuracy: 40,
      maximumAge: 10000,
      timeout: 30,
      samples: 3,
    ).then((bg.Location location) {
      _lastKnown = LatLng(location.coords.latitude, location.coords.longitude);
      _mapOptions.center = _lastKnown;

      _markers.add(
        Marker(
          point: _lastKnown,
          builder: (BuildContext context) {
            return Icon(Icons.flag, color: Theme.of(context).accentColor);
          },
        ),
      );

      _mapController.move(_lastKnown, 16);
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });

    _mapOptions = MapOptions(
        onPositionChanged: _onPositionChanged, center: _center, zoom: 16.0);
    _mapController = MapController();

    _setupTrack();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _setupTrack() {
    for (Station station in widget.track.stations) {
      bg.Geofence fence = bg.Geofence(
        identifier: station.name,
        radius: 15.0,
        latitude: station.point.latitude,
        longitude: station.point.longitude,
        notifyOnEntry: true,
        loiteringDelay: 5,
      );

      _markers.add(Marker(
        point: station.point,
        builder: (BuildContext context) {
          return Icon(
            Icons.location_on,
            color: Theme.of(context).accentColor,
          );
        },
      ));

      _trackStations.add(station.point);

      bg.BackgroundGeolocation.addGeofence(fence).catchError((error) {
        print('[addGeofence] ERROR: $error');
      });
    }
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timerSeconds < 1) {
            timer.cancel();
          } else {
            _timerSeconds = _timerSeconds - 1;
          }
        },
      ),
    );
  }

  String _formatTimer(int seconds) {
    if (seconds <= 0) return "Tiden är ute!";

    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void _onForfeitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Avbryt slinga?"),
          content: Text(
              "Avbryter banan och visar din position.\nDu kommer inte kunna fortsätta efteråt."),
          actions: <Widget>[
            FlatButton(
              child: Text("Ja"),
              onPressed: () {
                _onForfeit();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Nej"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _onForfeit() {
    setState(() {
      _showOnMap = true;
    });
  }

  void _onEnabledChange(bool enabled) {
    if (!enabled) {
      _trackHistory.clear();
    }
  }

  void _onMotionChange(bg.Location location) async {
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);

    _updateCurrentPositionMarker(ll);

    if (_showOnMap) _mapController.move(ll, _mapController.zoom);
  }

  void _onGeofence(bg.GeofenceEvent event) {
    print(event.identifier);
    GeofenceMarker marker = _geofences.firstWhere(
        (GeofenceMarker marker) =>
            marker.geofence.identifier == event.identifier,
        orElse: () => null);

    if (marker == null) {
      print(
          "[_onGeofence] failed to find geofence marker: ${event.identifier}");
      return;
    }

    // Remove green
    _geofences.removeWhere((GeofenceMarker marker) {
      return marker.geofence.identifier == event.identifier;
    });

    // Add black
    _geofences.add(GeofenceMarker(context, marker.geofence, true));

    // Set last known position
    _lastKnown = marker.point;
    _completed++;

    int i = widget.track.circuit[0];

    //Event
    ActivityManager().newActivity(
        context: widget.context, package: widget.track.activities[0]);
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
    print('[${bg.Event.GEOFENCESCHANGE}] - $event');

    event.off.forEach((String identifier) {
      _geofences.removeWhere((GeofenceMarker marker) {
        return marker.geofence.identifier == identifier;
      });
    });

    event.on.forEach((bg.Geofence geofence) {
      _geofences.add(GeofenceMarker(context, geofence));
    });

    if (event.off.isEmpty && event.on.isEmpty) {
      _geofences.clear();
    }
  }

  void _onLocation(bg.Location location) {
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);

    _updateCurrentPositionMarker(ll);

    bg.BackgroundGeolocation.odometer.then((double value) {
      _steps = value.toInt();
    });

    if (_showOnMap) _mapController.move(ll, _mapController.zoom);

    if (location.sample) {
      return;
    }

    // Add a point to the tracking polyline.
    _trackHistory.add(ll);
  }

  /// Update Big Blue current position dot.
  void _updateCurrentPositionMarker(LatLng ll) {
    _currentPosition.clear();

    // White background
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.white, radius: 10));
    // Blue foreground
    _currentPosition
        .add(CircleMarker(point: ll, color: Colors.blue, radius: 7));
  }

  void _onPositionChanged(MapPosition pos, bool hasGesture) {
    _mapOptions.crs.scale(_mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    List<LayerOptions> mapLayers = [
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
        maxZoom: 17,
        additionalOptions: {
          'id': 'opentopomap',
        },
      ),
      PolylineLayerOptions(polylines: [
        Polyline(
          points: _trackStations,
          strokeWidth: 2,
          color: Colors.black54,
        )
      ]),
      CircleLayerOptions(circles: _geofences),
      MarkerLayerOptions(markers: _markers)
    ];

    if (_showOnMap) {
      mapLayers.addAll([
        PolylineLayerOptions(
          polylines: [
            Polyline(
              points: _trackHistory,
              isDotted: true,
              strokeWidth: 5.0,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
        CircleLayerOptions(circles: _currentPosition),
      ]);
    }

    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: _mapController,
          options: _mapOptions,
          layers: mapLayers,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(color: Colors.black54.withOpacity(0.6)),
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                ),
                Text(
                  "$_steps steps",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 15.0),
                Icon(
                  Icons.flag,
                  color: Colors.white,
                ),
                Text(
                  "$_completed/${_trackStations.length}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 15.0),
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                ),
                Text(
                  "${_formatTimer(_timerSeconds)}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            " © OpenTopoMap (CC-BY-SA) ",
            style: TextStyle(
                backgroundColor: Colors.black54.withOpacity(0.5),
                color: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () {
                      _mapController.move(_lastKnown, 16);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.local_activity),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: _showOnMap ? null : _onForfeitDialog,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GeofenceMarker extends CircleMarker {
  bg.Geofence geofence;

  GeofenceMarker(BuildContext context, bg.Geofence geofence, [bool triggered = false])
      : super(
            useRadiusInMeter: true,
            radius: geofence.radius,
            color: (triggered)
                ? Colors.black54.withOpacity(0.1)
                : Theme.of(context).primaryColor.withOpacity(0.1),
            point: LatLng(geofence.latitude, geofence.longitude)) {
    this.geofence = geofence;
  }
}
