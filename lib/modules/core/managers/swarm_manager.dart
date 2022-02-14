//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

import 'package:helixio_app/modules/core/managers/mqtt_manager.dart';
import '../models/agent_state.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';

class SwarmManager extends ChangeNotifier {
  int swarmSize = 0;
  var swarm = <String, AgentState>{}; // linter prefers this to map
  List<String> selected = [];

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

  void addSelected(String id) {
    selected.add(id);
  }

  void removeSelected(String id) {
    selected.remove(id);
  }

  void subscribeToSwarm(MQTTManager mqttManager) {
    //_mqttManager = Provider.of<MQTTManager>(context, listen: false);
    for (String id in swarm.keys) {
      // use wildcard to subscribe to all updates from each drone ID
      mqttManager.subscribeTo(id + '/#');
    }
  }

  List<double> decodeTelemetry(String telemetry) {
    //converts strings to doubles
    var stringArray = telemetry.split(', ');

    List<double> doubleArray = [];
    for (int i = 0; i < stringArray.length; i++) {
      doubleArray.add(double.parse(stringArray[i]));
    }

    return doubleArray;
  }

  void handleMessage(String topic, String payload) {
    var topicArray = topic.split('/');
    // check if the message is on the detection topic
    if (topicArray[0] == 'detection') {
      //add an agent to the swarm
      swarm[payload] = AgentState(payload);
      serviceLocator<MQTTManager>().subscribeTo(payload + '/#');
    } else {
      // if the top level topic isnt detection it must be a drone id
      String id = topicArray[0];
      switch (topicArray[1]) {
        case 'connection_status':
          swarm[id]?.setConnected(payload);
          break;
        case 'flight_mode':
          swarm[id]?.setFlightMode(payload);
          break;
        case 'battery_level':
          swarm[id]?.setBatteryLevel(int.parse(payload));
          break;
        case 'wifi_strength':
          swarm[id]?.setWifiStrength(int.parse(payload));
          break;
        case 'telemetry':
          switch (topicArray[2]) {
            case 'geodetic':
              // geodetic message needs to be decoded
              var geodeticTelem = decodeTelemetry(payload);
              swarm[id]?.setGeodetic(
                  LatLng(geodeticTelem[0], geodeticTelem[1]), geodeticTelem[2]);
              break;
            case 'heading':
              swarm[id]?.setHeading(double.parse(payload));
              break;
            case 'position_ned':
              // position message needs to be decoded
              break;
          }
      }
      notifyListeners();
    }
  }
}
