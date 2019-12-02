import 'package:flutter/material.dart';
import 'sign_in.dart';

class ProfilePage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1,color3],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 50,
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height:35),
                Text(
                    "Welcome " +name + "!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color2
                    )
                ),
              ],
            )
        )
    );
  }
}