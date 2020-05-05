import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:latlong/latlong.dart';

/// A local server package made for testing
class ServerPackage
{
   final ActivityPackage rndImagePkg = ActivityPackage(
      activityName: "Activity 1",
      id: "111",
      dataSource: "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta?",
      questions: <String>["Stad", "Natur", "Vet ej"],
      questionType: QuestionType.Single,
      answers: <String>["Vet ej"],
      duration: 7,
   );

   final ActivityPackage videoPkg = ActivityPackage(
      activityName: "Activity 2",
      id: "222",
      dataSource:
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      dataType: DataType.Video,
      description: "Vad är detta?",
      questions: <String>["Flygande", "Butterfree", "Spindel", "Majblomma"],
      questionType: QuestionType.Multiple,
      answers: <String>["Flygande", "Butterfree"],
      duration: 10,
   );

   final ActivityPackage rndImagePkg2 = ActivityPackage(
      activityName: "Activity 3",
      id: "333",
      dataSource:
      "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta nu igen?",
      questions: <String>["Hav", "Berg", "Vet ej"],
      questionType: QuestionType.Single,
      answers: <String>["Vet ej"],
      duration: 7,
   );

   final List<Station> stationList = [
      Station(name: "Lakeside Shrubbery", point: LatLng(64.745597, 20.950119), resourceUrl: 'https://www.orientering.se/media/images/DSC_2800.width-800.jpg'),
      Station(
          name: "Rock by the lake", point: LatLng(64.745124, 20.957779), resourceUrl: 'http://www.nationalstadsparken.se/Sve/Bilder/orienteringskontroll-mostphotos-544px.jpg'),
      Station(
          name: "The wishing tree", point: LatLng(64.752627, 20.952363), resourceUrl: 'https://www.fjardhundraland.se/wp-content/uploads/2019/08/oringen-uppsala-fjacc88rdhundraland-orienteringskontroll.jpg')
   ];

   /// Returns a pre-constructed Track with given ID (currently id doesn't matter)
   Track fromID(String id)
   {
      return Track(
          name: "Mysslinga",
          stations: stationList,
          activities: [rndImagePkg, videoPkg, rndImagePkg2],
          type: courseType.random,
      );
   }

   /// Hardcoded check that the track exists (should be moved to server)
   bool checkID(String id)
   {
      switch (id)
      {
         case "ABC":
            return true;
         default:
            return false;
      }
   }

}

