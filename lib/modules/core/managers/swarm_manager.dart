//import 'dart:async';

import 'package:flutter/material.dart';
import '../models/agent_state.dart';

class SwarmManager extends ChangeNotifier {
  int swarmSize = 0;
  var swarmArray = [];
  void initialiseSwarm(int newSwarmSize) {
    swarmSize = newSwarmSize;
    swarmArray.clear();
    for (int i = 0; i < newSwarmSize; i++) {
      //Quick and hacky, only allows 9 drones and have to be sequential
      //fix later!!
      swarmArray.add(AgentState('P10' + (i + 1).toString()));
    }
  }
}
