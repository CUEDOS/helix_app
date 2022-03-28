import 'dart:math';
import 'package:tuple/tuple.dart';

// Generates points for a single ellipse corridor
List<List<double>> singleEllipse(
    int numPoints, double aEllipse, double bEllipse) {
  List<List<double>> corridorPoints = [];
  for (int i = 0; i < numPoints; i++) {
    corridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints),
      bEllipse * sin(i * 6.28 / numPoints),
      -20.0
    ]);
  }
  return corridorPoints;
}

// Generates points for a double ellipse corridor
Tuple2<List<List<double>>, List<List<double>>> doubleEllipse(int numPoints,
    double aEllipse, double bEllipse, double xOffset, double yOffset) {
  List<List<double>> redCorridorPoints = [];
  List<List<double>> blueCorridorPoints = [];
  for (int i = 0; i < numPoints; i++) {
    redCorridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) + xOffset,
      bEllipse * sin(i * 6.28 / numPoints) + yOffset,
      -20
    ]);
    blueCorridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) - xOffset,
      bEllipse * sin(i * 6.28 / numPoints) - yOffset,
      -20
    ]);
  }
  return Tuple2(redCorridorPoints, blueCorridorPoints);
}

//Generates points for a figure 8 corridor
List<List<double>> figureEight(
    int numPoints, double aEllipse, double bEllipse, double xOffset) {
  List<List<double>> corridorPoints = [];
  for (int i = 0; i < numPoints; i++) {
    corridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) - xOffset,
      -1 * bEllipse * sin(i * 6.28 / numPoints),
      -20
    ]);
  }
  for (int i = 0; i < numPoints; i++) {
    corridorPoints.add([
      -1 * aEllipse * cos(i * 6.28 / numPoints) + xOffset,
      -1 * bEllipse * sin(i * 6.28 / numPoints),
      -20
    ]);
  }
  return corridorPoints;
}
