import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'first_screen.dart';

class ProfilePage extends StatelessWidget
{
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
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 50,
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height:35),
                Text(
                    "Welcome, " +name + "!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColor
                    )
                ),
              ],
            )
        )
    );
  }
}