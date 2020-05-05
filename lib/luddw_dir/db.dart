import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

/// Singleton class which handles functionality with the database.
///
class Database {
  static final _databaseReference = Firestore.instance;

  static Database _database;

  static Database getInstance() {
    if (_database == null) {
      _database = new Database();
    }
    return _database;
  }

  /// Fetches a Track from the database with corresponding Stations and Activities
  Future<Track> getTrack(String trackID) async {
    Track track;
    List<Station> stations = [];
    List<ActivityPackage> activityPackages = [];
    Map<String, dynamic> trackData;

    await _databaseReference
        .collection("Tracks")
        .where("ID", isEqualTo: trackID)
        .getDocuments()
        .then((QuerySnapshot trackSnapshot) {
      trackData = trackSnapshot
          .documents[0].data; // Should only find one // TODO add error handling
    });

    // fetch stations
    await _databaseReference
        .collection("Stations")
        .where("ID", whereIn: trackData['StationIDs'])
        .getDocuments()
        .then((QuerySnapshot stationSnapshot) {
      stationSnapshot.documents
        ..forEach((station) {
          stations.add(toStation(station.data));
        });
    });

    // fetch activities
    await _databaseReference
        .collection("Activity")
        .where("ID", whereIn: trackData['ActivityIDs'])
        .getDocuments()
        .then((QuerySnapshot activitySnapshot) {
      activitySnapshot.documents
        ..forEach((activityPackage) {
          activityPackages.add(toActivityPackage(activityPackage.data));
        });
    });

    // create track
    track = new Track(
        name: trackData['TrackName'],
        stations: stations,
        activities: activityPackages,
        type: courseType.random);

    return track;
  }

  /// Converts retrieved data to Stations
  Station toStation(Map<String, dynamic> dataMap) {
    GeoPoint geoPoint = dataMap['Point']; //Extract GeoPoint

    Station station = new Station(
      name: dataMap['Name'],
      desc: dataMap['Desc'],
      point: LatLng(geoPoint.latitude, geoPoint.longitude),
      resourceUrl: dataMap['ResourceURL'],
    );

    return station;
  }

  /// Converts retrieved data to ActivityPackages
  ActivityPackage toActivityPackage(Map<String, dynamic> dataMap) {
    List<dynamic> tmp = dataMap['Answers']; // Database list is structured different and needs to be converted
    List<String> answers = tmp.cast<String>();

    tmp = dataMap['Questions'];
    List<String> questions = tmp.cast<String>();

    ActivityPackage activityPackage = new ActivityPackage(
        activityName: dataMap['ActivityName'],
        id: dataMap['ID'],
        description: dataMap['Desc'],
        answers: answers,
        dataSource: dataMap['DataSrc'],
        dataType: DataType.values[dataMap['DataType']],
        duration: dataMap['Duration'],
        questions: questions,
        questionType: QuestionType.values[dataMap['QuestType']]);

    return activityPackage;
  }

}
