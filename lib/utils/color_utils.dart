import 'package:flutter/material.dart';

class ColorUtils {
  static Color lightenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(color, Colors.white, amount)!;
  }

  static Color blend(Color a, Color b, double t) {
    int r = (a.red * (1 - t) + b.red * t).round();
    int g = (a.green * (1 - t) + b.green * t).round();
    int b_ = (a.blue * (1 - t) + b.blue * t).round();
    return Color.fromARGB(255, r, g, b_);
  }
}
