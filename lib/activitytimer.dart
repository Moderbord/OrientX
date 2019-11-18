import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final int time;

  ActivityTimer({this.time});

  @override
  State<StatefulWidget> createState() {
    return _ActivityTimerState();
  }
}

class _ActivityTimerState extends State<ActivityTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.time));
    controller.reverse(from: controller.value == 0.0 ? 1.0 : widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return LinearProgressIndicator(value: controller.value);
      },
    );
  }
}
