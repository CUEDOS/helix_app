import 'dart:math';

import 'package:helixio_app/modules/core/models/agent_state.dart';
import 'package:helixio_app/modules/helpers/coordinate_conversions.dart'
    show NED;

// bool isClose(NED p1, NED p2) {
//   double squaredThreshold = 6.25;
//   final squaredDistance = pow(p2.north - p1.north, 2) +
//       pow(p2.east - p1.east, 2) +
//       pow(p2.east - p1.east, 2);
//   if (squaredDistance < squaredThreshold) {
//     return true;
//   }
//   return false;
// }

double getSquaredDistance(NED p1, NED p2) {
  return (pow(p2.north - p1.north, 2) +
          pow(p2.east - p1.east, 2) +
          pow(p2.down - p1.down, 2))
      .toDouble();
}

//change to efficient algorithm later
void checkProximity(Map<String, AgentState> swarm) {
  // Map<String, List<String>> closePairs = {};
  List<String> checked = [];
  double squaredThreshold = 6.25;
  // for (var agent in swarm.keys) {
  //   closePairs[agent] = [];
  // }
  swarm.forEach((agent1, agentState1) {
    swarm.forEach((agent2, agentState2) {
      if (!checked.contains(agent2) && agent1 != agent2) {
        double squaredDistance =
            getSquaredDistance(agentState1.getNED, agentState2.getNED);
        bool isClose = squaredDistance < squaredThreshold;
        if (isClose) {
          double distance = sqrt(squaredDistance);
          swarm[agent1]?.addCloseTo(agent2, distance);
          swarm[agent2]?.addCloseTo(agent1, distance);
        } else if (!isClose && swarm[agent1]!.getCloseTo.containsKey(agent2)) {
          swarm[agent1]?.removeCloseTo(agent2);
          swarm[agent2]?.removeCloseTo(agent1);
        }
      }
    });
    checked.add(agent1);
  });

  // swarm[agent1]?.removeCloseTo(agent2);
  // swarm[agent2]?.removeCloseTo(agent1);

  // closePairs.forEach((key, value) {
  //   swarm[key]?.setCloseTo(value);
  // });
}


//d = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)