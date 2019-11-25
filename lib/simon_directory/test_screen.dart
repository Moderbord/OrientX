import 'package:flutter/material.dart';
import 'sign_in.dart';

class TestPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container
      (
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1,color3],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("i want it all!")
              ],
            )
        ));
  }
}
