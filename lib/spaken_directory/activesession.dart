import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/fredrik_directory/station.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';
import 'package:orientx/spaken_directory/answerpackage.dart';
import 'package:orientx/spaken_directory/serverpackage.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';
import 'package:orientx/luddw_dir/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SessionState
{
   Start,
   Run,
   Result,
   Finished
}

// Singleton
class ActiveSession {
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

   List<Function(SessionState state)

   >

   _stateListeners

   =

   [

   ];

   List<Function(Station station)

   >

   _onVisitedListeners

   =

   [

   ];

   List<Station> _visitedStations = [];
   List<LatLng> _trackHistory = [];
   List<AnswerPackage> _answerHistory = [];

   bool _lapCompleted = false;
   int _visitingIndex = 0;
   int _numSteps = 0;


   // TODO make this server
   final List<Station> stationList = [
      Station(name: "Lakeside Shrubbery",
          point: LatLng(64.745597, 20.950119),
          resourceUrl: 'https://www.orientering.se/media/images/DSC_2800.width-800.jpg'),
      /*Station(
          name: "Rock by the lake", point: LatLng(64.745124, 20.957779), resourceUrl: 'http://www.nationalstadsparken.se/Sve/Bilder/orienteringskontroll-mostphotos-544px.jpg'),
      Station(
          name: "The wishing tree", point: LatLng(64.752627, 20.952363), resourceUrl: 'https://www.fjardhundraland.se/wp-content/uploads/2019/08/oringen-uppsala-fjacc88rdhundraland-orienteringskontroll.jpg')*/
   ];


   _getTrack(String trackID) {
      Database.getInstance().getTrack(trackID).then((
          Track track) // TODO exception handling on track ID
      {
         print("track fetched");
         _activeTrack = track;

         setSessionState(SessionState.Run);
      });
   }


   _getPackages() {
      List<ActivityPackage> localActivities = [];

      Database.getInstance().getData().then((
          List<ActivityPackage> serverActivities) {
         print("fetched");
         for (ActivityPackage pkg in serverActivities) {
            print(pkg.activityName);
         }
         localActivities = serverActivities;

         _activeTrack = Track(
            name: "Mysslinga",
            stations: stationList,
            activities: localActivities,
            type: courseType.random,
         );

         setSessionState(SessionState.Run);
      });
   }

   _manualPackage(String id) {
      _activeTrack = ServerPackage().fromID(id);
      setSessionState(SessionState.Run);
   }

   void setTrack(String trackID) {
      _getTrack(trackID);
      //_manualPackage(trackID);
   }

   Track getTrack() => _activeTrack;

   void promptNextActivity(BuildContext context) {
      int activityIndex = _activeTrack
          .activityIndex[_visitingIndex]; // Collects the correct index for the next activity
      _onVisited(_activeTrack.stations[_visitingIndex]);

      ActivityManager()
          .newActivity(
          context: context, package: _activeTrack.activities[activityIndex])
          .then((
          AnswerPackage answerPackage) { // Launch activity from id instead of index?
         _answerHistory.add(answerPackage);

         _visitingIndex++;

         if (_visitingIndex >= _activeTrack.stations.length) {
            print("Track finished");
            _lapCompleted = true; // Used to increment lap count statistic
            setSessionState(SessionState.Finished);
            statSetter();
         }
      });
   }

   void addStateListener(Function(SessionState state) function) {
      _stateListeners.add(function);
   }

   void addOnVisitedListeners(Function(Station station) function) {
      _onVisitedListeners.add(function);
   }

   void setSessionState(SessionState state) {
      _activeState = state;
      _onStateChange();
   }

   void addTrackHistory(LatLng latLng) {
      _trackHistory.add(latLng);
   }

   bool getAnswer(int i) {
      return _answerHistory[i] ?? false;
   }

   int getNumAnsweredQuestion() {
      return _answerHistory.length;
   }

   int getNumVisitedStations() {
      return _visitedStations.length;
   }

   void setNumSteps(int steps) {
      _numSteps = steps;
   }

   int getNumSteps() {
      return _numSteps;
   }

   bool didCompleteLap() {
      return _lapCompleted;
   }

   void _onStateChange() {
      for (Function f in _stateListeners) {
         f(_activeState);
      }
   }

   void _onVisited(Station station) {
      _visitedStations.add(station);
      for (Function f in _onVisitedListeners) {
         f(station);
      }
   }

   // TODO receive geoCache prompt with station ID and initiate activityManager
   // TODO launch activity from station ID

   void flush() {
      setSessionState(SessionState.Start);
      //_activeState = null;
      _activeTrack = null;
      _stateListeners = [];
      _onVisitedListeners = [];
      _visitedStations = [];
      _trackHistory = [];
      _answerHistory = [];
      _lapCompleted = false;
      _visitingIndex = 0;
      _numSteps = 0;
   }

   bool updateStatsDB() {
      return false;
   }

   void statSetter() async
   {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int newValueLaps = _lapCompleted ? 1 : 0;
      int newValueRuntime = 0;
      int newValueQA = _answerHistory.length;
      int newValueSteps = _numSteps;

      if (prefs.getBool("isguest")) {
         prefs.setInt("g_laps", prefs.getInt("g_laps") + newValueLaps);
         prefs.setInt("g_runtime", prefs.getInt("g_runtime") + newValueRuntime);
         prefs.setInt("g_qa", prefs.getInt("g_qa") + newValueQA);
         prefs.setInt("g_steps", newValueSteps + prefs.getInt("g_steps"));
      }
      else if (updateStatsDB()) {
         //get database data if there is any
      }
      else {
         prefs.setInt("laps", prefs.getInt("laps") + newValueLaps);
         prefs.setInt("runtime", prefs.getInt("runtime") + newValueRuntime);
         prefs.setInt("qa", prefs.getInt("qa") + newValueQA);
         prefs.setInt("steps", prefs.getInt("steps") + newValueSteps);
      }
   }
}
