import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'start_screen.dart';
import 'settings_page.dart';

class FirstScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _FirstScreenState();
  }
}


class _FirstScreenState extends State<FirstScreen> with SingleTickerProviderStateMixin
{

  List<Widget> _children;
  TabController controller;

  @override
  void initState()
  {
    super.initState();
    controller = TabController(vsync: this,length: 3);
    _children = [
      ProfilePage(),
      StartRun(),
      SettingsPage(notifyParent: refresh,)
    ];
  }

  @override
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrientX"),
      ),
      bottomNavigationBar: Material(
      child: TabBar( ///WHEN ADDING NEW TABS REMEMBER TO CHANGE THE LENGHT IN THE CONTROLLER
        controller: controller,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.account_box),child: Text("Profile")),
          Tab(icon: Icon(Icons.play_circle_outline),child: Text("Start")),
          Tab(icon: Icon(Icons.settings),child: Text("Settings"),)
        ],
      )),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: _children,
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
       Container(
         height: 50,
         width: 100,
         child: Center(child:Text("Menu",style: TextStyle(fontSize: 16),)),
       ),
        _createDrawerItem(icon: Icons.home,text: "Home"), //TODO add onTap
        _createDrawerItem(icon: Icons.account_box,text: "Profile"), //TODO add onTap
        _createDrawerItem(icon: Icons.settings,text: "Settings"), //TODO add onTap
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
    onTap: (){
      onTap();
    },
  );
}

Widget _createDrawerHeader({String image,String text, Color color})
{
  return DrawerHeader(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text,
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ),
      ],
    ),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover
      ),
    ),
  );
}