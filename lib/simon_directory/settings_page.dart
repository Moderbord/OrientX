import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "first_screen.dart";

class SettingsPage extends StatefulWidget
{
  final Function() notifyParent;
  SettingsPage({Key key, @required this.notifyParent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}



class _SettingsPageState extends State<SettingsPage>
{
  String dropdownValue = "Original";

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                DropdownButton(
                  value: dropdownValue,
                  icon: Icon(Icons.color_lens,color: currentTheme.primaryColor,),
                  iconSize: 16,
                  elevation: 12,
                  underline: Container(
                    color: currentTheme.backgroundColor,
                    height: 2,
                  ),
                  //when options are changed function down below
                  onChanged: (String newValue)
                  {
                    dropdownValue = newValue;
                    switch(newValue)
                    {
                      case "Original":
                        currentTheme = original;
                        break;
                      case "Dark":
                        currentTheme = dark;
                        break;
                      case "Wacky":
                        currentTheme = wacky;
                        break;
                    }
                    widget.notifyParent();
                  },
                  //Options
                  items: <String>["Original","Dark","Wacky"]
                      .map<DropdownMenuItem<String>>((String value)
                  {
                    return DropdownMenuItem<String> (
                      value: value,
                      child: Text(value, style: TextStyle(color: currentTheme.primaryColor),),
                    );
                  }).toList()
                  ,
                )
              ],
            )
        )
    );
  }
}