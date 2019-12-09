import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orientx/spaken_directory/activitypackage.dart';

class Database {
  final databaseReference = Firestore.instance;

  static Database _database;

  _Database() {}

  static Database getInstance() {
    if (_database == null) {
      _database = new Database();
    }
    return _database;
  }

/*  void createRecord(String collection, String doc, ) async {
    await databaseReference
        .collection("testboop")
        .document("1")
        .setData({'title': 'bladibla', 'desc': 'ladida'});
    DocumentReference docRef = await databaseReference
        .collection("testboop")
        .add({'title': 'WOOOOP', 'desc': 'slurpad'});
    print(docRef.documentID);
  }*/

  Future<List<ActivityPackage>> getData() async {
    List<ActivityPackage> pList = [];
    await databaseReference
        .collection("Activity")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      pList = toPackages(snapshot);
    });
    return pList;
  }

  List<ActivityPackage> toPackages(QuerySnapshot snapshot) {
    List<ActivityPackage> packageList = [];
    snapshot.documents.forEach((f) {
      Map<String, dynamic> tmpMap = f.data;

      List<dynamic> tmp = tmpMap['Answers'];
      List<String> answers = tmp.cast<String>();

      tmp = tmpMap['Questions'];
      List<String> questions = tmp.cast<String>();

      ActivityPackage package = new ActivityPackage(
          activityName: tmpMap['ActivityName'],
          id: tmpMap['ID'],
          description: tmpMap['Desc'],
          answers: answers,
          dataSource: tmpMap['DataSrc'],
          dataType: DataType.values[tmpMap['DataType']],
          duration: tmpMap['Duration'],
          questions: questions,
          questionType: QuestionType.values[tmpMap['QuestType']]);

      packageList.add(package);
    });
    return packageList;
  }

/*  void deleteData(String collection, String doc) {
    try {
      databaseReference
          .collection('testboop')
          .document('1')
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }*/
}
