import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:latlong/latlong.dart';

class ServerPackage {
  final ActivityPackage rndImagePkg = ActivityPackage(
    activityName: "Mycket stiligt",
    id: "111",
    dataSource: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_1MG.mp3",
    dataType: DataType.Sound,
    description: "Vad är detta för gudomlighet?",
    questions: <String>["Hemligt", "Oklart", "Drake"],
    questionType: QuestionType.Single,
    answers: <String>["Oklart"],
    duration: 20,
  );

  final ActivityPackage videoPkg = ActivityPackage(
    activityName: "Vad ser du på Kalle?",
    id: "222",
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
    id: "333",
    dataSource:
        "https://a9p9n2x2.stackpathcdn.com/wp-content/blogs.dir/1/files/2011/01/raised-eyebrow.jpg",
    dataType: DataType.Image,
    description: "Vad gömmer sig bakom blicken?",
    questions: <String>["Mona Lisa", "Nivea", "Jesus"],
    questionType: QuestionType.Single,
    answers: <String>["Jesus"],
    duration: 7,
  );

  final ActivityPackage tvaTill = ActivityPackage(
    activityName: "Oh Barken",
    id: "444",
    dataSource: "https://source.unsplash.com/random/800x600",
    dataType: DataType.Image,
    description: "Hoolaaa",
    questions: <String>["2", "3", "4"],
    questionType: QuestionType.Single,
    answers: <String>["2"],
    duration: 7,
  );

  final List<Station> skeStationList = [
    Station(
        name: "Lakeside Shrubbery",
        point: LatLng(64.745597, 20.950119),
        resourceUrl:
            'https://www.orientering.se/media/images/DSC_2800.width-800.jpg'),
    Station(
        name: "Rock by the lake",
        point: LatLng(64.745124, 20.957779),
        resourceUrl:
            'http://www.nationalstadsparken.se/Sve/Bilder/orienteringskontroll-mostphotos-544px.jpg'),
    Station(
        name: "The wishing tree",
        point: LatLng(64.752627, 20.952363),
        resourceUrl:
            'https://www.fjardhundraland.se/wp-content/uploads/2019/08/oringen-uppsala-fjacc88rdhundraland-orienteringskontroll.jpg'),
  ];

  final List<Station> umeStationList = [
    Station(
        name: "Umeå älv",
        point: LatLng(63.827423, 20.237772),
        resourceUrl:
            'https://blogg.kriminalvarden.se/globalassets/hakte_anstalt/umea-bjorkarnas-stad.jpg'),
    Station(
        name: "Rådhustorget",
        point: LatLng(63.824740, 20.262291),
        resourceUrl:
            'https://upload.wikimedia.org/wikipedia/commons/8/8f/Umea_radhus_from_south.jpg'),
    Station(
        name: "Umeå stadskyrka",
        point: LatLng(63.823197, 20.267334),
        resourceUrl:
            'https://falco-prod-facelift-cdnendpoint.azureedge.net/media/1741/umea-webpuff.jpg'),
    Station(
        name: "Klädnypan",
        point: LatLng(63.819695, 20.278953),
        resourceUrl:
            'https://resfredag.se/wp-content/uploads/2018/09/ume%C3%A536-1200x800.png'),
  ];

  Track fromID(String id) {
    return Track(
      name: "Mysslinga",
      stations: umeStationList,
      activities: [rndImagePkg, videoPkg, enTill, tvaTill],
      type: courseType.standard,
    );
  }

  bool checkID(String id) {
    switch (id) {
      case "ABC":
        return true;
      default:
        return false;
    }
  }
}
