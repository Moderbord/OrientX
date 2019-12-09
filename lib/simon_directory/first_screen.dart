import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/sign_in.dart';
import 'package:orientx/simon_directory/sign_in.dart' as prefix0;
import 'profile_page.dart';
import 'start_screen.dart';
import 'settings_page.dart';
import 'sign_in.dart';

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
        title: Text("ThinQRight"),
      ),
      bottomNavigationBar: Material(
      child: TabBar( ///WHEN ADDING NEW TABS REMEMBER TO CHANGE THE LENGTH IN THE CONTROLLER
        controller: controller,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.account_box), child: Text("Profile")),
          Tab(icon: Icon(Icons.play_circle_outline), child: Text("Start")),
          Tab(icon: Icon(Icons.settings), child: Text("Settings"),)
        ],
      )),
      body: WillPopScope(
        onWillPop: () async{
          return Future.value(false);
        },
        child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: _children,
      ),
      ),
      drawer:_drawerList(context),
    );
  }

  void signOut()
  {
    signOutGoogle();
    Navigator.pushNamed(context, "/");
  }

  Drawer _drawerList(BuildContext context)
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
          _createDrawerItem(icon: Icons.arrow_forward,text: "Logga ut",onTap: () => signOut()),
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

}


