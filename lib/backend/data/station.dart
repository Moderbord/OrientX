import 'package:latlong/latlong.dart';

/// Represents a station.
///
/// Contains name, long description, coordinates, and image URL.
class Station {

  String name;
  String desc;
  LatLng point;
  String resourceUrl;

  Station({this.name, this.desc, this.point, this.resourceUrl});
}
