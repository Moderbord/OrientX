import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:latlong/latlong.dart';

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

   SessionState _activeState;
   Track _activeTrack;

   List<Function(SessionState state)> _stateListeners = [];
   List<Function(Station station)> _onVisitedListeners = [];
   List<Station> _visitedStations = [];
   List<LatLng> _trackHistory = [];

   int _visitingIndex = 0;

   void setTrack(String id)
   {
      // TODO fetch track from FireBase
      _activeTrack = ServerPackage().fromID(id);
   }

   Track getTrack() => _activeTrack;

   void promptNextActivity(BuildContext context)
   {
      int activityIndex = _activeTrack.activityIndex[_visitingIndex]; // Collects the correct index for the next activity
      _onVisited(_activeTrack.stations[_visitingIndex]);

      ActivityManager().newActivity(context: context, package: _activeTrack.activities[activityIndex]);
      _visitingIndex++;

      if (_visitingIndex >= _activeTrack.stations.length)
         {
            print("Track finished");
            _newSessionState(SessionState.Result);
         }

   }

   void addStateListener(Function(SessionState state) function)
   {
      _stateListeners.add(function);
   }

   void addOnVisitedListeners(Function(Station station) function)
   {
      _onVisitedListeners.add(function);
   }

   void _newSessionState(SessionState state)
   {
      _activeState = state;
      onStateChange();
   }

   // make private
   void onStateChange()
   {
      for (Function  f in _stateListeners)
         {
            f(_activeState);
         }
   }

   void _onVisited(Station station)
   {
      _visitedStations.add(station);
      for (Function  f in _onVisitedListeners)
      {
         f(station);
      }
   }

   void addTrackHistory(LatLng latLng)
   {
      _trackHistory.add(latLng);
   }

   void setSessionState(SessionState state)
   {
      _activeState = state;
      onStateChange();
   }

   // remove
   int i = 1;

   // remove
   void nextSessionState()
   {
      _activeState = SessionState.values[i];
      i++;
      if(i >= SessionState.values.length)
      {
         i = 0;
      }
      onStateChange();
   }

   // remove
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

   void flush()
   {
      _activeState = null;
      _activeTrack = null;
      _stateListeners = [];
      _onVisitedListeners = [];
      _visitedStations = [];
      _trackHistory = [];
      _visitingIndex = 0;
   }

}
