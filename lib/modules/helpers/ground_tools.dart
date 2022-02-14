//import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:helixio_app/modules/core/models/agent_state.dart';

Map<String, double> altCalc(
    Map<String, AgentState> swarm, double siteElevation) {
  Map<String, double> swarmAltitudes = {};

  //swarmAltitudes = swarm.values.

  for (var agent in swarm.keys) {
    swarmAltitudes[agent] = swarm[agent]!.getabsoluteAltitude;
  }

  double minAlt = 10 + siteElevation;
  double maxAlt = 100 + siteElevation;
  double altStep = 1; // altitude difference between the return alts

  int size = swarmAltitudes.length;

  List<String> sortedIds = sortMapKeysByValue(swarmAltitudes);

  // calculates the mean of current altitudes
  double mean = swarmAltitudes.values.sum / size;

  // used to center the return altitudes around the mean
  final double centeringConst = (size - 1) / 2;

  //creates a list of altitudes centered around the mean with a spacing of altStep
  var sortedReturnAlts =
      List<double>.generate(size, (i) => (i - centeringConst) * altStep + mean);

  // check minimum and maximum altitude
  if (sortedReturnAlts[0] < minAlt) {
    var difference = minAlt - sortedReturnAlts[0];
    // increase every altitude by the difference
    sortedReturnAlts.map((val) => val + difference);
  }
  if (sortedReturnAlts.last > maxAlt) {
    var difference = sortedReturnAlts.last - maxAlt;
    // reduce every altitude by the difference
    sortedReturnAlts.map((val) => val - difference);
  }

  Map<String, double> sortedSwarmMap =
      Map.fromIterables(sortedIds, sortedReturnAlts);

  return sortedSwarmMap;
}

// Function which sorts the keys of a map by their corresponding value in ascending order
List<String> sortMapKeysByValue(Map<String, double> inputMap) {
  List<String> sortedKeys = inputMap.keys.toList(growable: false)
    ..sort((k1, k2) => inputMap[k1]!.compareTo(inputMap[k2]!));

  // LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
  //     key: (k) => k, value: (k) => inputMap[k]);

  return sortedKeys;
}
