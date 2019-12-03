import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'profile_page.dart';
import 'start_screen.dart';
import 'settings_page.dart';

ThemeData original = ThemeData(
  primaryColor: Colors.orange,
  backgroundColor: Colors.white,
                        );

ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.grey,
);

ThemeData wacky = ThemeData(
    primaryColor: Colors.pink,
    backgroundColor: Colors.purple,
);

ThemeData currentTheme = original;

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
        title: Text("OrientX",style: TextStyle(color: currentTheme.backgroundColor),),
        backgroundColor: currentTheme.primaryColor,
      ),
      bottomNavigationBar: Material(
      color: currentTheme.primaryColor,
      child: TabBar( ///WHEN ADDING NEW TABS REMEMBER TO CHANGE THE LENGHT IN THE CONTROLLER
        controller: controller,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.account_box, color: currentTheme.backgroundColor,),child: Text("Profile")),
          Tab(icon: Icon(Icons.play_circle_outline, color: currentTheme.backgroundColor),child: Text("Start")),
          Tab(icon: Icon(Icons.settings, color: currentTheme.backgroundColor,),child: Text("Settings"),)
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
         color: currentTheme.primaryColor,
         child: Center(child:Text("Menu",style: TextStyle(fontSize: 16,color: currentTheme.backgroundColor),)),
       ),
        _createDrawerItem(icon: Icons.home,text: "Home", color: currentTheme.primaryColor), //TODO add onTap
        _createDrawerItem(icon: Icons.account_box,text: "Profile", color: currentTheme.primaryColor), //TODO add onTap
        _createDrawerItem(icon: Icons.settings,text: "Settings", color:currentTheme.primaryColor), //TODO add onTap
      ],
    ),
  );
}

Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap, Color color})
{
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon, color: color,),
        Padding(
          padding: EdgeInsets.only(left:8.0),
          child:Text(text,style: TextStyle(color: color),)
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