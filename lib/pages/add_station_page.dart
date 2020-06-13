import 'package:flutter/material.dart';

class AddStationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddStationPageState();
  }
}

/// Placeholder page for adding user-created stations to our database.
class _AddStationPageState extends State<AddStationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(
              Icons.build,
              size: 80.0,
              color: Theme.of(context).accentColor,
            ),
          ),
          Text(
            "Ej implementerad!",
            style: Theme.of(context).textTheme.headline,
          ),
          Divider(),
          Text(
            "På denna skärm kommer du kunna skapa egna orienteringskontroller och ladda upp till vår databas. "
            "Tyvärr är detta inte tillgängligt ännu, men håll ögonen öppna på framtida versioner!",
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
