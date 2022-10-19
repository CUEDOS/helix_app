//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helixio_app/modules/helpers/service_locator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/mqtt_app_state.dart';
import 'package:helixio_app/modules/core/managers/swarm_manager.dart';
import 'dart:async';
import '../models/agent_state.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:latlng/latlng.dart';
import 'package:helixio_app/modules/helpers/coordinate_conversions.dart'
    show NED;

class MQTTManager extends ChangeNotifier {
  // Private instance of client
  //late SwarmManager _swarmManager;
  MQTTAppState _currentState = MQTTAppState();
  MqttServerClient? _client;
  late String _identifier;
  String? _host;
  String _topic = "";

  void initializeMQTTClient({
    required String host,
    required String identifier,
  }) {
    // Save the values
    // TODO: If already connected throw error
    // TODO: Remove forced unwrap usage and assertion
    _identifier = identifier;
    _host = host;
    _client = MqttServerClient(_host!, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.autoReconnect = true; // added to make connection more stable
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;
    _client!.onUnsubscribed = onUnsubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        //.authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    //print('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  String? get host => _host;
  MQTTAppState get currentState => _currentState;
  // Connect to the host
  void connect() async {
    assert(_client != null);
    try {
      //print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client!.connect();
    } on Exception catch (e) {
      //print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

// Added topic arument which might break existing code
  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Future<void> sendCommand(String agent, String command) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(command);
    int iterator = 0;

    switch (command) {
      case 'arm':
        Timer.periodic(const Duration(seconds: 1), (timer) {
          iterator += 1;
          _client!.publishMessage(
              'commands/' + agent, MqttQos.exactlyOnce, builder.payload!);
          if ((serviceLocator<SwarmManager>().swarm[agent]?.getArmStatus ==
                  true) |
              (iterator == 5)) {
            timer.cancel();
          }
        });
        break;

      case 'takeoff':
        Timer.periodic(const Duration(seconds: 1), (timer) {
          iterator += 1;
          _client!.publishMessage(
              'commands/' + agent, MqttQos.exactlyOnce, builder.payload!);
          if ((serviceLocator<SwarmManager>().swarm[agent]?.getFlightMode ==
                  'TAKEOFF') |
              (iterator == 5)) {
            timer.cancel();
          }
        });
        break;

      case 'hold':
        Timer.periodic(const Duration(seconds: 1), (timer) {
          iterator += 1;
          _client!.publishMessage(
              'commands/' + agent, MqttQos.exactlyOnce, builder.payload!);
          if ((serviceLocator<SwarmManager>().swarm[agent]?.getFlightMode ==
                  'HOLD') |
              (iterator == 5)) {
            timer.cancel();
          }
        });
        break;

      default:
        {
          _client!.publishMessage(
              'commands/' + agent, MqttQos.exactlyOnce, builder.payload!);
        }
        break;
    }
    //final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    //builder.addString(command);
    //_client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    //print('EXAMPLE::Subscription confirmed for topic $topic');
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String? topic) {
    //print('EXAMPLE::onUnsubscribed confirmed for topic $topic');
    _currentState.clearText();
    _currentState
        .setAppConnectionState(MQTTAppConnectionState.connectedUnSubscribed);
    updateState();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    //print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      //print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.clearText();
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();

    // so that agents can be detected
    subscribeTo('detection');

    //print('EXAMPLE::Mosquitto client connected....');
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      // final String payload =
      //     MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //serviceLocator<SwarmManager>().handleMessage(c[0].topic, recMess.payload.message.buffer.asByteData());
      //var payload = recMess.payload.message;

      handleMessage(c[0].topic, recMess);
    });
  }

  void handleMessage(String topic, MqttPublishMessage recMess) {
    //recMess.payload.message.buffer.asByteData();
    var swarm = serviceLocator<SwarmManager>().swarm;
    var topicArray = topic.split('/');
    // check if the message is on the detection topic
    if (topicArray[0] == 'detection') {
      String strPayload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //add an agent to the swarm
      if (!swarm.containsKey(strPayload)) {
        swarm[strPayload] = AgentState(strPayload);
        serviceLocator<MQTTManager>().subscribeTo(strPayload + '/#');
      }
    } else {
      // if the top level topic isnt detection it must be a drone id
      String id = topicArray[0];
      switch (topicArray[1]) {
        case 'connection_status':
          swarm[id]?.setConnected(MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message));
          break;
        case 'flight_mode':
          swarm[id]?.setFlightMode(MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message));
          break;
        case 'battery_level':
          swarm[id]?.setBatteryLevel(int.parse(
              MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message)));
          break;
        case 'wifi_strength':
          swarm[id]?.setWifiStrength(int.parse(
              MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message)));
          break;
        case 'T':
          ByteData bytesPayload = recMess.payload.message.buffer.asByteData();
          swarm[id]?.setGeodetic(
              LatLng(bytesPayload.getFloat32(0), bytesPayload.getFloat32(4)),
              bytesPayload.getFloat32(8));

          swarm[id]?.setNED(NED(bytesPayload.getFloat32(12),
              bytesPayload.getFloat32(16), bytesPayload.getFloat32(20)));

          swarm[id]?.setHeading(bytesPayload.getFloat32(36));
          break;
      }
      serviceLocator<SwarmManager>().update();
    }
  }

  void subscribeTo(String topic) {
    // Save topic for future use
    _topic = topic;
    _client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  /// Unsubscribe from a topic
  void unSubscribe(String topic) {
    _client!.unsubscribe(topic);
  }

  /// Unsubscribe from a topic
  void unSubscribeFromCurrentTopic() {
    _client!.unsubscribe(_topic);
  }

  void updateState() {
    //controller.add(_currentState);
    notifyListeners();
  }
}
