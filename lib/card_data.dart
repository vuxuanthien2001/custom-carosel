import 'package:flutter/material.dart';

class CardData {
  late double x, y, z, angle;
  final int idx;
  final Widget widget;

  CardData(this.idx, this.widget) {
    x = 0;
    y = 0;
    z = 0;
    angle = 0;
  }
}
