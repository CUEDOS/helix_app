//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import '../models/agent_state.dart';

class SwarmManager extends ChangeNotifier {
  int swarmSize = 0;
  //var swarm = new Map();
  var swarm = <String, AgentState>{}; // linter prefers this to map
  //late MQTTManager _mqttManager;

  void initialiseSwarm(int newSwarmSize, MQTTManager mqttManager) {
    swarmSize = newSwarmSize;
    swarm.clear();
    for (int i = 0; i < newSwarmSize; i++) {
      //Quick and hacky, only allows 9 drones and have to be sequential
      //fix later!!
      String id = 'P10' + (i + 1).toString();
      swarm[id] = AgentState(id);
    }
    subscribeToSwarm(mqttManager);
  }

  void subscribeToSwarm(MQTTManager mqttManager) {
    //_mqttManager = Provider.of<MQTTManager>(context, listen: false);
    for (String id in swarm.keys) {
      // use wildcard to subscribe to all updates from each drone ID
      mqttManager.subscribeTo(id + '/#');
    }
  }

  void handleMessage(String topic, String payload) {
    var topicArray = topic.split('/');
    String id = topicArray[0];
    switch (topicArray[1]) {
      case 'connection_status':
        swarm[id]?.setConnected(payload);
        break;
      case 'battery_level':
        swarm[id]?.setBatteryLevel(int.parse(payload));
        break;
      case 'wifi_strength':
        swarm[id]?.setWifiStrength(int.parse(payload));
        break;
    }
    notifyListeners();
  }
}
