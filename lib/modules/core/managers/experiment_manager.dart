//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import '../models/agent_state.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';

class ExperimentManager {
  // may need to be a change notifier if we need to notify of updates to values
  LatLng _referencePoint = LatLng(53.43578053111544, -2.250343561172483);
  String _selectedExperimentType = 'Single';
  double _corridorRadius = 1;
  double _selectedMajorRadius = 1;
  double _selectedMinorRadius = 1;
  int _selectedPointsNumber = 1;

  void setReferencePoint(LatLng referencePoint) {
    _referencePoint = referencePoint;
  }

  LatLng get getReferencePoint => _referencePoint;
}
