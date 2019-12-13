import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';

enum SessionState
{
   Start,
   Run,
   Result
}



// Singleton
class ActiveSession
{
   static final ActiveSession _activeSession = ActiveSession._internal();

   factory ActiveSession()
   {
      return _activeSession;
   }

   ActiveSession._internal()
   {
      _activeState = SessionState.Start;
   }

   Track _activeTrack;
   SessionState _activeState;
   List<Function(SessionState state)> _stateListeners = [];

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

   void addStateListener(Function(SessionState state) function)
   {
      _stateListeners.add(function);
   }

   void _newSessionState(SessionState state)
   {
      _activeState = state;
      onStateChange();
   }

   void onStateChange()
   {
      for (Function  f in _stateListeners)
         {
            f(_activeState);
         }
   }

   int i = 1;

   void setState()
   {
      _activeState = SessionState.values[i];
      i++;
      if(i >= SessionState.values.length)
      {
         i = 0;
      }
   }

   String getCurrentState()
   {
      return _activeState.toString();
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
}
