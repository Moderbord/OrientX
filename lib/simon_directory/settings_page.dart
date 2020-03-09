import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:orientx/fredrik_directory/theme_notifier.dart';
import 'package:orientx/fredrik_directory/themes.dart';

/*
Page for settings, only used for color theme at the moment
 */


class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}
///Settings Page State
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentTheme = themeNotifier.getTheme();
    final selectedTheme = themeGetEnum(currentTheme);

    final title = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Inställningar"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(color: Theme
                      .of(context)
                      .accentColor,),
                  child: Text("Tema: ", style: title),
                ),
                SizedBox(width: 10,),
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
            )
          ],
        ),
      ),
    );
  }

  void onThemeChanged(Themes theme, ThemeNotifier themeNotifier) async {
    themeNotifier.setTheme(themeFromEnum(theme));

    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', theme.index);
  }
}
