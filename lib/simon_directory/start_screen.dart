import 'package:flutter/material.dart';
import 'first_screen.dart';


class StartRun extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _StartRunState();
  }
}

class _StartRunState extends State<StartRun>
{

  String result = "";

  @override
  Widget build(BuildContext context)
  {
    return Container
      (
        decoration: BoxDecoration(
           color: currentTheme.backgroundColor
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: currentTheme.primaryColor),
                  decoration: InputDecoration(
                    labelText: "Ban-nummer",
                    labelStyle: TextStyle(color: currentTheme.primaryColor),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: currentTheme.primaryColor)),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: currentTheme.primaryColor)),
                  ),
                  onChanged: (String text){
                    setState((){
                      result = text;
                    });
                  },
                ),
                Text(result),
                RaisedButton(
                  color: currentTheme.backgroundColor,
                  textColor: currentTheme.primaryColor,
                  shape: RoundedRectangleBorder(side: BorderSide(color: currentTheme.primaryColor)),
                  child: Text("Starta Bana",style: TextStyle(color: currentTheme.primaryColor),),
                  onPressed: (){

                  },
                )
              ],
            )
        ));
  }
}
