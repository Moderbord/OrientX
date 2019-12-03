import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/first_screen.dart';
import "simon_directory/login_page.dart";
import 'package:orientx/fredrik_directory/track.dart' as fredde;

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: true,
            startOnBoot: true,
            debug: true,

            //forceReloadOnBoot: true,
            logLevel: bg.Config.LOG_LEVEL_WARNING))
        .then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });




    return MaterialApp(
        title: 'OrientX',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage());
  }
}
