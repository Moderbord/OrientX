import 'package:flutter/material.dart';

import 'station.dart';
import 'track.dart';

import 'package:orientx/spaken_directory/activesession.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Track track = ActiveSession().getTrack();
    int stations = (track == null) ? 0 : track.activities.length;

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.flag, size: 40.0,),
              SizedBox(width: 10),
              Text(
                "Du är i mål!",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text("3/3 rätta svar!",
          style: TextStyle(fontSize: 25.0, color: Colors.green),),
          SizedBox(height: 20.0),
          Card(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset("assets/images/qr.png"),
            ),
          ),
          Text("Visa QR-koden för din lärare", style: TextStyle(color: Colors.black54),),
          SizedBox(height: 20.0),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: stations,
              itemBuilder: (BuildContext context, int index) {
                bool correct = true;

                return Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        correct ? Icons.check_circle : Icons.cancel,
                        color: correct ? Colors.green : Colors.red,
                        size: 30.0,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          track.getStationFromIndex(index).name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          "Du svarade N/A, men rätt svar var N/A!",
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
