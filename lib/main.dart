import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/settings_page.dart';
import "simon_directory/login_page.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orientx/fredrik_directory/theme_notifier.dart';
import 'package:orientx/fredrik_directory/themes.dart';
import 'simon_directory/first_screen.dart';
import 'simon_directory/sign_in.dart';

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

class MyApp extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
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
        title: 'ThinQRight',
        theme: themeNotifier.getTheme(),
        home: LoginPage(),
        onGenerateRoute: (RouteSettings settings){
          switch(settings.name)
          {
            case "/":
              return SlideRightRoute(widget: LoginPage());
            case "/First":
              return SlideRightRoute(widget: FirstScreen());
            case "/Settings":
              return SlideRightRoute(widget: SettingsPage());
          }
          return null;
        },
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return widget;
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}