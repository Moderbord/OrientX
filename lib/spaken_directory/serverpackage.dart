import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:latlong/latlong.dart';

class ServerPackage
{
   final ActivityPackage rndImagePkg = ActivityPackage(
      activityName: "Mycket stiligt",
      id: 123,
      dataSource: "https://source.unsplash.com/random/800x600",
      dataType: DataType.Image,
      description: "Vad är detta för gudomlighet?",
      questions: <String>["Hemligt", "Oklart", "Drake"],
      questionType: QuestionType.Single,
      answers: <String>["Oklart"],
      duration: 7,
   );

   final ActivityPackage videoPkg = ActivityPackage(
      activityName: "Vad ser du på Kalle?",
      id: 123,
      dataSource:
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      dataType: DataType.Video,
      description: "Vad är detta för gudomlighet?",
      questions: <String>["Flygande", "Butterfree", "Spindel", "Majblomma"],
      questionType: QuestionType.Multiple,
      answers: <String>["Flygande", "Butterfree"],
      duration: 10,
   );

   final ActivityPackage enTill = ActivityPackage(
      activityName: "Oh Mhürer",
      id: 123,
      dataSource:
      "https://a9p9n2x2.stackpathcdn.com/wp-content/blogs.dir/1/files/2011/01/raised-eyebrow.jpg",
      dataType: DataType.Image,
      description: "Vad gömmer sig bakom blicken?",
      questions: <String>["Mona Lisa", "Nivea", "Jesus"],
      questionType: QuestionType.Single,
      answers: <String>["Jesus"],
      duration: 7,
   );

   final List<Station> stationList = [
      Station(name: "Lakeside Shrubbery", point: LatLng(64.745597, 20.950119)),
      Station(
          name: "Shrekway Bus Station", point: LatLng(64.745124, 20.957779)),
      Station(
          name: "3 boys in a sleeping bag", point: LatLng(64.752627, 20.952363))
   ];

   Track fromID(int id)
   {
      return Track(
          name: "Mysslinga",
          stations: stationList,
          activities: [rndImagePkg, videoPkg, enTill],
          type: circuitType.random,
      );
   }

   bool checkID(int id)
   {
      switch (id)
      {
         case 0:
            return false;
         case 123:
            return true;
         default:
            return false;
      }
   }

}

