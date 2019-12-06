import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:orientx/fredrik_directory/theme_notifier.dart';
import 'package:orientx/fredrik_directory/themes.dart';

import "first_screen.dart";

class SettingsPage extends StatefulWidget {
  final Function() notifyParent;

  SettingsPage({Key key, @required this.notifyParent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentTheme = themeNotifier.getTheme();
    final selectedTheme = themeGetEnum(currentTheme);

    return Container(
        decoration: BoxDecoration(color: currentTheme.backgroundColor),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DropdownButton<Themes>(
                value: selectedTheme,
                icon: Icon(
                  Icons.color_lens,
                  color: currentTheme.primaryColor,
                ),
                iconSize: 16,
                elevation: 12,
                underline: Container(
                  color: currentTheme.backgroundColor,
                  height: 2,
                ),
                //when options are changed function down below
                onChanged: (Themes theme) {
                  setState(() {
                    onThemeChanged(theme, themeNotifier);
                  });
                },
                items: Themes.values.map((Themes theme) {
                  return DropdownMenuItem<Themes>(
                      value: theme, child: Text(getThemeName(theme)));
                }).toList()),
          ],
        )));
  }

  void onThemeChanged(Themes theme, ThemeNotifier themeNotifier) async {
    themeNotifier.setTheme(themeFromEnum(theme));

    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', theme.index);
  }
}
