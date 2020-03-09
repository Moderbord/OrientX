import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/add_station_page.dart';
import 'package:orientx/simon_directory/sign_in.dart';
import 'package:orientx/fredrik_directory/destination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';
import 'package:orientx/fredrik_directory/track_page.dart';
import 'sign_in.dart';

/*
This page is the structure of the app, it contains means for getting around
*/

///First screen state creator
class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstScreenState();
  }
}

///First screen class
class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {
  List<Destination> _destinations;
  List<AnimationController> _faders;
  List<Key> _destinationKeys;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ///All the destinations in the bottom hot bar
    _destinations = <Destination>[
      Destination(0, 'Hem', Icons.home, ProfilePage()),
      Destination(1, 'Lopp', Icons.flag, TrackPage()),
      Destination(2, 'Stationer', Icons.camera, AddStationPage()),
    ];

    _faders = _destinations.map<AnimationController>((Destination destination) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 250));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(_destinations.length, (int index) => GlobalKey())
            .toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
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
          child: Stack(
            fit: StackFit.expand,
            children: _destinations.map((Destination destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index]
                    .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                child: KeyedSubtree(
                    key: _destinationKeys[destination.index],
                    child: destination.screen),
              );
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();
                return view;
              } else {
                _faders[destination.index].reverse();
                if (_faders[destination.index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          )),
      ///Navigation bar for the navigations higher up in the code
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
      ///A drawer that you can swipe from the left to pop up with settings and log out options
      drawer: _drawerList(context),
    );
  }
  ///sign out with google
  void signOut() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("isguest"))
      {
        prefs.setBool("isguest", false);
      }
    else
      {
        signOutGoogle();
      }
    Navigator.pushNamed(context, "/");
  }
  ///List of drawers that contain settings and log out
  Drawer _drawerList(BuildContext context) {
    return Drawer(
      child: SafeArea(
        top: true,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 50,
              width: 100,
              child: Center(
                  child: Text(
                "Meny",
                style: TextStyle(fontSize: 16),
              )),
            ),
            _createDrawerItem(
                icon: Icons.settings,
                text: "Inställningar",
                onTap: () {
                  Navigator.pushNamed(context, "/Settings");
                }),
            _createDrawerItem(
                icon: Icons.arrow_forward,
                text: "Logga ut",
                onTap: () => signOut()),

          ],
        ),
      ),
    );
  }

  ///Method for creating drawers
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
