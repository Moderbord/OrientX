import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

class Database {
  static final _databaseReference = Firestore.instance;

  static Database _database;

  _Database() {}

  static Database getInstance() {
    if (_database == null) {
      _database = new Database();
    }
    return _database;
  }

/*  void createRecord(String collection, String doc, ) async {
    await databaseReference
        .collection("testboop")
        .document("1")
        .setData({'title': 'bladibla', 'desc': 'ladida'});
    DocumentReference docRef = await databaseReference
        .collection("testboop")
        .add({'title': 'WOOOOP', 'desc': 'slurpad'});
    print(docRef.documentID);
  }*/

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

  ActivityPackage toActivityPackage(Map<String, dynamic> dataMap) {
    List<dynamic> tmp = dataMap['Answers'];
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

  // TODO remove dependency
  Future<List<ActivityPackage>> getData() async {
    List<ActivityPackage> pList = [];
    await _databaseReference
        .collection("Activity")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      pList = toPackages(snapshot);
    });
    return pList;
  }

  // TODO remove dependency
  List<ActivityPackage> toPackages(QuerySnapshot snapshot) {
    List<ActivityPackage> packageList = [];
    snapshot.documents.forEach((f) {
      Map<String, dynamic> tmpMap = f.data;

      List<dynamic> tmp = tmpMap['Answers'];
      List<String> answers = tmp.cast<String>();

      tmp = tmpMap['Questions'];
      List<String> questions = tmp.cast<String>();

      ActivityPackage package = new ActivityPackage(
          activityName: tmpMap['ActivityName'],
          id: tmpMap['ID'],
          description: tmpMap['Desc'],
          answers: answers,
          dataSource: tmpMap['DataSrc'],
          dataType: DataType.values[tmpMap['DataType']],
          duration: tmpMap['Duration'],
          questions: questions,
          questionType: QuestionType.values[tmpMap['QuestType']]);

      packageList.add(package);
    });
    return packageList;
  }

/*  void deleteData(String collection, String doc) {
    try {
      databaseReference
          .collection('testboop')
          .document('1')
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }*/
}
