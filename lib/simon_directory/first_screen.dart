import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/sign_in.dart';
import 'package:orientx/fredrik_directory/destination.dart';
import 'profile_page.dart';
import 'start_screen.dart';
import 'settings_page.dart';
import 'sign_in.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstScreenState();
  }
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  
  List<Destination> _destinations;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _destinations = <Destination>[
      Destination('Hem', Icons.home, ProfilePage()),
      Destination('Banor', Icons.flag, StartRun()),
      Destination('Stationer', Icons.camera, SettingsPage()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ThinQRight"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: _destinations.map<Widget>((Destination destination) {
              return destination.screen;
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _destinations.map((Destination destination) {
            return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              title: Text(destination.title),
            );
          }).toList()),
      drawer: _drawerList(context),
    );
  }

  void signOut() {
    signOutGoogle();
    Navigator.pushNamed(context, "/");
  }

  Drawer _drawerList(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 50,
            width: 100,
            child: Center(
                child: Text(
              "Menu",
              style: TextStyle(fontSize: 16),
            )),
          ),
          _createDrawerItem(
              icon: Icons.arrow_forward,
              text: "Logga ut",
              onTap: () => signOut()),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0), child: Text(text))
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
