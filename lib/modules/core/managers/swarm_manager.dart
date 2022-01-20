import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import '../models/agent_state.dart';

class SwarmManager extends ChangeNotifier {
  int swarmSize = 0;
  //var swarm = new Map();
  var swarm = <String, AgentState>{}; // linter prefers this to map
  late MQTTManager _mqttManager;

  void initialiseSwarm(int newSwarmSize) {
    swarmSize = newSwarmSize;
    swarm.clear();
    for (int i = 0; i < newSwarmSize; i++) {
      //Quick and hacky, only allows 9 drones and have to be sequential
      //fix later!!
      String id = 'P10' + (i + 1).toString();
      swarm[id] = AgentState(id);
    }
  }

  void subscribeToSwarm(BuildContext context) {
    _mqttManager = Provider.of<MQTTManager>(context);

    //_mqttManager.subscribeTo();
  }
}
