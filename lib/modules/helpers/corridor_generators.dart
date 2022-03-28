import 'dart:math';
import 'package:tuple/tuple.dart';

// Generates points for a single ellipse corridor
List<List> singleEllipse(int numPoints, double aEllipse, double bEllipse) {
  List<List> corridorPoints = [];
  for (int i = 0; i <= numPoints; i++) {
    corridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints),
      bEllipse * sin(i * 6.28 / numPoints),
      5
    ]);
  }
  return corridorPoints;
}

// Generates points for a double ellipse corridor
Tuple2<List<List>, List<List>> doubleEllipse(int numPoints, double aEllipse,
    double bEllipse, double xOffset, double yOffset) {
  List<List> redCorridorPoints = [];
  List<List> blueCorridorPoints = [];
  for (int i = 0; i <= numPoints; i++) {
    redCorridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) + xOffset,
      bEllipse * sin(i * 6.28 / numPoints) + yOffset,
      5
    ]);
    blueCorridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) - xOffset,
      bEllipse * sin(i * 6.28 / numPoints) - yOffset,
      5
    ]);
  }
  return Tuple2(redCorridorPoints, blueCorridorPoints);
}

//Generates points for a figure 8 corridor
List<List> figureEight(
    int numPoints, double aEllipse, double bEllipse, double xOffset) {
  List<List> corridorPoints = [];
  for (int i = 0; i <= numPoints; i++) {
    corridorPoints.add([
      aEllipse * cos(i * 6.28 / numPoints) - xOffset,
      -1 * bEllipse * sin(i * 6.28 / numPoints),
      5
    ]);
  }
  for (int i = 0; i <= numPoints; i++) {
    corridorPoints.add([
      -1 * aEllipse * cos(i * 6.28 / numPoints) + xOffset,
      -1 * bEllipse * sin(i * 6.28 / numPoints),
      5
    ]);
  }
  return corridorPoints;
}
