import 'package:flutter/material.dart';

class Destination {
  const Destination(this.index, this.title, this.icon, this.screen);
  final int index;
  final String title;
  final IconData icon;
  final Widget screen;
}