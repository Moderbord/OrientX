/// The Login Page contains the means to log into a google account or enter as a guest
/// This is the first page that loads when you start the app

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/auth/sign_in.dart';
import 'main_page.dart';

/// LoginPage class that just creates a state of the class below
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// LoginPage is used for the scaffold that is used for logging in
class _LoginPageState extends State<LoginPage> {
  /// Method that sets the guests previous stats with shared preferences
  setGuest(bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("isguest", b);
    });
  }

  /// Basic scaffold with two buttons and a logo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.not_listed_location,
                  size: 150, color: Theme.of(context).accentColor),
              Text(
                "ThinQRight",
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(height: 100.0),
              _signInButton(),
              _signInGuest(),
            ],
          ),
        ),
      ),
    );
  }

  /// A sign in button that uses the google sign in Firebase authentication.
  Widget _signInButton() {
    return OutlineButton(
      onPressed: () {
        // A function in the file sign_in.dart for logging into a google account
        signInWithGoogle().whenComplete(
          () {
            setState(() {
              setGuest(false);
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  // When logged in, go to first screen
                  return FirstScreen();
                },
              ),
            );
          },
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"), height: 20),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child:
                    Text("Sign in with Google", style: TextStyle(fontSize: 15)))
          ],
        ),
      ),
    );
  }

  /// A "sign in as guest" button.
  ///
  /// Sets all profile settings to the guest alternative.
  Widget _signInGuest() {
    return OutlineButton(
      onPressed: () {
        setState(() {
          // Set the profile
          email = "Guest";
          name = "Guest";
          profileImage = Image(
            image: AssetImage("assets/images/guest.png"),
          );
          setGuest(true);
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FirstScreen(); ///set guest and return first screen
            },
          ),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_circle, color: Theme.of(context).accentColor),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child:
                    Text("Sign in as Guest", style: TextStyle(fontSize: 15))),
            Padding(
              padding: EdgeInsets.only(left: 20),
            ),
          ],
        ),
      ),
    );
  }
}
