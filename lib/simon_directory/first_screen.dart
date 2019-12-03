import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'profile_page.dart';
import 'test_screen.dart';

class FirstScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _FirstScreenState();
  }
}


class _FirstScreenState extends State<FirstScreen> with SingleTickerProviderStateMixin
{

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this,length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrientX",style: TextStyle(color: color3),),
        backgroundColor: color1,
      ),
      bottomNavigationBar: Material(
      color: color2,
      child: TabBar(
        controller: controller,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.account_box, color: color3,),child: Text("ompa")),
          Tab(icon: Icon(Icons.settings, color: color3),child: Text("lompa"))
        ],
      )),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          TestPage(),
          ProfilePage(),
        ],
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
 //       SizedBox(
 //         width: 1000,
 //         height: 25,
 //       ),
 //       _createDrawerItem(text: "Menu"),
        _createDrawerHeader(image: "assets/images/orange.jpg",text:"menu stuffs", color: color2),
        _createDrawerItem(icon: Icons.home,text: "Home", color: color1), //TODO add onTap
        _createDrawerItem(icon: Icons.account_box,text: "Profile", color: color2), //TODO add onTap
        _createDrawerItem(icon: Icons.settings,text: "Settings", color: color3), //TODO add onTap
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