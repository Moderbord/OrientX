import 'package:flutter/material.dart';
import 'sign_in.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color1,color3]
            )
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
        ),
      drawer:_drawerList(),
      );
  }
}

Drawer _drawerList()
{
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          width: 1000,
          height: 25,
        ),
        _createDrawerItem(text: "Menu"),
        _createDrawerItem(icon: Icons.home,text: "Home"), //TODO add onTap
        _createDrawerItem(icon: Icons.account_box,text: "Profile"), //TODO add onTap
        _createDrawerItem(icon: Icons.settings,text: "Settings", onTap: fakeScreen),
      ],
    ),
  );
}


Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap})
{
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left:8.0),
          child:Text(text)
        )
      ],
    ),
    onTap: onTap,
  );
}

Scaffold fakeScreen()
{
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        color: color2
      )
    ),
  );
}