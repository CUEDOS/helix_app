//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helixio_app/modules/core/managers/MQTTManager.dart';
import 'package:helixio_app/modules/core/models/MQTTAppState.dart';
import 'package:helixio_app/modules/core/widgets/status_bar.dart';
//import 'package:helixio_app/modules/helpers/screen_route.dart';
import 'package:helixio_app/modules/helpers/status_info_message_utils.dart';
import 'package:helixio_app/pages/page_scaffold.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();

  late MQTTManager _manager;

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }

    return PageScaffold(title: 'Control', body: _buildColumn(_manager));
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              _buildControlButton(
                  manager.currentState.getAppConnectionState, 'Arm', 'arm'),
              _buildControlButton(manager.currentState.getAppConnectionState,
                  'Takeoff', 'takeoff'),
              _buildControlButton(
                  manager.currentState.getAppConnectionState, 'Hold', 'hold'),
              _buildControlButton(manager.currentState.getAppConnectionState,
                  'Return', 'return'),
              _buildControlButton(
                  manager.currentState.getAppConnectionState, 'Land', 'land'),
              _buildControlButton(
                  manager.currentState.getAppConnectionState, 'Start', 'start'),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
              //alignment: WrapAlignment.start,
              children: <Widget>[
                _buildInfoCard('P101', 'Disconnected', 100, 50, 'HOLD'),
                _buildInfoCard('P102', 'Disconnected', 100, 50, 'HOLD'),
                _buildInfoCard('P103', 'Disconnected', 100, 50, 'HOLD'),
              ]),
        ),
      ],
    );
  }

  Widget _buildControlButton(
      MQTTAppConnectionState state, String buttonText, String command) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(88, 36),
            //primary: Colors.deepOrange
          ),
          onPressed: state == MQTTAppConnectionState.connected
              ? () {
                  _publishMessage('commands', command);
                }
              : null,
        ));
  }

  Widget _buildInfoCard(String droneID, String connectionStatus,
      int batteryPercentage, int wifiStrength, String currentCommand) {
    return SizedBox(
      width: 150.0,
      //height: 300.0,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //dense: true,
              //leading: Icon(Icons.airplanemode_active),
              title: Text(droneID),
              subtitle: Text(connectionStatus),
            ),
            const Divider(
              height: 0,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: Colors.grey,
            ),
            //const SizedBox(width: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.battery_full_sharp),
                      Text(batteryPercentage.toString() + '%'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.wifi),
                      Text(wifiStrength.toString() + 'dB'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.airplanemode_active),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      color: Colors.green,
                      child: Center(child: Text(currentCommand)),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: const Text('SELECT'),
                onPressed: () {/* ... */},
              ),
            ),
            //const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _publishMessage(String topic, String message) {
    _manager.publish('commands', message);
    _messageTextController.clear();
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
