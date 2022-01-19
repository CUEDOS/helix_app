//import 'dart:async';

import 'package:flutter/material.dart';
import '../models/agent_state.dart';

class SwarmManager extends ChangeNotifier {
  void initialiseSwarm(int swarmSize) {
    var swarmArray = [];
    for (int i = 0; i < swarmSize; i++) {
      //Quick and hacky, only allows 9 drones and have to be sequential
      //fix later!!
      swarmArray[i] = AgentState('P10' + (i + 1).toString());
    }
  }
}
