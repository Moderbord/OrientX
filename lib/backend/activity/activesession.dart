import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:orientx/backend/data/track.dart';
import 'package:orientx/backend/data/station.dart';
import 'package:orientx/backend/managers/activitymanager.dart';
import 'package:orientx/backend/activity/answerpackage.dart';
import 'package:orientx/backend/db/serverpackage.dart';
import 'package:orientx/backend/activity/activitypackage.dart';
import 'package:orientx/backend/db/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SessionState { Start, Run, Result, Finished }

/// Singleton class which handles an active session (Track)
///
class ActiveSession {
  static final ActiveSession _activeSession = ActiveSession._internal();

  factory ActiveSession() {
    return _activeSession;
  }

  ActiveSession._internal() {
    _activeState = SessionState.Start;
  }

  SessionState _activeState;
  Track _activeTrack;
  List<Function(SessionState state)> _stateListeners = [];
  List<Function(Station station)> _onVisitedListeners = [];
  List<Station> _visitedStations = [];
  List<LatLng> _trackHistory = [];
  List<AnswerPackage> _answerHistory = [];

  bool _lapCompleted = false;
  int _visitingIndex = 0;
  int _numSteps = 0;

  /// Retrieves track from database and switches state
  _getTrack(String trackID) {
    Database.getInstance()
        .getTrack(trackID)
        .then((Track track) // TODO exception handling on track ID
            {
      print("track fetched");
      _activeTrack = track;

      setSessionState(SessionState.Run);
    });
  }

  /// Manual package defined in serverpackage.dart
  _manualPackage(String id) {
    _activeTrack = ServerPackage().fromID(id);
    setSessionState(SessionState.Run);
  }

  /// Sets which track that should be used
  void setTrack(String trackID) {
    _getTrack(trackID);      // server
    //_manualPackage(trackID); // local
  }

  /// Returns active Track
  Track getTrack() => _activeTrack;

  /// Launches next Activity in queue
  void promptNextActivity(BuildContext context) {
    int activityIndex = _activeTrack.activityIndex[
        _visitingIndex]; // Collects the correct index for the next activity
    _onVisited(_activeTrack.stations[_visitingIndex]);

    ActivityManager()
        .newActivity(
            context: context, package: _activeTrack.activities[activityIndex])
        .then((AnswerPackage answerPackage) {
      // Launch activity from id instead of index?
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

  int getNumAnsweredQuestion() {
    return _answerHistory.length;
  }

  AnswerPackage getAnswer(int i) {
    return _answerHistory.length > i
        ? _answerHistory[i]
        : AnswerPackage(result: Result.TimedOut);
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

  /// Clears session values
  void flush() {
    setSessionState(SessionState.Start);
    //_activeState = null;
    _activeTrack = null;
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

  /// Saves user statistics
  void statSetter() async {
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
    } else if (updateStatsDB()) {
      //get database data if there is any
    } else {
      prefs.setInt("laps", prefs.getInt("laps") + newValueLaps);
      prefs.setInt("runtime", prefs.getInt("runtime") + newValueRuntime);
      prefs.setInt("qa", prefs.getInt("qa") + newValueQA);
      prefs.setInt("steps", prefs.getInt("steps") + newValueSteps);
    }
  }
}
