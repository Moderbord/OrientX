import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:flutter/material.dart";

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();


String name,email,imageURL;
Image profileImage;

/// Sign in with google using Firebase authentication.
Future<String> signInWithGoogle() async
{
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  
  final AuthCredential credential = GoogleAuthProvider.getCredential
    (
      idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken
    );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  name = user.displayName;
  email = user.email;
  imageURL = user.photoUrl;
  profileImage = Image.network(imageURL);

  if (name.contains(" ")) {name = name.substring(0, name.indexOf(" "));}

  assert(!user.isAnonymous);
  assert(await user.getIdToken()!= null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return "signInWithGoogle succeeded: $user";
}

/// Signs out from the current Google account.
void signOutGoogle() async
{
  try{
    await _auth.signOut();
    await googleSignIn.signOut();
    print(_auth.currentUser());
    print(googleSignIn.currentUser);
    print("User signed out");
  } catch(e)
  {
    print("Error signing out");
  }
}

/// Changes the current Google user.
///
/// TODO: Not implemented.
void changeUserGoogle()
{
  signOutGoogle();
  signInWithGoogle();
}