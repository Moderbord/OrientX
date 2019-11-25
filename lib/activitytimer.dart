import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final int time;
  final void Function() onFinish;
  void Function() onBreak;

  ActivityTimer({this.time, this.onFinish});

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
    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        widget.onFinish();
      }
    });
    controller.reverse(from: controller.value == 0.0 ? 1.0 : widget.time);
    widget.onBreak = () => controller.dispose();
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
