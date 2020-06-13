import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:orientx/backend/activity/activitypackage.dart';

/// Widget that handles button functionality
class ExtendedCheckboxGroup extends StatefulWidget {
  final List<String> labels;
  final QuestionType type;
  final void Function(List<String> anwsers) onClick;

  ExtendedCheckboxGroup({
    @required this.labels,
    @required this.type,
    @required this.onClick,
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
        widget.type == QuestionType.Single
            ? RadioButtonGroup(
                labels: widget.labels,
                onSelected: (String selected) {
                  setState(() {
                    buttonIsDisabled = false;
                    answers.clear();
                    answers.add(selected);
                  });
                },
              )
            : CheckboxGroup(
                labels: widget.labels,
                onSelected: (List<String> selected) {
                  setState(() {
                    buttonIsDisabled = selected.isEmpty;
                    answers = selected;
                  });
                },
              ),
        RaisedButton(
          onPressed: buttonIsDisabled ? null : () => widget.onClick(answers),
          child: Text('Answer'),
        )
      ],
    );
  }
}
