import 'package:flutter/material.dart';

/// A way to represent a "destination" in flutter, i.e. a page with icon.
class Destination {
  const Destination(this.index, this.title, this.icon, this.screen);
  final int index;
  final String title;
  final IconData icon;
  final Widget screen;
}