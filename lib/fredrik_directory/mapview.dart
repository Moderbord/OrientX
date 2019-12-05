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

  List<CircleMarker> _currentPosition = [];
  List<LatLng> _polyline = [];
  List<CircleMarker> _locations = [];
  List<GeofenceMarker> _geofences = [];

  LatLng _center = LatLng(0, 0);
  MapController _mapController;
  MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();

    bg.BackgroundGeolocation.getCurrentPosition(
      persist: true,
      desiredAccuracy: 40,
      maximumAge: 10000,
      timeout: 30,
      samples: 3,
    ).then((bg.Location location) {
      _center = LatLng(location.coords.latitude, location.coords.longitude);
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });

    _mapOptions = MapOptions(
        onPositionChanged: _onPositionChanged,
        center: _center,
        zoom: 16.0);
    _mapController = MapController();

    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofencesChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);

    for (Station station in widget.track.stations) {
      bg.Geofence fence = bg.Geofence(
        identifier: station.name,
        radius: 200.0,
        latitude: station.point.latitude,
        longitude: station.point.longitude,
        notifyOnEntry: true,
        loiteringDelay: 5,
      );

      bg.BackgroundGeolocation.addGeofence(fence).catchError((error) {
        print('[addGeofence] ERROR: $error');
      });
    }
  }

  void _onCenterCurrent() {
    _mapController.move(_currentPosition[0].point, 16);
  }

  void _onEnabledChange(bool enabled) {
    if (!enabled) {
      _locations.clear();
      _polyline.clear();
    }
  }

  void _onMotionChange(bg.Location location) async {
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);

    _updateCurrentPositionMarker(ll);

    _mapController.move(ll, _mapController.zoom);
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
    _geofences.add(GeofenceMarker(marker.geofence, true));

    int i = widget.track.circuit[0];

    //Event
    ActivityManager().newActivity(
        context: widget.context, package: widget.track.activities[i]);
  }

  void _onGeofencesChange(bg.GeofencesChangeEvent event) {
    print('[${bg.Event.GEOFENCESCHANGE}] - $event');

    event.off.forEach((String identifier) {
      _geofences.removeWhere((GeofenceMarker marker) {
        return marker.geofence.identifier == identifier;
      });
    });

    event.on.forEach((bg.Geofence geofence) {
      _geofences.add(GeofenceMarker(geofence));
    });

    if (event.off.isEmpty && event.on.isEmpty) {
      _geofences.clear();
    }
  }

  void _onLocation(bg.Location location) {
    LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);

    _mapController.move(ll, _mapController.zoom);

    _updateCurrentPositionMarker(ll);

    if (location.sample) {
      return;
    }

    // Add a point to the tracking polyline.
    _polyline.add(ll);
    // Add a marker for the recorded location.
    //_locations.add(_buildLocationMarker(location));
    _locations.add(CircleMarker(point: ll, color: Colors.black, radius: 5.0));

    _locations.add(CircleMarker(point: ll, color: Colors.blue, radius: 4.0));
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
    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: _mapController,
          options: _mapOptions,
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              maxZoom: 17,
              additionalOptions: {
                'id': 'opentopomap',
              },
            ),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  points: _polyline,
                  isDotted: true,
                  strokeWidth: 10.0,
                  color: Color.fromRGBO(0, 179, 253, 0.8),
                ),
              ],
            ),
            CircleLayerOptions(circles: _geofences),
            CircleLayerOptions(circles: _locations),
            CircleLayerOptions(circles: _currentPosition),
          ],
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
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: _onCenterCurrent,
                  ),
                  IconButton(
                    icon: Icon(Icons.local_activity),
                  ),
                  IconButton(
                    icon: Icon(Icons.directions_walk),
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

  GeofenceMarker(bg.Geofence geofence, [bool triggered = false])
      : super(
            useRadiusInMeter: true,
            radius: geofence.radius,
            color: (triggered)
                ? Colors.black26.withOpacity(0.2)
                : Colors.green.withOpacity(0.3),
            point: LatLng(geofence.latitude, geofence.longitude)) {
    this.geofence = geofence;
  }
}
