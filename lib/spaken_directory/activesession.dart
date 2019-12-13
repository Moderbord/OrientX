import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/luddw_dir/db.dart';

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
   List<bool> _answerHistory = [];

   int _visitingIndex = 0;



   // TODO make this server
   final List<Station> stationList = [
      Station(name: "Lakeside Shrubbery", point: LatLng(64.745597, 20.950119), resourceUrl: 'https://www.orientering.se/media/images/DSC_2800.width-800.jpg'),
      /*Station(
          name: "Rock by the lake", point: LatLng(64.745124, 20.957779), resourceUrl: 'http://www.nationalstadsparken.se/Sve/Bilder/orienteringskontroll-mostphotos-544px.jpg'),
      Station(
          name: "The wishing tree", point: LatLng(64.752627, 20.952363), resourceUrl: 'https://www.fjardhundraland.se/wp-content/uploads/2019/08/oringen-uppsala-fjacc88rdhundraland-orienteringskontroll.jpg')*/
   ];


   Future<void> _getPackages() async
   {
      List<ActivityPackage> localActivities = [];

      await Database.getInstance().getData().then((List<ActivityPackage> serverActivities)
      {
         print("fetched");
         for (ActivityPackage pkg in serverActivities)
         {
            print(pkg.activityName);
         }
         localActivities = serverActivities;
      });

      _activeTrack = Track(
         name: "Mysslinga",
         stations: stationList,
         activities: localActivities,
         type: courseType.random,
      );

   }

   void setTrack(String id)
   {
      // TODO fetch track from FireBase
      //_getPackages();
      _activeTrack = ServerPackage().fromID(id);
   }

   Track getTrack() => _activeTrack;

   void promptNextActivity(BuildContext context)
   {
      int activityIndex = _activeTrack.activityIndex[_visitingIndex]; // Collects the correct index for the next activity
      _onVisited(_activeTrack.stations[_visitingIndex]);

      ActivityManager().newActivity(context: context, package: _activeTrack.activities[activityIndex]).then((bool answer){ // Launch activity from id instead of index?
         _answerHistory.add(answer);
      });
      _visitingIndex++;

      if (_visitingIndex >= _activeTrack.stations.length)
         {
            print("Track finished");
            setSessionState(SessionState.Result);
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

   void setSessionState(SessionState state)
   {
      _activeState = state;
      _onStateChange();
   }

   void addTrackHistory(LatLng latLng)
   {
      _trackHistory.add(latLng);
   }

   bool getAnswer(int i)
   {
      return _answerHistory[i] ?? false;
   }

   void _onStateChange()
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



   // TODO close session (set inactive? reset?)
   // TODO create buffers for packages and Track data
   // TODO download track packages and activity packages on init/set active into buffers
   // TODO receive geoCache prompt with station ID and initiate activityManager
   // TODO launch activity from station ID
   // TODO getter for num answered questions, num visited stations, num steps walked, num completed courses

   void flush()
   {
      _activeState = null;
      _activeTrack = null;
      _stateListeners = [];
      _onVisitedListeners = [];
      _visitedStations = [];
      _trackHistory = [];
      _answerHistory = [];
      _visitingIndex = 0;


   }

}
