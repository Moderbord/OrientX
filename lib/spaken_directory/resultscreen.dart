import 'package:flutter/material.dart';
import 'package:orientx/fredrik_directory/track.dart';
import 'package:orientx/spaken_directory/activitymanager.dart';

class ResultScreen
{


   void orderActivity(BuildContext context, Track track, )
   {
      int i = track.popNext();
      //Event
      ActivityManager().newActivity(context: context, package: track.activities[i]);

      // Save result

      // if last result > show score screen
      if (track.wasLast())
      {
         print("WAS LAST");
      }
    }

}

