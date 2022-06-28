import 'dart:math';

// Amazingly dart doesnt have double rounding as standard!

double roundDouble(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}
