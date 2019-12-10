import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';

// Singleton
class ActiveSession
{
   static final ActiveSession _instance = new ActiveSession();

   static ActiveSession getInstance() { return _instance;}

   _ActiveSession() {}

   Track _activeTrack;

   void setTrack(String id)
   {
      // TODO fetch track from FireBase
      _activeTrack = ServerPackage().fromID(id);
   }
   Track getTrack() => _activeTrack;

   void promptNextActivity(BuildContext context)
   {
      ActivityManager().newActivity(context: context, package: _activeTrack.activities[0]); // TODO dynamic course
   }


   // TODO close session (set inactive? reset?)
   // TODO create buffers for packages and Track data
   // TODO download track packages and activity packages on init/set active into buffers
   // TODO receive geoCache prompt with station ID and initiate activityManager
   // TODO add station ID to visited list
   // TODO launch activity from station ID
   // TODO receive result from activity and store it in buffer
   // TODO add callback to SlidingPanel -OnAnswered?
   // TODO make call when track is over
   // TODO fetch data for result screen
   // TODO enum for state change
   // TODO listeners for onStateChange



}
