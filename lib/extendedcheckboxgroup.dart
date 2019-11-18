import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class ExtendedCheckboxGroup extends StatefulWidget {
  final List<String> labels;

  ExtendedCheckboxGroup({
    @required this.labels,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExtendedCheckboxGroupState();
  }
}

class _ExtendedCheckboxGroupState extends State<ExtendedCheckboxGroup> {
  bool buttonIsDisabled = true;
  List<String> answers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CheckboxGroup(
            labels: widget.labels,
            onSelected: (List<String> selected) {
              setState(() {
                buttonIsDisabled = selected.isEmpty;
                answers = selected;
              });
            }),
        RaisedButton(
          onPressed:
              buttonIsDisabled ? null : () => Navigator.pop(context, answers),
          child: Text('Answer'),
        )
      ],
    );
  }
}
