import 'package:flutter/material.dart';
import "simon_directory/login_page.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orientx/fredrik_directory/theme_notifier.dart';
import 'package:orientx/fredrik_directory/themes.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

void main() {
  SharedPreferences.getInstance().then((prefs) {

    int theme = prefs.getInt('theme') ?? 0;

    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(themeFromEnum(Themes.values[theme])),
        child: MyApp(),
      ),
    );
  },);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: true,
            startOnBoot: true,
            logLevel: bg.Config.LOG_LEVEL_WARNING))
        .then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    return MaterialApp(
        title: 'ThinQR', theme: themeNotifier.getTheme(), home: LoginPage());
  }
}
