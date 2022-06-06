//import 'package:provider/provider.dart';
//import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

// import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
// import '../models/agent_state.dart';
// import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:helixio_app/modules/helpers/corridor_generators.dart';

class ExperimentManager {
  // may need to be a change notifier if we need to notify of updates to values
  LatLng referencePoint = LatLng(52.81634212236934, -4.12765441075898);
  String selectedExperimentType = 'Single';
  double corridorRadius = 5;
  double selectedMajorRadius = 30;
  double selectedMinorRadius = 20;
  int selectedPointsNumber = 1;
  int _mapPointsNumber = 20;
  List<List<double>> pointsForMap = [];

  void generatePointsForMap() {
    switch (selectedExperimentType) {
      case 'Single':
        {
          pointsForMap = singleEllipse(
              _mapPointsNumber, selectedMajorRadius, selectedMinorRadius);
        }
        break;

      case 'Double':
        {
          //statements;
        }
        break;

      case 'Figure 8':
        {
          pointsForMap = figureEight(_mapPointsNumber, selectedMajorRadius,
              selectedMinorRadius, selectedMajorRadius);
        }
        break;
      case 'Line':
        {
          //statements;
        }
        break;
    }
  }
}
