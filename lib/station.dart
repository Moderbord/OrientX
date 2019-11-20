import 'package:latlong/latlong.dart';

class Station {

  String name;
  String desc;
  LatLng point;
  String resourceUrl;

  Station(this.name, this.desc, this.point, this.resourceUrl);
}
