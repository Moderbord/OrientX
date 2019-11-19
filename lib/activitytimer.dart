import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final int time;
  final void Function() onFinish;

  ActivityTimer({this.time, this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return _ActivityTimerState();
  }
}

class _ActivityTimerState extends State<ActivityTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.time));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        widget.onFinish();
      }
    });
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return LinearProgressIndicator(value: _controller.value);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
