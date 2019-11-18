import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "sign_in.dart";
import "first_screen.dart";



class LoginPage extends StatefulWidget
{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        body: Container
        (
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color1,color3]
                )
            ),
          child: Center
          (
            child:Column
            (
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlutterLogo(size: 150,colors: color2,),
                _signInButton(),
              ]
            )
          )
        )
      );
  }


  Widget _signInButton()
  {
    return OutlineButton
      (
        splashColor: color2,
        onPressed: ()
        {
          signInWithGoogle().whenComplete(()
          {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder:(context)
                    {
                      return FirstScreen();
                    }
                )
            );
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: color2),
        child: Padding
          (
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child:Row
              (
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [
                Image(image: AssetImage("assets/images/google_logo.png"),height:20),
                Padding
                  (
                    padding: EdgeInsets.only(left:10),
                    child: Text
                      (
                        "Sign in with Google",
                        style:TextStyle(fontSize: 15,color:color2,)
                    )
                )
              ],
            )
        )
    );
  }

}




